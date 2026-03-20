# -*- coding: utf-8 -*-
import git
import json
import os
import pathlib
import re
import shutil
import stat
import subprocess
import sys
import toml
import os.path as osp
import glob


dry_run = False


def update_merge(updated, other):
    for key, value in other.items():
        if (
            key in updated
            and isinstance(updated[key], dict)
            and isinstance(other, dict)
        ):
            update_merge(updated[key], value)
        else:
            updated[key] = value


def check_build_status(context):
    # Check that bv_maker steps had been done successfully in the right order

    build_info_file = context.soma_root / "conf" / "build_info.json"
    with open(build_info_file) as f:
        build_info = json.load(f)
    configure_step_info = build_info.get("brainvisa-cmake", {}).get("configure")
    if not configure_step_info:
        raise ValueError(
            f"No bv_maker configuration step information in {build_info_file}"
        )
    status = configure_step_info.get("status")
    if status != "succeeded":
        raise ValueError(f"bv_maker configuration step not successful: {status}")

    build_step_info = build_info.get("brainvisa-cmake", {}).get("build")
    if not build_step_info:
        raise ValueError(f"No bv_maker build step information in {build_info_file}")
    status = build_step_info.get("status")
    if status != "succeeded":
        raise ValueError(f"bv_maker build step not successful: {status}")
    if build_step_info.get("start") <= configure_step_info.get("stop"):
        raise ValueError("bv_maker build step started before the end of configuration.")

    doc_step_info = build_info.get("brainvisa-cmake", {}).get("doc")
    if not doc_step_info:
        raise ValueError(f"No bv_maker doc step information in {build_info_file}")
    status = doc_step_info.get("status")
    if status != "succeeded":
        raise ValueError(f"bv_maker doc step not successful: {status}")
    if doc_step_info.get("start") <= build_step_info.get("stop"):
        raise ValueError("bv_maker doc step started before the end of build.")


def modify_file(context, file, file_contents):
    print(f"Modify file {file}")
    with open(file, "w") as f:
        if isinstance(file_contents, dict):
            json.dump(file_contents, f, indent=4)
        else:
            f.write(file_contents)


def update_dict_file(context, file, update_dict):
    print(f"Update dict file {file}")
    with open(file) as f:
        contents = json.load(f)
    # merge dicts
    todo = [(contents, update_dict)]
    while todo:
        dst, src = todo.pop()
        for key, item in src.items():
            if isinstance(item, dict):
                node = dst.setdefault(key, {})
                todo.append((node, item))
            else:
                dst[key] = item
    with open(file, "w") as f:
        json.dump(contents, f, indent=4)


def git_commit(context, repo, modified, message):
    print(f"Commit in {repo}: {message}")
    if not dry_run:
        repo = git.Repo(repo)
        repo.git.add(*modified)
        repo.git.commit("-m", message, "-n")
        repo.git.push()


def git_push(context, repo, tags=False):
    if not dry_run:
        repo = git.Repo(repo)
        origin = repo.remote("origin")
        if tags:
            origin.push(tags=True)
        else:
            origin.push()


def git_tag(context, repo, component, tag, update_changeset=None):
    """ tag the component repo; get the component changeset and write it in the
    components JSON file (update_changeset is the JSON filename)
    """
    print(f"tag {repo}: {tag}")
    if not dry_run:
        repo = git.Repo(repo)
        repo.git.tag(tag)
        if update_changeset is not None:
            changeset = str(repo.head.commit)
            with open(update_changeset) as f:
                components = json.load(f)
            if components[component]["changeset"] != changeset:
                components[component]["changeset"] = changeset
                with open(update_changeset, "w") as f:
                    json.dump(components, f, indent=4)


def rebuild(context):
    subprocess.check_call(
        [
            "pixi",
            "run",
            "--manifest-path",
            str(context.soma_root / "pixi.toml"),
            "bv_maker",
            "configure",
            "build",
            "doc",
        ]
    )


def create_release_tag(context, tag):
    repo = git.Repo(context.soma_root)
    branch = repo.head.reference
    repo.git.checkout(repo.head.commit)
    conf_file = context.soma_root / "conf" / "soma-env.json"
    with open(conf_file) as f:
        conf = json.load(f)
    sources_conf_file = (
        context.soma_root / "conf" / "sources.d" / f"{conf['name']}.json"
    )
    with open(sources_conf_file) as f:
        sources_conf = json.load(f)
    conf["version"] = sources_conf["latest_release"]
    with open(conf_file, "w") as f:
        json.dump(conf, f, indent=4)
    if not dry_run:
        repo.git.add(str(conf_file))
        commit = repo.index.commit(f"Release {conf['name']} {conf['version']}")
        repo.create_tag(tag, ref=commit)
        branch.checkout()


def create_package(context, package, test):
    recipe_dir = context.soma_root / "plan" / "recipes" / package
    print(f"creating package {package} using test={test} from {recipe_dir}")
    output = context.soma_root / "plan" / "packages"
    build_dir = output / "bld" / f"rattler-build_{package}"
    if build_dir.exists():
        shutil.rmtree(build_dir)
    command = [
        "rattler-build",
        "build",
        "--experimental",
        "--no-build-id",
        "-r",
        recipe_dir,
        "--output-dir",
        str(output),
    ]
    if not test:
        command.append("--no-test")
    with open(context.soma_root / "pixi.toml") as f:
        pixi_toml = toml.load(f)
    channels = pixi_toml.get("workspace", pixi_toml.get("project", {})).get("channels", [])
    for i in [f"file://{output}"] + [i for i in channels if i not in ('pytorch', 'nvidia')]:
        command.extend(["-c", i])
    try:
        subprocess.check_call(command)
    except subprocess.CalledProcessError:
        print(
            "ERROR command failed:",
            " ".join(f"'{i}'" for i in command),
            file=sys.stderr,
            flush=True,
        )
        raise


def publish(
    context,
    publication_dir,
    packages_dir,
    packages,
    index=False,
    force=False,
):
    publication_dir = pathlib.Path(publication_dir)
    packages_dir = pathlib.Path(packages_dir)
    packages_files = []
    linux_64_files = list((packages_dir / "linux-64").iterdir())
    for package in packages:
        candidates = [
            i
            for i in linux_64_files
            if re.match(rf"{package}-\d+\.\d+(\.\d+)?-.+\.conda", i.name)
        ]
        if len(candidates) > 1:
            raise ValueError(
                f"Several packages files found for {package}: {', '.join(str(i) for i in candidates)}"
            )
        if not candidates:
            raise ValueError(f"No package file found for {package} in {packages_dir}")
        packages_files.append(candidates[0])
    copied = []
    try:
        for src in packages_files:
            r = src.relative_to(packages_dir)
            dest = publication_dir / r
            print(src, "->", dest)
            if not force and dest.exists():
                raise ValueError(f"Destination file {dest} already exist")
            if not dry_run:
                dest.parent.mkdir(exist_ok=True)
                shutil.copy2(src, dest)
                st = os.stat(dest)
                os.chmod(dest, st.st_mode | stat.S_IRUSR | stat.S_IRGRP | stat.S_IROTH)
            copied.append(dest)
        if index and not dry_run:
            subprocess.check_call(["conda", "index", str(publication_dir)])
    except Exception:
        if not dry_run:
            for f in copied:
                os.remove(f)
            raise


def neuro_forge_publish(
    context,
    nf_sources,
):
    print('neuro_forge_publish')
    cwd = os.getcwd()
    try:
        os.chdir(nf_sources)
        repo = git.Repo(context.soma_root)
        repo.git.pull(ff_only=True)
        cmd = ["pixi", "run", "neuro-forge", "publish"]
        if not dry_run:
            subprocess.check_call(cmd)
        else:
            print(" ".join(cmd))
    finally:
        os.chdir(cwd)


def install(
    context,
    install_dir,
    packages,
):
    print('install')
    cwd = os.getcwd()
    try:
        if osp.exists(install_dir):
            os.chdir(install_dir)
            cmd = ["pixi", "update", "brainvisa"]
            subprocess.check_call(cmd)
        else:
            os.makedirs(install_dir)
            os.chdir(install_dir)
            cmd = ["pixi", "init", "-c", "https://brainvisa.info/neuro-forge",
                   "-c", "conda-forge"]
            if osp.exists('/drf/neuro-forge/brainvisa-cea'):
                cmd += ["-c", "/drf/neuro-forge/brainvisa-cea"]
            subprocess.check_call(cmd)
            cmd = ["pixi", "add"] + packages
            subprocess.check_call(cmd)
        cmd = ["pixi", "run", "brainvisa", "-b", "--setup"]
        subprocess.check_call(cmd)
        cmd = ["pixi", "run", "bv_update_bin_links"]
        subprocess.check_call(cmd)

    finally:
        os.chdir(cwd)


def build_container(
    context,
    casa_distro_base,
    packages,
):
    print('build_container')
    conf_file = context.soma_root / "conf" / "soma-env.json"
    with open(conf_file) as f:
        conf = json.load(f)
    sources_conf_file = (
        context.soma_root / "conf" / "sources.d" / f"{conf['name']}.json"
    )
    with open(sources_conf_file) as f:
        sources_conf = json.load(f)
    version = sources_conf["latest_release"]
    print('version:', version)

    cwd = os.getcwd()
    path = os.environ['PATH']
    try:
        casa_distro = osp.join(context.soma_root, 'src', 'casa-distro')
        os.chdir(casa_distro)
        repo = git.Repo(casa_distro)
        repo.git.pull(ff_only=True)
        new_path = ':'.join([osp.join(casa_distro, 'bin'), path])
        os.environ['PATH'] = new_path
        os.chdir(casa_distro_base)

        os.environ["CASA_BASE_DIRECTORY"] = casa_distro_base
        cmd = ["casa_distro", "pull_image", "image=casa-pixi-5.4.sif"]
        subprocess.check_call(cmd)
        images = glob.glob("casa-pixi-5.4-*.sif")
        image = None
        maxnum = -1
        for image_t in images:
            print("image_t:", image_t)
            num = int(image_t.rsplit("-", 1)[1].split(".", 1)[0])
            print(num)
            if num > maxnum:
                image = image_t
                maxnum = num
        print('image:', image)

        cmd = ["casa_distro_admin", "create_user_image",
               "container_type=apptainer_pixi", "image_version=5.4",
               f"base_image={image}", f"version={version}",
               "distro=brainvisa"]
        # FIXME packages / distro
        subprocess.check_call(cmd)

    finally:
        os.chdir(cwd)
        os.environ['PATH'] = path


def install_container(
    context,
    casa_distro_base,
    install_dir,
):
    print('install_container')
    conf_file = context.soma_root / "conf" / "soma-env.json"
    with open(conf_file) as f:
        conf = json.load(f)
    sources_conf_file = (
        context.soma_root / "conf" / "sources.d" / f"{conf['name']}.json"
    )
    with open(sources_conf_file) as f:
        sources_conf = json.load(f)
    version = sources_conf["latest_release"]
    print('version:', version)

    path = os.environ['PATH']
    try:
        casa_distro = osp.join(context.soma_root, 'src', 'casa-distro')
        new_path = ':'.join([osp.join(casa_distro, 'bin'), path])
        os.environ['PATH'] = new_path

        os.environ["CASA_BASE_DIRECTORY"] = casa_distro_base

        image_base = f"brainvisa-{version}.sif"
        image = osp.join(casa_distro_base, image_base)
        shutil.copy2(image, install_dir)
        cont_install = osp.join(install_dir, f"brainvisa-casa-{version}")
        os.makedirs(cont_install)
        cmd = ["apptainer", "run", "-ce", "--bind",
               f"{cont_install}:/casa/setup",
               osp.join(install_dir, image_base)]
        subprocess.check_call(cmd)

    finally:
        os.environ['PATH'] = path


def pulish_container(
    context,
    casa_distro_base,
):
    print('publish_container')
    conf_file = context.soma_root / "conf" / "soma-env.json"
    with open(conf_file) as f:
        conf = json.load(f)
    sources_conf_file = (
        context.soma_root / "conf" / "sources.d" / f"{conf['name']}.json"
    )
    with open(sources_conf_file) as f:
        sources_conf = json.load(f)
    version = sources_conf["latest_release"]
    print('version:', version)

    path = os.environ['PATH']
    try:
        casa_distro = osp.join(context.soma_root, 'src', 'casa-distro')
        new_path = ':'.join([osp.join(casa_distro, 'bin'), path])
        os.environ['PATH'] = new_path

        os.environ["CASA_BASE_DIRECTORY"] = casa_distro_base

        image_base = f"brainvisa-{version}.sif"
        cmd = ["casa_distro_admin", "publish_user_image",
               f"image={image_base}"]
        subprocess.check_call(cmd)

    finally:
        os.environ['PATH'] = path


def web(
    context,
    web_environment_dir,
):
    print('web')
    cwd = os.getcwd()
    try:
        web_scr = osp.join(web_environment_dir,
                           'src/web/scripts/bv_publish_web')
        if not osp.exists(web_scr):
            web_scr = osp.join(
                web_environment_dir,
                'src/communication/web/master/scripts/bv_publish_web')
        os.chdir(web_environment_dir)
        cmd = ["pixi", "run", "bv_maker"]
        subprocess.check_call(cmd)
        cmd = ["pixi", "run", web_scr,
               "brainvisa@brainvisa.info:/var/www/html/brainvisa.info"]
        subprocess.check_call(cmd)

    finally:
        os.chdir(cwd)

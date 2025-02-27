# -*- coding: utf-8 -*-
import git
import json
import os
import pathlib
import re
import shutil
import subprocess
import sys
import toml


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


def git_commit(context, repo, modified, message):
    print(f"Commit in {repo}: {message}")
    repo = git.Repo(repo)
    repo.git.add(*modified)
    repo.git.commit("-m", message, "-n")
    repo.git.push()


def git_push(context, repo, tags=False):
    repo = git.Repo(repo)
    origin = repo.remote("origin")
    if tags:
        origin.push(tags=True)
    else:
        origin.push()


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
    sources_conf_file = context.soma_root / "conf" / "sources.d" / f"{conf['name']}.json"
    with open(sources_conf_file) as f:
        sources_conf = json.load(f)
    conf["version"] = sources_conf["latest_release"]
    with open(conf_file, "w") as f:
        json.dump(conf, f, indent=4)
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
    channels = pixi_toml["project"]["channels"]
    for i in channels + [f"file://{output}"]:
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
            dest.parent.mkdir(exist_ok=True)
            shutil.copy2(src, dest)
            copied.append(dest)
        if index:
            subprocess.check_call(["conda", "index", str(publication_dir)])
    except Exception:
        for f in copied:
            os.remove(f)
        raise

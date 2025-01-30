import fnmatch
import itertools
import json
import os
import pathlib
import re
import shutil
import subprocess
import sys
import types

import fire
import git
import toml
import yaml

from .defaults import default_publication_directory
from .recipes import (
    sorted_recipies,
    find_soma_env_packages,
    read_recipes,
    resolve_requirement,
)
from . import plan as plan_module

from .plan import update_merge


class Commands:
    def __init__(self):
        self.soma_root = pathlib.Path(os.environ["SOMA_ROOT"]).absolute()

    def info(self):
        return subprocess.call(["bv_maker", "info"])

    def sources(self):
        return subprocess.call(["bv_maker", "sources"])

    def status(self):
        raise NotImplementedError()

    def configure(self):
        return subprocess.call(["bv_maker", "configure"])

    def build(self):
        return subprocess.call(["bv_maker", "build"])

    def doc(self):
        return subprocess.call(["bv_maker", "doc"])

    def all(self):
        return subprocess.call(["bv_maker"])

    def update(self):
        src = self.soma_root / "src"
        if list(i.name for i in src.iterdir()) == ["brainvisa-cmake"]:
            self.sources()

        # Parse all recipes declared in source trees to update
        # pixi dependencies with "build" and "run" dependencies
        with open(self.soma_root / "pixi.toml") as f:
            pixi = toml.load(f)
        dependencies = {
            k: set((i if i[0] in "<>=" else f"=={i}") for i in v.split(",") if i != "*")
            for k, v in pixi.get("dependencies", {}).items()
            if isinstance(v, str)
        }
        for component_src in (self.soma_root / "src").iterdir():
            recipe_file = component_src / "soma-env" / "soma-env-recipe.yaml"
            if recipe_file.exists():
                with open(recipe_file) as f:
                    recipe = yaml.safe_load(f)
                requirements = recipe.get("requirements", {}).get(
                    "run", []
                ) + recipe.get("requirements", {}).get("build", [])
                for requirement in requirements:
                    if not isinstance(requirement, str):
                        continue
                    requirement = resolve_requirement(requirement)
                    if (
                        requirement.startswith("$")
                        or requirement.split()[0] == "mesalib"
                    ):
                        # mesalib makes Anatomist crash
                        continue
                    package, constraint = (requirement.split(None, 1) + [None])[:2]
                    dependencies.setdefault(package, set())
                    if constraint:
                        existing_constraint = dependencies[package]
                        if constraint not in existing_constraint:
                            existing_constraint.add(constraint)
        if dependencies:
            command = ["pixi", "add"] + [
                f"{package}{(','.join(constraint for constraint in constraints) if constraints else '=*')}"
                for package, constraints in dependencies.items()
            ]
            print("'{i}'" for i in command)
            subprocess.check_call(command)

    def version_plan(
        self,
        packages: str = "*",
        force: bool = False,
    ):
        selector = re.compile("|".join(f"(?:{fnmatch.translate(i)})" for i in packages))

        plan_dir = self.soma_root / "plan"

        # Check if a plan file already exists and can be erased
        if not force:
            actions_file = plan_dir / "actions.yaml"
            if actions_file.exists():
                with open(actions_file) as f:
                    actions = yaml.safe_load(f)
                if any(action.get("status") == "success" for action in actions):
                    raise RuntimeError(
                        f"A plan already exists in {plan_dir} and was used. "
                        "Erase it or use --force option"
                    )

        # Erase existing plan
        if plan_dir.exists():
            print(f"Erasing existing plan: {plan_dir}")
            shutil.rmtree(plan_dir)
        plan_dir.mkdir()

        # Read environment version
        with open(self.soma_root / "conf" / "soma-env.json") as f:
            soma_env = json.load(f)

        actions = []
        commit_actions = []

        # Read and merge json files defineing components sources (there can be several files
        # in environments deriving from soma-env)
        component_sources = {}
        for json_sources in (self.soma_root / "conf" / "sources.d").glob("*.json"):
            with open(json_sources) as f:
                component_sources.update(json.load(f))

        for recipe in read_recipes(self.soma_root):
            package = recipe["package"]["name"]
            if not selector.match(package):
                print(f"Package {package} excluded from selection")
                continue
            components = list(recipe["soma-env"].get("components", {}).keys())
            if components:

                latest_changesets = {}
                changesets = {}
                for component in components:
                    src = self.soma_root / "src" / component
                    repo = git.Repo(src)
                    if repo.is_dirty():
                        print(f"WARNING: repository {src} contains uncomited files")
                    elif repo.untracked_files:
                        print(f"WARNING: repository {src} has local modifications")
                    changesets[component] = str(repo.head.commit)
                    changeset = component_sources[component].get("changeset")
                    if changeset:
                        latest_changesets[component] = changeset

                if not latest_changesets:
                    print(f"Package {package} never released within this branch")
                elif changesets != latest_changesets:
                    changes = sorted(
                        i
                        for i in changesets
                        if changesets[i] != latest_changesets.get(i)
                    )

                    latest_release_version = soma_env["packages"][package]
                    print(
                        f"Package {package} modified since last release (in {', '.join(changes)})"
                    )
                    if recipe["package"]["version"] == latest_release_version:
                        package_version = tuple(
                            int(i) for i in recipe["package"]["version"].split(".")
                        )
                        new_version = package_version[:-1] + (package_version[-1] + 1,)
                        new_version = ".".join(str(i) for i in new_version)
                        print(
                            f"Set {package} version from {latest_release_version} to {new_version}"
                        )
                        # Find file to change
                        src = next(iter(recipe["soma-env"]["components"].values()))
                        file = src / "pyproject.toml"
                        if file.exists():
                            version_regexps = (
                                re.compile(
                                    r'(\bversion\s*=\s*")([0-9]+)(\.[0-9]+\.[0-9]+")'
                                ),
                                re.compile(
                                    r'(\bversion\s*=\s*"[0-9]+\.)([0-9]+)(\.[0-9]+")'
                                ),
                                re.compile(
                                    r'(\bversion\s*=\s*"[0-9]+\.[0-9]+\.)([0-9]+)(")'
                                ),
                            )
                        else:
                            file = src / "project_info.cmake"
                            if file.exists():
                                version_regexps = (
                                    re.compile(
                                        r"(\bset\s*\(\s*BRAINVISA_PACKAGE_VERSION_MAJOR\s*)"
                                        r"([0-9]+)(\s*\))",
                                        re.IGNORECASE,
                                    ),
                                    re.compile(
                                        r"(\bset\s*\(\s*BRAINVISA_PACKAGE_VERSION_MINOR\s*)"
                                        r"([0-9]+)(\s*\))",
                                        re.IGNORECASE,
                                    ),
                                    re.compile(
                                        r"(\bset\s*\(\s*BRAINVISA_PACKAGE_VERSION_PATCH\s*)"
                                        r"([0-9]+)(\s*\))",
                                        re.IGNORECASE,
                                    ),
                                )
                            else:
                                version_regexps = (
                                    re.compile(r"(\bversion_major\s*=\s*)([0-9]+)(\b)"),
                                    re.compile(r"(\bversion_minor\s*=\s*)([0-9]+)(\b)"),
                                    re.compile(r"(\bversion_micro\s*=\s*)([0-9]+)(\b)"),
                                )
                                files = list(
                                    itertools.chain(
                                        src.glob("info.py"),
                                        src.glob("*/info.py"),
                                        src.glob("python/*/info.py"),
                                    )
                                )
                                if not files:
                                    raise RuntimeError(
                                        f"Cannot find component version file (info.py or project_info.cmake) in {src}"
                                    )
                                file = files[0]
                        with open(file) as f:
                            file_contents = f.read()
                        for regex, version_component in zip(
                            version_regexps, new_version.split(".")
                        ):
                            file_contents, _ = regex.subn(
                                f"\\g<1>{version_component}\\g<3>", file_contents
                            )
                        print(
                            f"Create actions to modify {file} to set {package} version from {latest_release_version} to {new_version}"
                        )
                        actions.append(
                            {
                                "action": "modify_file",
                                "kwargs": {
                                    "file": str(file),
                                    "file_contents": file_contents,
                                },
                            }
                        )
                        commit_actions.append(
                            {
                                "action": "git_commit",
                                "kwargs": {
                                    "repo": str(src),
                                    "modified": [str(file)],
                                    "message": f"Set package {package} from version {latest_release_version} to version {new_version}",
                                },
                            }
                        )

                else:
                    print(f"No change detected in package {package}")

        if commit_actions:
            actions.extend(commit_actions)
            actions.append({"action": "rebuild"})

        with open(plan_dir / "actions.yaml", "w") as f:
            yaml.safe_dump(
                actions,
                f,
            )

    def check_merge(self, src: str = None, branch: str = None):
        if src:
            src = pathlib.Path(src)
        else:
            src = self.soma_root / "src"
        stack = [src]
        while stack:
            src = stack.pop()
            if (src / ".git").exists():
                repo = git.Repo(str(src))
                branches = {i.name.rsplit("/", 1)[-1] for i in repo.remote().refs}
                if branch is None:
                    if "master" in branches:
                        real_branch = "master"
                    else:
                        real_branch = "main"
                else:
                    real_branch = branch
                repo.git.fetch()
                non_merged = {
                    i.split(None, 1)[0]
                    for i in repo.git.branch("-r", "--no-merge").split("\n")
                    if i
                }
                if f"origin/{real_branch}" in non_merged:
                    print(f"git -C '{src}' merge --no-edit origin/{real_branch}")
                    print(f"git -C '{src}' push")
            else:
                stack.extend(i for i in src.iterdir() if i.is_dir())

    def packaging_plan(
        self,
        packages: str = "*",
        release: bool = False,
        force: bool = False,
        test: bool = False,
        default_patch_version: int = 0,
    ):
        # Read environment configuration
        soma_env_conf_file = self.soma_root / "conf" / "soma-env.json"
        with open(soma_env_conf_file) as f:
            soma_env_conf = json.load(f)
        environment_name = soma_env_conf["name"]
        environment_version = soma_env_conf["version"]
        development_environment = environment_version.startswith("0.")
        last_published_soma_env_version = soma_env_conf.get("latest_release")

        publication_file = self.soma_root / "conf" / "publication.json"
        with open(publication_file) as f:
            publication_conf = json.load(f)

        selector = re.compile("|".join(f"(?:{fnmatch.translate(i)})" for i in packages))

        plan_dir = self.soma_root / "plan"

        # Check if a plan file already exists and can be erased
        if not force:
            actions_file = plan_dir / "actions.yaml"
            if actions_file.exists():
                with open(actions_file) as f:
                    actions = yaml.safe_load(f)
                if any(action.get("status") == "success" for action in actions):
                    raise RuntimeError(
                        f"A plan already exists in {plan_dir} and was used. "
                        "Erase it or use --force option"
                    )

        # Erase existing plan
        if plan_dir.exists():
            print(f"Erasing existing plan: {plan_dir}")
            shutil.rmtree(plan_dir)
        plan_dir.mkdir()

        # Set the new soma-env full version by incrementing last published version patch
        # number or setting it to default_patch_version
        if last_published_soma_env_version:
            # Increment patch number
            major, minor, patch = [
                int(i) for i in last_published_soma_env_version.split(".")
            ]
            future_published_soma_env_version = f"{major}.{minor}.{patch+1}"
            last_published_soma_env_version = f"{major}.{minor}.{patch}"
            print(f"Last published soma-env version: {last_published_soma_env_version}")
        else:
            future_published_soma_env_version = (
                f"{environment_version}.{default_patch_version}"
            )
            print("soma-env has never been published")

        # Next environment version is used to build dependencies strings
        # for components:
        #   >={environment_version},<{next_environment_version}
        next_environment_version = environment_version.split(".")
        next_environment_version[-1] = str(int(next_environment_version[-1]) + 1)
        next_environment_version = ".".join(next_environment_version)

        # Build string for new packages
        build_string = f"py{sys.version_info[0]}{sys.version_info[1]}"

        # List of actions stored in the plan file
        actions = []

        # Read and merge json files defining components sources (there can be several files
        # in environments deriving from soma-env). And keep track of the file used for each
        # component in order to update the changeset of the component.
        component_sources_file = {}
        component_sources = {}
        for json_file in (self.soma_root / "conf" / "sources.d").glob("*.json"):
            with open(json_file) as f:
                component_sources_file[json_file] = json.load(f)
            for component, sources in component_sources_file[json_file].items():
                component_sources[component] = {
                    "json_file": json_file,
                    "sources": sources,
                }

        # Check if pixi.lock has changed using git
        soma_env_repo = git.Repo(self.soma_root)
        files_to_commit = set()
        pixi_lock_changed = False
        changed_files = {item.a_path for item in soma_env_repo.index.diff(None)}
        if "pixi.lock" in changed_files:
            files_to_commit.add("pixi.lock")
            pixi_lock_changed = True
        if "pixi.toml" in changed_files:
            files_to_commit.add("pixi.toml")
            if not pixi_lock_changed:
                raise RuntimeError("pixi.toml file changed but not pixi.lock")

        recipes = {}
        selected_packages = set()
        packages_per_channel = {}
        # Get ordered selection of recipes. Order is based on package
        # dependencies. Recipes are selected according to user selection and
        # modification since last packaging
        for recipe in sorted_recipies(self.soma_root):
            package = recipe["package"]["name"]
            if not selector.match(package):
                print(f"Package {package} excluded from selection")
                continue
            components = list(recipe["soma-env"].get("components", {}).keys())
            if components:
                # Parse components and do the following:
                #  - put error messages in src_errors if source trees are not clean
                #  - Get current git changeset of each component source tree in
                #    changesets
                #  - Add package to selected_packages if any component has changed
                #    since the last release
                src_errors = []
                changesets = {}
                latest_changesets = {}
                for component in components:
                    src = self.soma_root / "src" / component
                    repo = git.Repo(src)
                    if repo.is_dirty():
                        src_errors.append(f"repository {src} contains uncomited files")
                    elif repo.untracked_files:
                        src_errors.append(f"repository {src} has local modifications")
                    changesets[component] = str(repo.head.commit)
                    changeset = component_sources[component]["sources"].get("changeset")
                    if changeset:
                        latest_changesets[component] = changeset

                if pixi_lock_changed or not latest_changesets:
                    if pixi_lock_changed:
                        print(f"Select {package} because pixi.lock has changed")
                    else:
                        print(
                            f"Select {package} because no source changesets was found in release history"
                        )
                    selected_packages.add(package)
                    packages_per_channel.setdefault(
                        recipe["soma-env"]["publication"], []
                    ).append(package)
                elif changesets != latest_changesets:
                    changes = sorted(
                        i
                        for i in changesets
                        if changesets[i] != latest_changesets.get(i)
                    )
                    print(
                        f"Select {package} for building because some source has changed (in {', '.join(changes)}) since latest release"
                    )
                    selected_packages.add(package)
                    packages_per_channel.setdefault(
                        recipe["soma-env"]["publication"], []
                    ).append(package)
                else:
                    print(f"No change detected in package {package}")

                # Write build section in recipe

                recipe.setdefault("build", {})["string"] = build_string
                recipe["build"]["script"] = "\n".join(
                    (
                        f"cd '{self.soma_root}'",
                        f"pixi run --manifest-path='{self.soma_root}/pixi.toml' bash << END",
                        "set -x",
                        'cd "\\$SOMA_ROOT/build"',
                        'export BRAINVISA_INSTALL_PREFIX="$PREFIX"',
                        f"for component in {' '.join(components)}; do",
                        "  make install-\\${component}",
                        "  make install-\\${component}-dev",
                        "  make install-\\${component}-usrdoc",
                        "  make install-\\${component}-devdoc",
                        "done",
                        "END",
                    )
                )
                # Save information in recipe because we do not know yet
                # if package will be selected for building. It will be known
                # later when dependencies are resolved.
                recipe["soma-env"]["src_errors"] = src_errors
                recipe["soma-env"]["changesets"] = changesets
            elif recipe["soma-env"]["type"] == "virtual":
                raise NotImplementedError(
                    "packaging of virtual packages not implemented"
                )
            else:
                raise Exception(
                    f"Invalid recipe for {package} (bad type or no component defined)"
                )
            recipes[package] = recipe

        if not selected_packages:
            print("Nothing to do.")
            return

        # Add an action to assess that compilation was successfully done
        actions.append({"action": "check_build_status"})

        # Select new packages that are compiled and depend on, at least, one selected compiled package
        selection_modified = True
        while selection_modified:
            selection_modified = False
            for package, recipe in recipes.items():
                if package in selected_packages:
                    continue
                if recipe["soma-env"]["type"] == "compiled":
                    for other_package in recipe["soma-env"].get(
                        "internal-dependencies", []
                    ):
                        if recipes[other_package]["soma-env"]["type"] != "compiled":
                            continue
                        if other_package in selected_packages:
                            print(
                                f"Select {package} because it is binary dependent on {other_package} which is selected"
                            )
                            selected_packages.add(package)
                            packages_per_channel.setdefault(
                                recipe["soma-env"]["publication"], []
                            ).append(package)
                            selection_modified = True

        # Generate rattler-build recipe and actions for new environment version
        print(
            f"Generate recipe for {environment_name} {future_published_soma_env_version}"
        )
        (plan_dir / "recipes" / environment_name).mkdir(exist_ok=True, parents=True)
        with open(plan_dir / "recipes" / environment_name / "recipe.yaml", "w") as f:
            yaml.safe_dump(
                {
                    "package": {
                        "name": environment_name,
                        "version": future_published_soma_env_version,
                    },
                    "build": {
                        "string": f"py{sys.version_info[0]}{sys.version_info[1]}",
                        "script": (
                            "mkdir --parents $PREFIX/share/soma\n"
                            f"echo '{future_published_soma_env_version}' > $PREFIX/share/soma/{environment_name}.version"
                        ),
                    },
                    "requirements": {
                        "run": [f"python=={sys.version_info[0]}.{sys.version_info[1]}"]
                    },
                },
                f,
            )
        actions.append(
            {
                "action": "create_package",
                "args": [environment_name],
                "kwargs": {"test": test},
            }
        )

        # Generate rattler-build recipe and actions for selected packages
        for package in selected_packages:
            recipe = recipes[package]
            if development_environment:
                recipe["package"]["version"] = future_published_soma_env_version
            print(f"Generate recipe for {package} {recipe['package']['version']}")
            if not force:
                src_errors = recipe["soma-env"].get("src_errors")
                if src_errors:
                    raise Exception(
                        f"Cannot build {package} because {', '.join(src_errors)}."
                    )
            internal_dependencies = recipe["soma-env"].get("internal-dependencies", [])
            if internal_dependencies:
                for dpackage in internal_dependencies:
                    d = f"{dpackage}>={recipes[dpackage]['package']['version']}"
                    recipe.setdefault("requirements", {}).setdefault("run", []).append(
                        d
                    )

            # Add dependency to current environment
            recipe["requirements"]["run"].append(
                f"{environment_name}>={future_published_soma_env_version},<{next_environment_version}"
            )

            (plan_dir / "recipes" / package).mkdir(exist_ok=True, parents=True)

            with open(plan_dir / "recipes" / package / "recipe.yaml", "w") as f:
                yaml.safe_dump({k: v for k, v in recipe.items() if k != "soma-env"}, f)

            actions.append(
                {
                    "action": "create_package",
                    "args": [package],
                    "kwargs": {"test": test},
                }
            )

        if release:
            # Update latest_release in conf/soma-env.json
            soma_env_conf["latest_release"] = future_published_soma_env_version

            # Create actions to update components source files to set changesets
            modified_sources = set()
            for package in selected_packages:
                recipe = recipes[package]
                soma_env_conf["packages"][package] = recipe["package"]["version"]
                for component in recipe["soma-env"].get("components"):
                    src = self.soma_root / "src" / component
                    repo = git.Repo(src)
                    changeset = str(repo.head.commit)
                    if (
                        component_sources[component]["sources"].get("changeset")
                        != changeset
                    ):
                        component_sources[component]["sources"]["changeset"] = changeset
                        modified_sources.add(component_sources[component]["json_file"])
            for f in modified_sources:
                actions.append(
                    {
                        "action": "modify_file",
                        "kwargs": {
                            "file": str(f),
                            "file_contents": component_sources_file[f],
                        },
                    }
                )
            files_to_commit.update(modified_sources)
            actions.append(
                {
                    "action": "modify_file",
                    "kwargs": {
                        "file": str(soma_env_conf_file),
                        "file_contents": soma_env_conf,
                    },
                }
            )
            files_to_commit.add(soma_env_conf_file)

            if files_to_commit:
                actions.append(
                    {
                        "action": "git_commit",
                        "kwargs": {
                            "repo": str(self.soma_root),
                            "modified": [str(i) for i in files_to_commit],
                            "message": f"Release {environment_name} {future_published_soma_env_version}",
                        },
                    }
                )

            # Create release tag
            actions.append(
                {
                    "action": "create_release_tag",
                    "kwargs": {
                        "tag": future_published_soma_env_version,
                    },
                }
            )

            # Create actions to publish packages
            packages_dir = self.soma_root / "plan" / "packages"
            actions.append(
                {
                    "action": "publish",
                    "kwargs": {
                        "packages_dir": str(packages_dir),
                        "packages": [environment_name],
                        "publication_dir": str(
                            publication_conf[soma_env_conf["publication"]]["directory"]
                        ),
                    },
                }
            )
            for publication_channel, packages in packages_per_channel.items():
                publication_directory = publication_conf[publication_channel][
                    "directory"
                ]
                actions.append(
                    {
                        "action": "publish",
                        "kwargs": {
                            "packages_dir": str(packages_dir),
                            "packages": list(packages),
                            "publication_dir": str(publication_directory),
                        },
                    }
                )

        # Save actions.yaml
        with open(plan_dir / "actions.yaml", "w") as f:
            yaml.safe_dump(
                actions,
                f,
            )

    def apply_plan(self):
        with open(self.soma_root / "plan" / "actions.yaml") as f:
            actions = yaml.safe_load(f)
        context = types.SimpleNamespace()
        context.soma_root = self.soma_root
        for action in actions:
            if action.get("status") != "success":
                getattr(plan_module, action["action"])(
                    context, *action.get("args", []), **action.get("kwargs", {})
                )
                action["status"] = "success"
                with open(self.soma_root / "plan" / "actions.yaml", "w") as f:
                    yaml.safe_dump(actions, f)

    def graphviz(self, packages: str = "*", conda_forge=False, versions=False):
        """Output a dot file for selected packages (or for all known packages by default)"""
        selector = re.compile("|".join(f"(?:{fnmatch.translate(i)})" for i in packages))
        neuro_forge_packages = set()
        conda_forge_packages = set()
        linked = set()
        print("digraph {")
        print("  node [shape=box, color=black, style=filled]")
        recipes = {
            recipe["package"]["name"]: recipe
            for recipe in sorted_recipies(self.soma_root)
        }
        selected_recipes = set()
        stack = [i for i in recipes if selector.match(i)]
        while stack:
            package = stack.pop(0)
            selected_recipes.add(package)
            recipe = recipes[package]
            stack.extend(
                dependency
                for dependency in recipe["soma-env"].get("internal-dependencies", [])
                if dependency not in selected_recipes
            )

        all_soma_env_packages = set(find_soma_env_packages(self.soma_root))
        for package in selected_recipes:
            recipe = recipes[package]
            if versions:
                version = recipe["package"]["version"]
                label = f'"{package} ({version})"'
            else:
                label = f'"{package}"'
            if recipe["soma-env"]["type"] == "interpreted":
                print(f'  "{package}" [label={label},fillcolor="aquamarine2"]')
            elif recipe["soma-env"]["type"] == "compiled":
                print(
                    f'  "{package}" [label={label},fillcolor="darkgreen",fontcolor=white]'
                )
            elif recipe["soma-env"]["type"] == "virtual":
                print(f'  "{package}" [label={label},fillcolor="powderblue"]')
            else:
                print(f'  "{package}" [fillcolor="bisque"]')
            for dependency in recipe["soma-env"].get("internal-dependencies", []):
                if (package, dependency) not in linked:
                    print(f'  "{package}" -> "{dependency}"')
                    linked.add((package, dependency))
            for dependency in recipe.get("requirements", {}).get("run", []):
                if dependency in all_soma_env_packages:
                    neuro_forge_packages.add(dependency)
                    print(f'  "{package}" -> "{dependency}"')
                elif conda_forge:
                    conda_forge_packages.add(dependency)
                    print(f'  "{package}" -> "{dependency}"')
        for package in neuro_forge_packages:
            print(f'  "{package}" [fillcolor="bisque"]')
        for package in conda_forge_packages:
            print(f'  "{package}" [fillcolor="aliceblue"]')
        print("}")


def main():
    fire.Fire(Commands)

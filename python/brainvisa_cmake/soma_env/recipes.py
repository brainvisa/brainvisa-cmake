# -*- coding: utf-8 -*-
import json
import subprocess
import yaml
import re

import brainvisa_cmake.brainvisa_projects as brainvisa_projects


def pin_dev_compatible(package, min_pin=None, max_pin=None, exact=False):
    output = subprocess.check_output(["pixi", "list", "--json", package])
    installed_packages = {i["name"]: i for i in json.loads(output.decode())}
    package_info = installed_packages.get(package)
    if package_info is None:
        raise ValueError(f'Cannot find "{package}" in installed packages')
    version = package_info["version"]
    if exact:
        return f"{package} =={version} {package_info['build']}"
    if min_pin is None:
        min_version = version
    else:
        min_version = ".".join((version.split("."))[: len(min_pin.split("."))])
    if max_pin is None:
        max_version = version.split(".")[:-1]
    elif max_pin:
        max_version = version.split(".")[: len(max_pin.split("."))]
    else:
        max_version = None
    if max_version:
        max_version[-1] = str(int(max_version[-1]) + 1)
        max_version = f',<{".".join(max_version)}'
    else:
        max_version = ""
    return f"{package} >={min_version}{max_version}"


def replace_soma_env(match):
    replacement_env = {"pin_dev_compatible": pin_dev_compatible}
    return eval(f"f'''{{{match.group(1)}}}'''", replacement_env, replacement_env)


def resolve_requirement(requirement):
    return re.sub(r"\$soma-env\{\{(.*)\}\}", replace_soma_env, requirement)


def read_recipes(soma_root):
    """
    Iterate over all recipes files defined in soma-forge.
    """
    # Read environment version
    with open(soma_root / "conf" / "soma-env.json") as f:
        soma_env_conf = json.load(f)
    environment_packages = soma_env_conf["packages"]
    environment_version = soma_env_conf["version"]
    development_environment = environment_version.startswith("0.")

    src_dir = soma_root / "src"
    for component_src in src_dir.iterdir():
        recipe_file = component_src / "soma-env" / "soma-env-recipe.yaml"
        if recipe_file.exists():
            try:
                with open(recipe_file) as f:
                    recipe = yaml.safe_load(f)
                if recipe["package"]["name"] not in environment_packages:
                    continue
                if development_environment:
                    # Set recipe version to development environment version
                    recipe["package"]["version"] = environment_version
                else:
                    # Set main component version as recipe version
                    pinfo = brainvisa_projects.read_project_info(component_src)
                    if pinfo:
                        project, component, component_version, build_model = pinfo
                        recipe["package"]["version"] = str(component_version)
                    else:
                        print(
                            f"WARNING: directory {component_src} does not contain project_info.cmake, python/*/info.py or */info.py file"
                        )

                # Replace git location by source directories in component list
                components = {component_src.name: component_src}
                for component in recipe["soma-env"].get("components", []):
                    components[component] = src_dir / component
                recipe["soma-env"]["components"] = components

                # Replace $soma-env{{...}} elements in dependencies
                for section, requirements in recipe.get("requirements", {}).items():
                    if isinstance(requirements, list):
                        for i in range(len(requirements)):
                            r = requirements[i]
                            if isinstance(r, str):
                                requirements[i] = resolve_requirement(r)
                yield recipe
            except Exception as e:
                raise RuntimeError(f"Error while reading {recipe_file}") from e


def selected_recipes(soma_root, selection=None):
    """
    Iterate over recipes selected in configuration and their dependencies.
    """
    # Read recipes
    recipes = {r["package"]["name"]: r for r in read_recipes(soma_root)}

    all_packages = set(recipes)

    metapackages = {
        "all": all_packages,
    }
    if not selection:
        selection = ["all"]
    selected_packages = set()
    for s in selection:
        if s.startswith("-"):
            s = s[1:].strip()
            remove = True
        else:
            remove = False
        m = metapackages.get(s)
        if m is not None:
            s = m
        else:
            s = {s}
        if remove:
            selected_packages = selected_packages.difference(s)
        else:
            selected_packages.update(s)

    # Walk over selected packages and dependencies
    stack = list(selected_packages)
    done = set()
    while stack:
        package = stack.pop(0)
        if package in done:
            continue
        recipe = recipes[package]
        yield recipe
        done.add(package)
        dependencies = recipe["soma-env"].get("internal-dependencies", [])
        stack.extend(i for i in dependencies if i not in done)


def sorted_recipies(soma_root):
    """
    Iterate over recipes sorted according to their dependencies starting with a
    package without dependency.
    """
    recipes = {r["package"]["name"]: r for r in selected_recipes(soma_root)}
    ready = set()
    inverted_dependencies = {}
    for package, recipe in recipes.items():
        dependencies = recipe["soma-env"].get("internal-dependencies", [])
        if not dependencies:
            ready.add(package)
        for dependency in dependencies:
            inverted_dependencies.setdefault(dependency, set()).add(package)

    done = set()
    while ready:
        package = ready.pop()
        yield recipes[package]
        done.add(package)
        for dependent in inverted_dependencies.get(package, []):
            dependencies = recipe.get("internal-dependencies", [])
            if dependent not in done and all(d in done for d in dependencies):
                ready.add(dependent)


def find_soma_env_packages(soma_root):
    for recipe in read_recipes(soma_root):
        yield recipe["package"]["name"]

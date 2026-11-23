# -*- coding: utf-8 -*-
import sys
import glob
import json
import os
import os.path as osp
import pathlib


class MultiFileConfig(object):

    def __init__(self, 
                 config_dir, 
                 config_glob = "*.json"):
        self.config_dir = config_dir
        self.config_glob = config_glob
        self.__content__ = None

    def load(self):
        if osp.exists(self.config_dir):
            json_files = glob.glob(str(self.config_dir / self.config_glob))
            self.__content__ = {} 
            for config_file in json_files:
                try:
                    # Read environment configuration
                    with open(config_file) as f:
                        # print(f"== Loading file: {config_file}")
                        self.__content__[config_file] = json.load(f)

                except Exception as e:
                    print(f"WARNING: {e} is not readable")
                    continue

    def merged(self):
        def __merge(dict1, dict2):
            merged = dict1.copy()
            for key, value in dict2.items():
                if key in merged:
                    if isinstance(merged[key], dict) and isinstance(value, dict):
                        merged[key] = __merge(merged[key], value)
                    elif merged[key] == value:
                        continue
                    else:
                        raise ValueError(f"Key '{key}' contains different values that cannot be merged: "
                                         f"{merged[key]} et {value}")
                else:
                    merged[key] = value
            return merged

        config_merged = {}
        merged_files = []
        if self.__content__ is None:
            self.load()

        for config_file, config in self.__content__.items():
            if config.get("enabled", True):
                merged_files.append(config_file)

                try:
                    config_merged = __merge(config_merged, config)

                except ValueError as error:
                    print("Inconsistent values were found in soma-env json "
                        "configuration files:", file=sys.stderr)
                    for f in merged_files:
                        print(f"  - {f}", file=sys.stderr)

        # print("=================== MERGED CONFIGURATION ===================")
        # print(config_merged)
        # print("Packages found:", len(config_merged.get("packages", {})))
        # print("============================================================")

        return config_merged

    def config_files(self): 
        return self.__content__.keys()

    def update(self, config_key_path, value, key_path_sep = "."):
        def __update(config, key_path, value):
            key = key_path.pop()
            if len(key_path) > 0:
                config[key_path] = value
            else:
                __update(config.setdefault(key, {}), key_path, value)
            
        if not self.__content__ is None:
            if not isinstance(config_key_path, (list, tuple)):
                config_key_path = config_key_path.split(key_path_sep)
            config_key_path.reverse()
            for config in self.__content__.values():
                __update(config, config_key_path, value)

    def save(self):
        if not self.__content__ is None:
            for config_file, config in  self.__content__.items():
                with open(config_file, "w") as f:
                    json.dump(config, config_file, indent=4, ensure_ascii=False)


class SomaEnvConfig(object):

    def __init__(self, 
                 config_name = "soma-env", 
                 config_dir = pathlib.Path(os.environ["SOMA_ROOT"]).absolute() / "conf", 
                 config_glob = "*.json"):
        self.config_name = config_name
        self.config_dir = config_dir
        self.config_glob = config_glob
        self.__content__ = None

    def load(self):
        if osp.exists(self.config_dir):
            json_files = glob.glob(str(self.config_dir / self.config_glob))
            self.__content__ = {} 
            for soma_env_config_file in json_files:
                try:
                    # Read environment configuration
                    with open(soma_env_config_file) as f:
                        # print(f"== Loading file: {soma_env_config_file}")
                        soma_env_config = json.load(f)

                except Exception as e:
                    print(f"WARNING: {e} is not readable")
                    continue

                if soma_env_config.get("name") == self.config_name:
                    self.__content__[soma_env_config_file] = soma_env_config

    def merged(self):
        def __merge(dict1, dict2):
            merged = dict1.copy()
            for key, value in dict2.items():
                if key in merged:
                    if isinstance(merged[key], dict) and isinstance(value, dict):
                        merged[key] = __merge(merged[key], value)
                    elif merged[key] == value:
                        continue
                    else:
                        raise ValueError(f"Key '{key}' contains different values that cannot be merged: "
                                         f"{merged[key]} et {value}")
                else:
                    merged[key] = value
            return merged

        soma_env_config_merged = {}
        soma_env_merged_files = []
        if self.__content__ is None:
            self.load()

        for soma_env_config_file, soma_env_conf in self.__content__.items():
            if soma_env_conf.get("name") == self.config_name \
                and soma_env_conf.get("enabled", True):
                soma_env_merged_files.append(soma_env_config_file)

                try:
                    soma_env_config_merged = __merge(soma_env_config_merged, soma_env_conf)

                except ValueError as error:
                    print("Inconsistent values were found in soma-env json "
                        "configuration files:", file=sys.stderr)
                    for f in soma_env_merged_files:
                        print(f"  - {f}", file=sys.stderr)

        # print("=================== MERGED CONFIGURATION ===================")
        # print(soma_env_config_merged)
        # print("Packages found:", len(soma_env_config_merged.get("packages", {})))
        # print("============================================================")

        return soma_env_config_merged

    def config_files(self): 
        return self.__content__.keys()

    def update(self, config_key_path, value, key_path_sep = "."):
        def __update(config, key_path, value):
            key = key_path.pop()
            if len(key_path) > 0:
                config[key_path] = value
            else:
                __update(config.setdefault(key, {}), key_path, value)
            
        if not self.__content__ is None:
            if not isinstance(config_key_path, (list, tuple)):
                config_key_path = config_key_path.split(key_path_sep)
            config_key_path.reverse()
            for soma_env_conf in self.__content__.values():
                __update(soma_env_conf, config_key_path, value)

    def save(self):
        if not self.__content__ is None:
            for soma_env_config_file, soma_env_conf in  self.__content__.items():
                with open(soma_env_config_file, "w") as f:
                    json.dump(soma_env_conf, soma_env_config_file, indent=4, ensure_ascii=False)

def read_soma_env_config(config_name = "soma-env", 
                         config_dir = pathlib.Path(os.environ["SOMA_ROOT"]).absolute() / "conf",
                         config_glob = "*.json"):
    return SomaEnvConfig(config_name = config_name,
                         config_dir = config_dir,
                         config_glob = config_glob).merged()

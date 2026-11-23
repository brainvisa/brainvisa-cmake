import json
import os
import pathlib

from .config import read_soma_env_config

soma_env_conf = read_soma_env_config()
__version__ = soma_env_conf.get("version")

# -*- coding: utf-8 -*-
from pathlib import Path

from brainvisa_cmake.brainvisa_projects import read_project_info

base_dir = Path(__file__).parent.parent.parent

version_major, version_minor, version_patch = read_project_info(str(base_dir))[2]._version_numbers

version = '%s.%s.%s' % (version_major, version_minor, version_patch)

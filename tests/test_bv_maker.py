#!/usr/bin/env python
# -*- coding: utf-8 -*-
#  This software and supporting documentation are distributed by
#      Institut Federatif de Recherche 49
#      CEA/NeuroSpin, Batiment 145,
#      91191 Gif-sur-Yvette cedex
#      France
#
# This software is governed by the CeCILL-B license under
# French law and abiding by the rules of distribution of free software.
# You can  use, modify and/or redistribute the software under the
# terms of the CeCILL-B license as circulated by CEA, CNRS
# and INRIA at the following URL "http://www.cecill.info".
#
# As a counterpart to the access to the source code and  rights to copy,
# modify and redistribute granted by the license, users are provided only
# with a limited warranty  and the software's author,  the holder of the
# economic rights,  and the successive licensors  have only  limited
# liability.
#
# In this respect, the user's attention is drawn to the risks associated
# with loading,  using,  modifying and/or developing or reproducing the
# software by the user in light of its specific status of free software,
# that may mean  that it is complicated to manipulate,  and  that  also
# therefore means  that it is reserved for developers  and  experienced
# professionals having in-depth computer knowledge. Users are therefore
# encouraged to load and test the software's suitability as regards their
# requirements in conditions enabling the security of their systems and/or
# data to be ensured and,  more generally, to use and operate it in the
# same conditions as regards security.
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL-B license and that you accept its terms.

import os
import shutil
import subprocess
import tempfile
import sys

if sys.version_info < (2, 7):
    # Decorators are not available on python 2.6:
    # we need a backport of a newer version of unittest.
    import unittest2 as unittest
else:
    import unittest


BV_MAKER_SUBCOMMANDS = ['info', 'sources', 'status', 'configure', 'build',
                        'doc', 'testref', 'test', 'pack', 'install_pack',
                        'testref_pack', 'test_pack', 'publish_pack']


# Variables set in setUpModule()
MODULE_TEST_DIR = None
TEST_REPO_PATH = None
BRAINVISA_CMAKE_REPO = None


def setUpModule():
    global MODULE_TEST_DIR
    global TEST_REPO_PATH
    global BRAINVISA_CMAKE_REPO
    try:
        MODULE_TEST_DIR = tempfile.mkdtemp(prefix='test', suffix='.module')
        TEST_REPO_PATH = MODULE_TEST_DIR
        BRAINVISA_CMAKE_REPO = 'file://' + TEST_REPO_PATH
        subprocess.check_call([
            'git', 'clone', '--bare',
            'https://github.com/brainvisa/brainvisa-cmake.git',
            TEST_REPO_PATH
        ])
    except:
        if MODULE_TEST_DIR is not None:
            shutil.rmtree(MODULE_TEST_DIR)
        raise


def tearDownModule():
    shutil.rmtree(MODULE_TEST_DIR)


class TestWithoutRepository(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            cls.test_dir = tempfile.mkdtemp(prefix='test', suffix='.run')
            cls.src_dir = os.path.join(cls.test_dir, 'src')
            cls.build_dir = os.path.join(cls.test_dir, 'build')
            cls.bv_maker_cfg = os.path.join(cls.test_dir, '.brainvisa',
                                            'bv_maker.cfg')
            os.makedirs(os.path.join(cls.test_dir, '.brainvisa'))
            with open(cls.bv_maker_cfg, 'w') as f:
                f.write("""\
[ source {src_dir} ]
  git {brainvisa_cmake_repo} master development/brainvisa-cmake/master

[ build {build_dir} ]
  brainvisa-cmake bug_fix {src_dir}
""".format(src_dir=cls.src_dir, build_dir=cls.build_dir,
           brainvisa_cmake_repo=BRAINVISA_CMAKE_REPO))
            cls.env = os.environ.copy()
            cls.env['HOME'] = cls.test_dir
        except:
            if hasattr(cls, 'test_dir'):
                shutil.rmtree(cls.test_dir)
            raise

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.test_dir)

    def test_bv_maker_help(self):
        retcode = subprocess.call(['bv_maker', '--help'], env=self.env)
        self.assertEqual(retcode, 0)
        for subcommand in BV_MAKER_SUBCOMMANDS:
            retcode = subprocess.call(['bv_maker', subcommand, '--help'],
                                      env=self.env)
            self.assertEqual(retcode, 0)

    def test_bv_maker_sources(self):
        retcode = subprocess.call(['bv_maker', '-c', self.bv_maker_cfg,
                                   'sources'], env=self.env)
        self.assertEqual(retcode, 0)
        self.assertTrue(os.path.isfile(os.path.join(
            self.src_dir, 'development', 'brainvisa-cmake', 'master',
            'project_info.cmake')))


class TestWithRepository(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        try:
            cls.test_dir = tempfile.mkdtemp(prefix='test', suffix='.run')
            cls.src_dir = os.path.join(cls.test_dir, 'src')
            cls.build_dir = os.path.join(cls.test_dir, 'build')
            cls.bv_maker_cfg = os.path.join(cls.test_dir, '.brainvisa',
                                            'bv_maker.cfg')
            os.makedirs(os.path.join(cls.test_dir, '.brainvisa'))
            with open(cls.bv_maker_cfg, 'w') as f:
                f.write("""\
[ source {src_dir} ]
  git {brainvisa_cmake_repo} master development/brainvisa-cmake/master

[ build {build_dir} ]
  brainvisa-cmake bug_fix {src_dir}
""".format(src_dir=cls.src_dir, build_dir=cls.build_dir,
           brainvisa_cmake_repo=BRAINVISA_CMAKE_REPO))
            cls.env = os.environ.copy()
            cls.env['HOME'] = cls.test_dir
            subprocess.check_call(['bv_maker', '-c', cls.bv_maker_cfg,
                                   'sources'], env=cls.env)
        except:
            if hasattr(cls, 'test_dir'):
                shutil.rmtree(cls.test_dir)
            raise

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.test_dir)

    def test_bv_maker_info(self):
        retcode = subprocess.call(['bv_maker', '-c', self.bv_maker_cfg,
                                   'info'], env=self.env)
        self.assertEqual(retcode, 0)


    def test_bv_maker_status(self):
        retcode = subprocess.call(['bv_maker', '-c', self.bv_maker_cfg,
                                   'status'], env=self.env)
        self.assertEqual(retcode, 0)


if __name__ == '__main__':
    unittest.main()

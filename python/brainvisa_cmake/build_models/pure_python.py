# -*- coding: utf-8 -*-

import os
import sys
import os.path as osp
import distutils.spawn
import six
import string
import subprocess
import shlex

from brainvisa_cmake.brainvisa_projects import read_project_info, find_project_info

if sys.version_info[0] >= 3:
    def execfile(filename, globals=None, locals=None):
        with open(filename) as f:
            file_contents = f.read()
        exec(compile(file_contents, filename, 'exec'), globals, locals)

cmake_template = '''# This file was generated by bv_maker
# Source file: %(file)s

cmake_minimum_required( VERSION 3.10 )

find_package( python REQUIRED )
find_package( Sphinx )
find_package( brainvisa-cmake REQUIRED )

file( TO_CMAKE_PATH "%(source_directory)s" BRAINVISA_REAL_SOURCE_DIR )
BRAINVISA_PROJECT()

BRAINVISA_DEPENDENCY(DEV DEPENDS %(component_name)s RUN "= ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}")
BRAINVISA_DEPENDENCY( RUN DEPENDS python RUN ">= 2.7" )
%(brainvisa_dependencies)s
if( EXISTS "${BRAINVISA_REAL_SOURCE_DIR}/python" )
    BRAINVISA_COPY_PYTHON_DIRECTORY( "${BRAINVISA_REAL_SOURCE_DIR}/python"
                                     ${PROJECT_NAME} python
                                     INSTALL_ONLY )
else()
    BRAINVISA_COPY_PYTHON_DIRECTORY( "${BRAINVISA_REAL_SOURCE_DIR}/%(component_name)s"
                                     ${PROJECT_NAME} python/%(component_name)s
                                     INSTALL_ONLY )
endif()

if( EXISTS "${BRAINVISA_REAL_SOURCE_DIR}/bin" )
    BRAINVISA_COPY_DIRECTORY( "${BRAINVISA_REAL_SOURCE_DIR}/bin"
                              bin
                              ${PROJECT_NAME} )
endif()

if( EXISTS "${BRAINVISA_REAL_SOURCE_DIR}/share" )
    BRAINVISA_COPY_DIRECTORY( "${BRAINVISA_REAL_SOURCE_DIR}/share"
                              share/${PROJECT_NAME}-${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}
                              ${PROJECT_NAME} )
endif()

if( EXISTS "${BRAINVISA_REAL_SOURCE_DIR}/brainvisa" )
    BRAINVISA_COPY_DIRECTORY( "${BRAINVISA_REAL_SOURCE_DIR}/brainvisa"
                              brainvisa
                              ${PROJECT_NAME} )
endif()

if( EXISTS "${BRAINVISA_REAL_SOURCE_DIR}/scripts" )
    BRAINVISA_COPY_DIRECTORY( "${BRAINVISA_REAL_SOURCE_DIR}/scripts"
                              scripts
                              ${PROJECT_NAME} )
endif()

if( EXISTS "${BRAINVISA_REAL_SOURCE_DIR}/doc/source" )
    BRAINVISA_GENERATE_SPHINX_DOC( "${BRAINVISA_REAL_SOURCE_DIR}/doc/source"
        "share/doc/%(component_name)s-${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}" )
elseif( EXISTS "${BRAINVISA_REAL_SOURCE_DIR}/docs/source" )
    BRAINVISA_GENERATE_SPHINX_DOC( "${BRAINVISA_REAL_SOURCE_DIR}/docs/source"
        "share/doc/%(component_name)s-${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}" )
endif()

if( EXISTS "${BRAINVISA_REAL_SOURCE_DIR}/etc" )
    BRAINVISA_COPY_DIRECTORY( "${BRAINVISA_REAL_SOURCE_DIR}/etc"
                              etc
                              ${PROJECT_NAME} )
endif()

# tests

%(test_commands)s

UNSET( BRAINVISA_REAL_SOURCE_DIR )
'''

sitecustomize_module_content = '''# This file was generated by bv_maker
# Source file: %s
import os
import os.path as osp
import sys

path, ext = osp.splitext(__file__)
pth_file = path + '.pth'
main_dir = osp.dirname(osp.dirname(__file__))
try:
    i = sys.path.index(main_dir)
except ValueError:
    i = -1

# Stripping is necessary for cross compiling purpose
with open(pth_file) as f:
    paths = [l.strip('\\r\\n') for l in f.readlines()]
sys.path[i:i] = paths
''' % __file__

cmake_config_template = '''# This file was generated by bv_maker
# Source file: %(file)s

# Defines the following variables:
#   %(component)s_VERSION_MAJOR
#   %(component)s_VERSION_MINOR
#   %(component)s_VERSION_PATCH
#   %(component)s_VERSION
#   %(component_upper)s_FOUND

# Set version variables
set( %(component)s_VERSION_MAJOR %(version_major)s )
set( %(component)s_VERSION_MINOR %(version_minor)s )
set( %(component)s_VERSION_PATCH %(version_patch)s )
set( %(component)s_VERSION ${%(component)s_VERSION_MAJOR}.${%(component)s_VERSION_MINOR}.${%(component)s_VERSION_PATCH} )

find_package( PythonInterp REQUIRED )

set( %(component_upper)s_FOUND true )
'''


class PurePythonComponentBuild(object):
    bool_to_cmake_testref = {
        True: "TESTREF",
        False: ""
    }
    bv_add_test_cmd_fmt = '''brainvisa_add_test( {0}-tests{1} {4} {2} {3} )'''

    def __init__(self, component_name, source_directory, build_directory,
                 cross_compiling_directories, options=None, args=None):
        self.component_name = component_name
        self.source_directory = source_directory
        self.build_directory = build_directory
        self.cross_compiling_directories = cross_compiling_directories
        self.cross_compiling_directory_match = None
        # options from option parser:
        self.options = options
        self.args = args

        if cross_compiling_directories is not None:
            match = None
            match_length = 0
            for s, c in six.iteritems(cross_compiling_directories):
                if self.source_directory.startswith(s) \
                    and len(s) > match_length:
                    self.cross_compiling_directory_match = (s, c)
                    match_length = len(s)

            #print('==== Pure python best match:', self.cross_compiling_directory_match)

    def configure(self):
        # Create a bv_maker_pure_python.py module in
        # <build>/python/sitecustomize (which is created by bv_maker). Modules
        # in this directory are loaded at Python startup time (only in the
        # buld tree, they are not installed in packages). This module adds the
        # content of bv_maker_pure_python.pth file to sys.path, just before
        # the path <build>/python
        sitecustomize_dir = osp.join(self.build_directory.directory, 'python', 'sitecustomize')
        if not osp.exists(sitecustomize_dir):
            os.makedirs(sitecustomize_dir)
        module = osp.join(sitecustomize_dir,'bv_maker_pure_python.py')
        if osp.exists(module):
            with open(module, 'r') as f:
                write_sitecustomize = f.read() != sitecustomize_module_content
        else:
            write_sitecustomize = True
        if write_sitecustomize:
            with open(module, 'w') as f:
                f.write(sitecustomize_module_content)

        # Make sure file in pth_path contains self.source_directory
        pth_path = osp.join(sitecustomize_dir, 'bv_maker_pure_python.pth')
        if osp.exists(pth_path):
            with open(pth_path) as f:
                directories = f.read().split()
        else:
            directories = []

        sd = osp.join(self.source_directory, 'python')
        if not osp.exists(sd):
            sd = self.source_directory

        if self.cross_compiling_directory_match is not None:
            if len(self.cross_compiling_directory_match) == 2:
                match, repl = self.cross_compiling_directory_match
                old_sd = sd
                sd = osp.join(repl, string.lstrip(sd[len(match):], os.sep))
                #print('==== Pure python: cross_compiling replacement:', old_sd , '=>', sd)

            else:
                raise ValueError('Cross compiling directory match '
                               + str(self.cross_compiling_directory_match) + ' '
                                 'has inapropriate length. The list or tuple '
                                 'must contain 2 values: (match, replacement).')

        if sd not in directories:
            directories.append(sd)
            with open(pth_path, 'w') as f:
                f.write(os.linesep.join(directories))

        # Check for dependencies in info.py
        info = find_project_info(self.source_directory)
        brainvisa_dependencies = []
        tests = []
        if info:
            dinfo = {}
            execfile(info, dinfo, dinfo)
            dependencies = dinfo.get('brainvisa_dependencies', [])
            for dcomponent in dependencies:
                if isinstance(dcomponent, six.string_types):
                    d = {
                        'component': dcomponent,
                    }
                    if dcomponent in self.build_directory.components:
                        version = self.build_directory.components[dcomponent][2]
                        next_version = [int(i) for i in version.split('.')]
                        next_version[1] +=1
                        next_version = '%d.%d' % tuple(next_version)
                        d['version'] = version
                        d['next_version'] = next_version
                    else:
                        print('WARNING: component %s declares a dependency on %s in its info.py but build directory does not contain %s' % (self.component_name, dcomponent, dcomponent),
                              file=sys.stderr)
                        d['version'] = 'unknown'
                        d['next_version'] = 'unknown'
                    brainvisa_dependencies.append('BRAINVISA_DEPENDENCY(RUN DEPENDS %(component)s RUN ">= %(version)s; << %(next_version)s")' % d)
                    brainvisa_dependencies.append('BRAINVISA_DEPENDENCY(DEV DEPENDS %(component)s DEV ">= %(version)s; << %(next_version)s")' % d)
                else:
                    brainvisa_dependencies.append(
                        self.dependency_string(dcomponent))
            tests = dinfo.get('test_commands', [])
            test_timeouts = dinfo.get('test_timeouts', [])
        brainvisa_dependencies = '\n'.join(brainvisa_dependencies)

        # Create <build directory>/build_files/<component>_src/CMakeLists.txt
        src_directory = osp.join(self.build_directory.directory, 'build_files',
                                 '%s_src' % self.component_name)
        if not osp.exists(src_directory):
            os.makedirs(src_directory)
        # It is necessary to escape backslash ('\') characters because
        # cmake interpretes it in CMakeLists.txt files.
        source_file  = os.path.normpath(__file__).replace('\\', '\\\\')
        tests_str = self.build_tests_cmake_code(tests, test_timeouts)
        cmakelists_content = cmake_template % dict(
            file=source_file,
            component_name=self.component_name,
            source_directory= os.path.normpath(
                                  self.source_directory
                              ).replace('\\', '\\\\'),
            brainvisa_dependencies=brainvisa_dependencies,
            test_commands=tests_str
        )
        cmakelists_path = osp.join(src_directory, 'CMakeLists.txt')
        write_cmakelists = False
        if osp.exists(cmakelists_path):
            with open(cmakelists_path) as f:
                write_cmakelists = (f.read() != cmakelists_content)
        else:
            write_cmakelists = True
        if write_cmakelists:
            with open(cmakelists_path, 'w') as f:
                f.write(cmakelists_content)

        name, component, version = read_project_info(self.source_directory)[:3]
        cmake_dir = osp.join(self.build_directory.directory,
                             'share',
                             '%s-%s.%s' % (self.component_name, version[0],
                                           version[1]),
                             'cmake')
        if not os.path.exists(cmake_dir):
            os.makedirs(cmake_dir)
        cmake_config_path = osp.join(cmake_dir,
                                     '%s-config.cmake' % self.component_name)
        cmake_config_content = cmake_config_template % dict(
            file = source_file,
            component = self.component_name,
            component_upper = self.component_name.upper(),
            version_major = version[0],
            version_minor = version[1],
            version_patch = version[2],
            )
        if osp.exists(cmake_config_path):
            with open(cmake_config_path) as f:
                write_cmake_config = (f.read() != cmake_config_content)
        else:
            write_cmake_config = True
        if write_cmake_config:
            with open(cmake_config_path, 'w') as f:
                f.write(cmake_config_content)

        if self.options.clean:
            import brainvisa
            # look for <my_path>/bin when we are in <my_path>/python/brainvisa
            my_path = os.path.dirname(os.path.dirname(
                os.path.dirname(brainvisa.__file__)))
            bv_clean = os.path.join(my_path, 'bin', 'bv_clean_build_tree')
            if not os.path.exists(bv_clean):
                bv_clean = distutils.spawn.find_executable(
                    'bv_clean_build_tree')
            print('cleaning build tree', self.source_directory)
            subprocess.call([sys.executable, bv_clean, '-d',
                             self.source_directory])

    def build_tests_cmake_code(self, tests, test_timeouts=[]):
        tests_code = []
        if len(tests) != 0:
            tests_code = ['enable_testing()']
            if len(tests) >= 2:
              nnum = '%(num)d'
            else:
              nnum = ''
            for i, test in enumerate(tests):
                if len(test_timeouts) > i:
                    timeout = test_timeouts[i]
                else:
                    timeout = None
                if isinstance(test, (tuple, list)):
                    if len(test) != 2:
                        raise ValueError("content of test_commands must be a string or a 2-tuple (command, options)")
                    test_cmd, test_options = test
                    use_testref = self.bool_to_cmake_testref[
                        test_options.get('use_testref', False)
                    ]
                else:
                    test_cmd = test
                    use_testref = self.bool_to_cmake_testref[False]
                test_str = '"' + '" "'.join(shlex.split(test_cmd)) + '"'
                if timeout is not None:
                    timeout_str = 'TIMEOUT %f ' % timeout
                else:
                    timeout_str = ''
                bv_add_test = self.bv_add_test_cmd_fmt.format(
                    self.component_name, nnum % {'num': i}, test_str,
                    use_testref, timeout_str
                )
                tests_code.append(bv_add_test)
        tests_str = '\n'.join(tests_code)
        if len(tests_str) != 0:
            tests_str += '\n'
        return tests_str

    @staticmethod
    def dependency_string(dcomponent):
        ''' This bidiuille replaces dependencies on python-qt4 with either
        python-qt4 or python-qt5 depending on the cmake variable
        DESIRED_QT_VERSION
        '''
        if 'python-qt4' not in dcomponent:
            return 'BRAINVISA_DEPENDENCY(%s)' % ' '.join(
                '"%s"' % i for i in dcomponent)
        else:
            qt5_dep = (i.replace('qt4', 'qt5') for i in dcomponent)
            dep_string = '''if( DESIRED_QT_VERSION EQUAL 4 )
    BRAINVISA_DEPENDENCY(%s)
else()
    BRAINVISA_DEPENDENCY(%s)
endif()''' % (' '.join('"%s"' % i for i in dcomponent),
              ' '.join('"%s"' % i for i in qt5_dep))
            return dep_string
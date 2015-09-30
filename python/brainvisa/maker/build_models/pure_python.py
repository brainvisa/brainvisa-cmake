# -*- coding: utf-8 -*-
import os
import sys
import os.path as osp
import distutils.spawn
import subprocess

from brainvisa.maker.brainvisa_projects import read_project_info

cmake_template = '''# This file was generated by bv_maker
# Source file: %(file)s

cmake_minimum_required( VERSION 2.6 )

find_package( python REQUIRED )
find_package( Sphinx )
find_package( brainvisa-cmake REQUIRED )

SET( BRAINVISA_REAL_SOURCE_DIR "%(source_directory)s")
BRAINVISA_PROJECT()

BRAINVISA_DEPENDENCY( RUN DEPENDS python RUN ">= 2.5;<< 3.0" )
if( EXISTS "%(source_directory)s/python" )
    BRAINVISA_COPY_PYTHON_DIRECTORY( "%(source_directory)s/python"
                                     ${PROJECT_NAME} python
                                     INSTALL_ONLY )
else()
    BRAINVISA_COPY_PYTHON_DIRECTORY( "%(source_directory)s/%(component_name)s"
                                     ${PROJECT_NAME} python/%(component_name)s
                                     INSTALL_ONLY )
endif()
if( EXISTS "%(source_directory)s/bin" )
    BRAINVISA_COPY_DIRECTORY( "%(source_directory)s/bin"
                              bin
                              ${PROJECT_NAME} )
endif()

BRAINVISA_GENERATE_SPHINX_DOC( "%(source_directory)s/doc/source"
    "share/doc/capsul-${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}" )

set( BV_ENV_PYTHON_CMD 
     "${CMAKE_BINARY_DIR}/bin/bv_env" "${PYTHON_EXECUTABLE}" )

# tests
enable_testing()
add_test( %(component_name)s-tests "${CMAKE_BINARY_DIR}/bin/bv_env" "${PYTHON_EXECUTABLE}" "%(source_directory)s/test/test_%(component_name)s.py" )
UNSET( BRAINVISA_REAL_SOURCE_DIR)
'''

sitecustomize_module_content = '''# This file was generated by bv_maker
# Source file: %s
import os
import os.path as osp
import sys

path, ext = osp.splitext(__file__)
pth_file = path+'.pth'
main_dir = osp.dirname(osp.dirname(__file__))
try:
    i = sys.path.index(main_dir)
except ValueError:
    i = -1
sys.path[i:i] = open(pth_file).read().strip().split(os.linesep)
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
    def __init__(self, component_name, source_directory, build_directory,
                 options=None, args=None):
        self.component_name = component_name
        self.source_directory = source_directory
        self.build_directory = build_directory
        # options from option parser:
        self.options = options
        self.args = args

    def configure(self):
        # Create a bv_maker_pure_python.py module in 
        # <build>/python/sitecustomize (which is created by bv_maker). Modules
        # in this directory are loaded at Python startup time (only in the
        # buld tree, they are not installed in packages). This module adds the
        # content of bv_maker_pure_python.pth file to sys.path, just before
        # the path <build>/python
        sitecustomize_dir = osp.join(self.build_directory, 'python', 'sitecustomize')
        if not osp.exists(sitecustomize_dir):
            os.makedirs(sitecustomize_dir)
        module = osp.join(sitecustomize_dir,'bv_maker_pure_python.py')
        if not osp.exists(module) or open(module,'r').read() != sitecustomize_module_content:
            open(module,'w').write(sitecustomize_module_content)

        # Make sure file in pth_path contains self.source_directory
        pth_path = osp.join(sitecustomize_dir, 'bv_maker_pure_python.pth')
        if osp.exists(pth_path):
            directories = open(pth_path).read().split()
        else:
            directories = []
        sd = osp.join(self.source_directory, 'python')
        if not osp.exists(sd):
            sd = self.source_directory
        if sd not in directories:
            directories.append(sd)
            open(pth_path,'w').write( os.linesep.join(directories))

        # Create <build directory>/build_files/<component>_src/CMakeLists.txt
        src_directory = osp.join(self.build_directory, 'build_files', 
                                 '%s_src' % self.component_name)
        if not osp.exists(src_directory):
            os.makedirs(src_directory)
        # It is necessary to escape backslash ('\') characters because
        # cmake interpretes it in CMakeLists.txt files.
        source_file  = os.path.normpath(__file__).replace( '\\', '\\\\' )
        cmakelists_content = cmake_template % dict(
            file=source_file,
            component_name=self.component_name,
            source_directory= os.path.normpath(
                                  self.source_directory
                              ).replace( '\\', '\\\\' ) )
        cmakelists_path = osp.join(src_directory, 'CMakeLists.txt')
        write_cmakelists = False
        if osp.exists(cmakelists_path):
            write_cmakelists = (open(cmakelists_path).read() != 
                                cmakelists_content)
        else:
            write_cmakelists = True
        if write_cmakelists:
            open(cmakelists_path,'w').write(cmakelists_content)

        name, component, version = read_project_info(self.source_directory)
        cmake_dir = osp.join(self.build_directory,
                             'share', 
                             '%s-%s.%s' % (self.component_name, version[0], version[1]),
                             'cmake')
        if not os.path.exists(cmake_dir):
            os.makedirs(cmake_dir)
        cmake_config_path = osp.join(cmake_dir, '%s-config.cmake' % self.component_name)
        cmake_config_content = cmake_config_template % dict(
            file = source_file,
            component = self.component_name,
            component_upper = self.component_name.upper(),
            version_major = version[0],
            version_minor = version[1],
            version_patch = version[2],
            )
        if osp.exists(cmake_config_path):
            write_cmake_config = (open(cmake_config_path).read() != 
                                  cmake_config_content)
        else:
            write_cmake_config = True
        if write_cmake_config:
            open(cmake_config_path,'w').write(cmake_config_content)
            
        if self.options.clean:
            import brainvisa
            # look for <my_path>/bin when we are in <my_path>/python/brainvisa
            my_path = os.path.dirname(os.path.dirname(
                os.path.dirname(brainvisa.__file__)))
            bv_clean = os.path.join(my_path, 'bin', 'bv_clean_build_tree')
            if not os.path.exists(bv_clean):
                bv_clean = distutils.spawn.find_executable(
                    'bv_clean_build_tree')
            print 'cleaning build tree', self.source_directory
            subprocess.call([sys.executable, bv_clean, '-d',
                             self.source_directory])


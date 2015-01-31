import os
import os.path as osp

cmake_template = '''
cmake_minimum_required( VERSION 2.6 )

find_package( brainvisa-cmake REQUIRED )
SET( BRAINVISA_REAL_SOURCE_DIR "%(source_directory)s")
BRAINVISA_PROJECT()

BRAINVISA_DEPENDENCY( RUN DEPENDS python RUN ">= 2.5;<< 3.0" )
#BRAINVISA_COPY_PYTHON_DIRECTORY( "%(source_directory)s/%(component_name)s"
#                                  ${PROJECT_NAME} python/%(component_name)s )
find_package( python REQUIRED )
find_package( Sphinx )

BRAINVISA_GENERATE_SPHINX_DOC( "%(source_directory)s/doc/source"
    "share/doc/capsul-${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}" )

set( BV_ENV_PYTHON_CMD 
     "${CMAKE_BINARY_DIR}/bin/bv_env" "${PYTHON_EXECUTABLE}" )

# tests
enable_testing()
add_test( %(component_name)s-tests "${CMAKE_BINARY_DIR}/bin/bv_env" "${PYTHON_EXECUTABLE}" "%(source_directory)s/test/test_%(component_name)s.py" )
UNSET( BRAINVISA_REAL_SOURCE_DIR)
'''

class PurePythonComponentBuild(object):
    def __init__(self, component_name, source_directory, build_directory):
        self.component_name = component_name
        self.source_directory = source_directory
        self.build_directory = build_directory
        python_dir = osp.join(self.build_directory, 'python')
        if not osp.exists(python_dir):
            os.mkdir(python_dir)
        self.pth_path = osp.join(python_dir, 'pure_python.pth')

    def configure(self):
        # Make sure file in self.pth_path contains self.source_directory
        if osp.exists(self.pth_path):
            directories = open(self.pth_path).read().split()
        else:
            directories = []
        if self.source_directory not in directories:
            directories.append(self.source_directory)
            open(self.pth_path,'w').write('\n'.join(directories))
        
        # Create <build directory>/build_files/<component>_src/CMakeLists.txt
        src_directory = osp.join(self.build_directory, 'build_files', 
                                 '%s_src' % self.component_name)
        if not osp.exists(src_directory):
            os.makedirs(src_directory)
        cmakelists_content = cmake_template % dict(component_name=self.component_name,
            source_directory=self.source_directory)
        cmakelists_path = osp.join(src_directory, 'CMakeLists.txt')
        write_cmakelists = False
        if osp.exists(cmakelists_path):
            write_cmakelists = (open(cmakelists_path).read() != 
                                cmakelists_content)
        else:
            write_cmakelists = True
        if write_cmakelists:
            open(cmakelists_path,'w').write(cmakelists_content)
    
    def build(self):
        pass
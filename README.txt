How to setup, configure, and compile Soma software with CMake
-------------------------------------------------------------

With CMake, you always start by creating a build directory, configure it using CMakeLists.txt in source tree and start compilation. For Soma projects, one can either create a separate build directory for each project or create a single build tree using a meta source tree. A meta source tree contains only a CMakeLists.txt that will find and include a predefined list of projects.

1) Install soma-infra
The first step 
mkdir soma-infra
cd soma-infra
ccmake $P4/trunk/soma-infra
--> select an install directory in CMAKE_INSTALL_PREFIX.
    Upon "make install", it will create $CMAKE_INSTALL_PREFIX/share/soma-infra-<version> directory.
    CMake will be able to automatically find this directory if $CMAKE_INSTALL_PREFIX/bin is in your PATH.
    For more information, see command find_package in CMake documentation.
make
make install

1) Build each project separately.
---------------------------------

mkdir soma-base
cd soma-base
ccmake $P4/trunk/soma-base
--> Select a build mode in CMAKE_BUILD_TYPE
--> Eventually, select install prefix in CMAKE_INSTALL_PREFIX
make
make doc # to build documentation

mkdir aims
cd aims
ccmake $P4/trunk/aims
--> Select a build mode in CMAKE_BUILD_TYPE
--> Eventually, select install prefix in CMAKE_INSTALL_PREFIX
make
make doc # to build documentation

mkdir aims-gpl
cd aims-gpl
ccmake $P4/trunk/aims-gpl
--> CMake will fail to find aims and complaint. It is necessary
    to set aims_DIR to <aims build dir>/share/aims-<aims version>/cmake
--> Select a build mode in CMAKE_BUILD_TYPE
--> Eventually, select install prefix in CMAKE_INSTALL_PREFIX
make
make doc # to build documentation

mkdir anatomist
cd anatomist
ccmake $P4/trunk/anatomist
--> Some errors about a file /maketemplates.py that cannot be found will disapear when
    aims is configured correctly.
--> First, CMake will fail to find aims-gpl and complaint. It is necessary
    to set aims-gpl_DIR to <aims-gpl build dir>/share/aims-gpl-<aims-gpl version>/cmake
--> Once aims-gpl is found: CMake will fail to find aims and complaint. It is necessary
    to set aims_DIR to <aims build dir>/share/aims-<aims version>/cmake
--> Select a build mode in CMAKE_BUILD_TYPE
--> Eventually, select install prefix in CMAKE_INSTALL_PREFIX
make
make doc # to build documentation



2) Use build_all meta source tree.
----------------------------------

project( brainvisa-cmake )
cmake_minimum_required( VERSION 2.6 )

set( PACKAGE_VERSION_MAJOR 1 )
set( PACKAGE_VERSION_MINOR 0 )
set( PACKAGE_VERSION_PATCH 0 )

set( brainvisa-cmake_INSTALL_PREFIX "share/brainvisa-cmake-${PACKAGE_VERSION_MAJOR}.${PACKAGE_VERSION_MINOR}" )

configure_file( cmake/brainvisa-cmake-config.cmake.in
                "${brainvisa-cmake_INSTALL_PREFIX}/cmake/brainvisa-cmake-config.cmake" 
                @ONLY )
configure_file( cmake/brainvisa-cmake-config-version.cmake.in
                "${brainvisa-cmake_INSTALL_PREFIX}/cmake/brainvisa-cmake-config-version.cmake" 
                @ONLY )
install( FILES "${CMAKE_BINARY_DIR}/${brainvisa-cmake_INSTALL_PREFIX}/cmake/brainvisa-cmake-config.cmake"
               "${CMAKE_BINARY_DIR}/${brainvisa-cmake_INSTALL_PREFIX}/cmake/brainvisa-cmake-config-version.cmake"
         DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/cmake" )
install( FILES cmake/Doxyfile.in
               cmake/DoxyfileDefaultValues.cmake
               cmake/brainvisa-cmake-config-version.cmake.in
DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/cmake" )

file( GLOB _files "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/*[^~]" )
install( FILES ${_files} DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/cmake/modules" )

file( GLOB _files "${CMAKE_CURRENT_SOURCE_DIR}/scripts/*[^~]" )
install( FILES ${_files} DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/scripts" )

project( soma-infra )
cmake_minimum_required( VERSION 2.6 )

set( PACKAGE_VERSION_MAJOR 1 )
set( PACKAGE_VERSION_MINOR 2 )
set( PACKAGE_VERSION_PATCH 3 )

set( soma-infra_INSTALL_PREFIX "share/soma-infra-${PACKAGE_VERSION_MAJOR}.${PACKAGE_VERSION_MINOR}" )
# set( soma-infra_DIR "${CMAKE_SOURCE_DIR}" )
# include( soma-infra-config )

configure_file( cmake/soma-infra-config.cmake.in
                "${soma-infra_INSTALL_PREFIX}/cmake/soma-infra-config.cmake" 
                @ONLY )
configure_file( cmake/soma-infra-config-version.cmake.in
                "${soma-infra_INSTALL_PREFIX}/cmake/soma-infra-config-version.cmake" 
                @ONLY )
install( FILES "${CMAKE_BINARY_DIR}/${soma-infra_INSTALL_PREFIX}/cmake/soma-infra-config.cmake"
               "${CMAKE_BINARY_DIR}/${soma-infra_INSTALL_PREFIX}/cmake/soma-infra-config-version.cmake"
         DESTINATION "${soma-infra_INSTALL_PREFIX}/cmake" )
install( FILES cmake/version.py.in
               cmake/Doxyfile.in
               cmake/DoxyfileDefaultValues.cmake
         DESTINATION "${soma-infra_INSTALL_PREFIX}/cmake" )

file( GLOB _files "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/*" )
install( FILES ${_files} DESTINATION "${soma-infra_INSTALL_PREFIX}/cmake/modules" )

file( GLOB _files "${CMAKE_CURRENT_SOURCE_DIR}/scripts/*" )
install( FILES ${_files} DESTINATION "${soma-infra_INSTALL_PREFIX}/scripts" )

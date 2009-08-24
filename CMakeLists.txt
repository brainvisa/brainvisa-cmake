project( brainvisa-cmake )
cmake_minimum_required( VERSION 2.6 )


function( BRAINVISA_GLOB_AND_FILTER glob variable )
  file( ${glob} allFiles ${ARGN} )
  set( result )
  foreach( f ${allFiles} )
    get_filename_component( n "${f}" NAME )
    if ( NOT n STREQUAL ".svn" )
      set( result ${result} "${f}" )
    endif ( NOT n STREQUAL ".svn" )
  endforeach( f ${_allFiles} )
  set( ${variable} ${result} PARENT_SCOPE )
endfunction( BRAINVISA_GLOB_AND_FILTER variable )


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
file( GLOB _files "${CMAKE_CURRENT_SOURCE_DIR}/cmake/*.cmake" )
install( FILES ${_files}
         DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/cmake" )
install( FILES cmake/Doxyfile.in
               cmake/brainvisa-cmake-config-version.cmake.in
               cmake/debian-control-run.in
               cmake/debian-control-dev.in
         DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/cmake" )

BRAINVISA_GLOB_AND_FILTER( GLOB _files "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/*[^~]" )
install( FILES ${_files} 
         DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/cmake/modules" )

BRAINVISA_GLOB_AND_FILTER( GLOB _files "${CMAKE_CURRENT_SOURCE_DIR}/cmake/multiplatform/*[^~]" )
install( FILES ${_files} 
         DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/cmake/multiplatform" )

BRAINVISA_GLOB_AND_FILTER( GLOB _files "${CMAKE_CURRENT_SOURCE_DIR}/scripts/*[^~]" )
install( FILES ${_files}
         DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/scripts" )

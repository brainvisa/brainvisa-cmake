project( brainvisa-cmake NONE )
cmake_minimum_required( VERSION 2.6 )


function( BRAINVISA_GLOB_AND_FILTER glob variable )
  file( ${glob} allFiles ${ARGN} )
  set( result )
  foreach( f ${allFiles} )
    get_filename_component( n "${f}" NAME )
    if ( NOT IS_DIRECTORY "${f}" AND NOT n STREQUAL ".svn" )
      set( result ${result} "${f}" )
    endif ()
  endforeach()
  set( ${variable} ${result} PARENT_SCOPE )
endfunction()


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
file( GLOB _files "${CMAKE_CURRENT_SOURCE_DIR}/cmake/*.in" )
install( FILES ${_files}
         DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/cmake" )
install( FILES cmake/CMakeLists.txt
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

BRAINVISA_GLOB_AND_FILTER( GLOB _files "${CMAKE_CURRENT_SOURCE_DIR}/scripts/windows/*[^~]" )
install( FILES ${_files}
         DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/scripts/windows" )

# Packaging
configure_file( "${CMAKE_CURRENT_SOURCE_DIR}/debian-control.in"
                "${CMAKE_BINARY_DIR}/debian-control" 
                @ONLY )
set( packageName "${CMAKE_BINARY_DIR}/brainvisa-cmake-${PACKAGE_VERSION_MAJOR}.${PACKAGE_VERSION_MINOR}.${PACKAGE_VERSION_PATCH}.deb" )
set( tmpDir "/tmp/brainvisa-cmake_create_deb" )
add_custom_command( OUTPUT "${packageName}"
  DEPENDS "${CMAKE_BINARY_DIR}/debian-control"
  COMMENT "Creating package \"${packageName}\""
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${tmpDir}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${tmpDir}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${tmpDir}/DEBIAN"
  COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/debian-control" "${tmpDir}/DEBIAN/control"
  COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${tmpDir}${CMAKE_INSTALL_PREFIX}" -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
  COMMAND dpkg --build "${tmpDir}" "${packageName}"
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${tmpDir}"
)
add_custom_target( "package" DEPENDS "${packageName}" )


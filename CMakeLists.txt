project( brainvisa-cmake CXX )
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
foreach( _dir cmake cmake/specific cmake/specific/linux_distribution cmake/specific/windows )
  file( GLOB _files "${CMAKE_CURRENT_SOURCE_DIR}/${_dir}/*.cmake" )
  install( FILES ${_files}
           DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/${_dir}" )
endforeach()
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
set( PACKAGE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}" CACHE PATH "Installation path for debian package" )
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
  COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${tmpDir}${PACKAGE_INSTALL_PREFIX}" -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
  COMMAND dpkg --build "${tmpDir}" "${packageName}"
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${tmpDir}"
)
add_custom_target( "package" DEPENDS "${packageName}" )

set( CMAKE_EXE_LINKER_FLAGS -static )
add_executable( bv_env src/bv_env.cc )
set_target_properties( bv_env PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin" )
install( TARGETS bv_env
         DESTINATION bin )

install( DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/python"
         DESTINATION "${CMAKE_INSTALL_PREFIX}"
         USE_SOURCE_PERMISSIONS
         PATTERN ".svn" EXCLUDE
         PATTERN "*~" EXCLUDE )

install( DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/bin"
         DESTINATION "${CMAKE_INSTALL_PREFIX}"
         USE_SOURCE_PERMISSIONS
         PATTERN ".svn" EXCLUDE
         PATTERN "*~" EXCLUDE )

# Generate a list of all brainvisa-cmake installed files
# so that bv_maker can copy and already installed brainvisa-cmake
if( NOT DISABLE_FILE_INSTALLATION_LIST )
  # Must remove the CMakeCache before configuring again brainvisa-cmake into a new tmp build directory, 
  # else the source directory is considered as a build directory and the build files are not copied into tmp directory
  if( EXISTS "${CMAKE_BINARY_DIR}/CMakeCache.txt" )
    execute_process( COMMAND "${CMAKE_COMMAND}" -E remove "${CMAKE_BINARY_DIR}/CMakeCache.txt" )
  endif()
  set( tmp "${CMAKE_BINARY_DIR}/tmp" )
  execute_process( COMMAND "${CMAKE_COMMAND}" -E make_directory "${tmp}" )
  execute_process( COMMAND "${CMAKE_COMMAND}" -E make_directory "${tmp}/install" )
  execute_process( COMMAND "${CMAKE_COMMAND}"  "-G" "${CMAKE_GENERATOR}" -DDISABLE_FILE_INSTALLATION_LIST=YES "-DCMAKE_INSTALL_PREFIX:STRING=${tmp}/install" "${CMAKE_CURRENT_SOURCE_DIR}"
                   WORKING_DIRECTORY "${tmp}"
                   OUTPUT_QUIET 
                   ERROR_QUIET )
  execute_process( COMMAND "${CMAKE_MAKE_PROGRAM}" install
                   WORKING_DIRECTORY "${tmp}"
                   OUTPUT_QUIET 
                   ERROR_QUIET )
  file( GLOB_RECURSE installed_files RELATIVE "${tmp}/install" "${tmp}/install/*" )
  execute_process( COMMAND "${CMAKE_COMMAND}" -E remove_directory "${tmp}" )
  file( WRITE "${CMAKE_BINARY_DIR}/installed_files.txt" "" )
  foreach( i ${installed_files} )
    file( APPEND "${CMAKE_BINARY_DIR}/installed_files.txt" "${i}\n" )
  endforeach()
  install( FILES "${CMAKE_BINARY_DIR}/installed_files.txt"
           DESTINATION "${CMAKE_INSTALL_PREFIX}/python/brainvisa/maker" )
endif()

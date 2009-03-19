cmake_minimum_required( VERSION 2.6 )

set( CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}" ${CMAKE_PREFIX_PATH} )
set( SOMA_ALL_PROJECTS soma-base aims aims-gpl anatomist brainvisa CACHE STRING "List of projects to compile" )
set( SOMA_PACKAGING_TEMPORARY_DIRECTORY /tmp/somaPackaging CACHE STRING "Temporary directory for creating packages" )

find_package( soma-infra REQUIRED )
SOMA_CREATE_MAIN_COMPONENTS()

set( _packagesCommands )
foreach( _project ${SOMA_ALL_PROJECTS} )
  add_subdirectory( "$ENV{P4}/trunk/${_project}" "${_project}" )
  set( _tmpDir "${SOMA_PACKAGING_TEMPORARY_DIRECTORY}/${_project}" )
  set( _packagesCommands ${_packagesCommands}
       COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
       COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}"
       COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}" -DCMAKE_INSTALL_COMPONENT=${_project} -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
       COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}-devel"
       COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}-devel"
       COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}-devel" -DCMAKE_INSTALL_COMPONENT=${_project}-devel -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
  )
endforeach( _project ${SOMA_ALL_PROJECTS} )

add_custom_target( packages
  COMMAND ${CMAKE_COMMAND} -E make_directory "${SOMA_PACKAGING_TEMPORARY_DIRECTORY}"
  ${_packagesCommands}
)
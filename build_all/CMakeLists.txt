cmake_minimum_required( VERSION 2.6 )

set( CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}" ${CMAKE_PREFIX_PATH} )
set( SOMA_ALL_PROJECTS soma-base aims aims-gpl anatomist brainvisa CACHE STRING "List of projects to compile" )
set( SOMA_PACKAGING_TEMPORARY_DIRECTORY /tmp/somaPackaging CACHE STRING "Temporary directory for creating packages" )

find_package( soma-infra REQUIRED )
SOMA_CREATE_MAIN_COMPONENTS()

set( _allPackages )
foreach( _project ${SOMA_ALL_PROJECTS} )
  add_subdirectory( "$ENV{P4}/trunk/${_project}" "${_project}" )
  set( _tmpDir "${SOMA_PACKAGING_TEMPORARY_DIRECTORY}/${_project}" )
  set( _packageName "${SOMA_PACKAGING_TEMPORARY_DIRECTORY}/${_project}-${${_project}_VERSION}-linux-i686.tar.bz2" )
  set( _packageNameDevel "${SOMA_PACKAGING_TEMPORARY_DIRECTORY}/${_project}-devel-${${_project}_VERSION}-linux-i686.tar.bz2" )
  add_custom_command( OUTPUT "${_packageName}"
    COMMENT "Packaging ${_packageName}"
    COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}"
    COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}" -DCMAKE_INSTALL_COMPONENT=${_project} -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
    COMMAND tar "--directory=${_tmpDir}" -jcf "${_packageName}" .
    COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
  )
  set( _allPackages ${_allPackages} "${_packageName}" )

  add_custom_command( OUTPUT "${_packageNameDevel}"
    COMMENT "Packaging ${_packageNameDevel}"
    COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
    COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}-devel"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}-devel"
    COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}-devel" -DCMAKE_INSTALL_COMPONENT=${_project}-devel -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
    COMMAND tar "--directory=${_tmpDir}-devel" -jcf "${_packageNameDevel}" .
    COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}-devel"
  )
  set( _allPackages ${_allPackages} "${_packageNameDevel}" )
endforeach( _project ${SOMA_ALL_PROJECTS} )


find_package( Sigc++2-install REQUIRED )
set( _packageName "${SOMA_PACKAGING_TEMPORARY_DIRECTORY}/system-linux-i686.tar.bz2" )
set( _tmpDir "${SOMA_PACKAGING_TEMPORARY_DIRECTORY}/system" )
add_custom_command( OUTPUT "${_packageName}"
  COMMENT "Packaging ${_packageName}"
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}"
  COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}" -DCMAKE_INSTALL_COMPONENT=system-runtime -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
  COMMAND tar "--directory=${_tmpDir}" -jcf "${_packageName}" .
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
)
set( _allPackages ${_allPackages} "${_packageName}" )


add_custom_target( packages
  COMMAND ${CMAKE_COMMAND} -E make_directory "${SOMA_PACKAGING_TEMPORARY_DIRECTORY}"
  DEPENDS ${_allPackages}
)

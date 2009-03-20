cmake_minimum_required( VERSION 2.6 )

set( CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}" ${CMAKE_PREFIX_PATH} )
set( SOMA_ALL_PROJECTS soma-base aims aims-gpl anatomist brainvisa CACHE STRING "List of projects to compile" )
set( SOMA_PACKAGING_TEMPORARY_DIRECTORY /tmp/somaPackaging CACHE STRING "Temporary directory for creating packages" )

find_package( soma-infra REQUIRED )
SOMA_CREATE_MAIN_COMPONENTS()

foreach( _project ${SOMA_ALL_PROJECTS} )
  add_subdirectory( "$ENV{P4}/trunk/${_project}" "${_project}" )
endforeach( _project ${SOMA_ALL_PROJECTS} )


find_package( Sigc++2-install REQUIRED )

SOMA_CREATE_PACKAGING_RULES()

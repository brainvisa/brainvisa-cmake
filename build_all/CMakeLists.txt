cmake_minimum_required( VERSION 2.6 )

set( CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}" ${CMAKE_PREFIX_PATH} )

find_package( soma-infra REQUIRED )
SOMA_CREATE_MAIN_COMPONENTS()

foreach( _project soma-base aims aims-gpl anatomist brainvisa )
  add_subdirectory( "$ENV{P4}/trunk/${_project}" "${_project}" )
endforeach( _project soma-base aims aims-gpl anatomist )

cmake_minimum_required( VERSION 2.6 )

set( SOMA_BUILD_ALL_FROM_SOURCES true )

find_package( soma-infra REQUIRED )
SOMA_CREATE_MAIN_COMPONENTS()

# project( soma-build-all )

foreach( _project soma-base aims aims-gpl anatomist )
  add_subdirectory( "$ENV{P4}/trunk/${_project}" "${_project}" )
endforeach( _project soma-base aims aims-gpl anatomist )

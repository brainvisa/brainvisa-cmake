# This will be the main CMakeLists.txt of aims project.
# It is still work in progress, this is why there are
# several $ENV{P4} that will disappear later.

cmake_minimum_required( VERSION 2.6 )

set( SOMA_BUILD_ALL_FROM_SOURCES true )

find_package( soma-infra REQUIRED )

add_subdirectory( $ENV{P4}/soma-main soma-base )

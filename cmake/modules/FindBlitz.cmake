# Try to find the Blitz++ library
# Once done this will define
#
# BLITZ_FOUND        - system has blitz++ and it can be used
# BLITZ_INCLUDE_DIRS - directory where the header file can be found
# BLITZ_LIBRARIES    - the blitz libraries
#

set( _directories
  "${BLITZ_DIR}"
)
set( _librarySuffixes
  lib
  blitz/lib
)
set( _includeSuffixes
  include
  blitz/include
)

find_path( BLITZ_INCLUDE_DIRS blitz/blitz.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
)

find_library( BLITZ_LIBRARIES blitz
    PATHS ${_directories}
    PATH_SUFFIXES ${_librarySuffixes}
)


if( BLITZ_INCLUDE_DIRS AND BLITZ_LIBRARIES )
  set( BLITZ_FOUND "YES" )
endif()

if( NOT BLITZ_FOUND )
  set( BLITZ_DIR "" CACHE PATH "Root of Blitz++ source tree (optional)." )
  mark_as_advanced( BLITZ_DIR )
endif()


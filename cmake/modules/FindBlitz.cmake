# Try to find the Blitz++ library
# Once done this will define
#
# BLITZ_FOUND        - system has blitz++ and it can be used
# BLITZ_INCLUDE_DIRS - directory where the header file can be found
# BLITZ_LIBRARIES    - the blitz libraries
#

if(NOT BLITZ_DIR)
  find_package(PkgConfig)
  PKG_CHECK_MODULES(BLITZ blitz)
  set(BLITZ_DIR ${BLITZ_PREFIX})
endif(NOT BLITZ_DIR)

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
  lib/blitz/include
)

find_path( BLITZ_INCLUDE_DIR blitz/blitz.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
)

find_path( BLITZ_CONFIG_INCLUDE_DIR blitz/gnu/bzconfig.h
PATHS ${_directories}
PATH_SUFFIXES ${_includeSuffixes}
)


find_library( libs blitz
    PATHS ${_directories}
    PATH_SUFFIXES ${_librarySuffixes}
)
set(BLITZ_LIBRARIES ${libs})

if( BLITZ_INCLUDE_DIR AND BLITZ_LIBRARIES )
  set( BLITZ_FOUND "YES" )
  if( BLITZ_CONFIG_INCLUDE_DIR )
    set( BLITZ_INCLUDE_DIRS
      "${BLITZ_INCLUDE_DIR}" "${BLITZ_CONFIG_INCLUDE_DIR}" )
  else()
    set( BLITZ_INCLUDE_DIRS "${BLITZ_INCLUDE_DIR}" )
  endif()
endif()

if( NOT BLITZ_FOUND )
  set( BLITZ_DIR "" CACHE PATH "Root of Blitz++ source tree (optional)." )
  mark_as_advanced( BLITZ_DIR )
endif()


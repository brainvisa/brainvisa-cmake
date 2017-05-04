# Try to find the minc library
# Once done this will define
#
# MINC_FOUND        - system has minc and it can be used
# MINC_INCLUDE_DIRS - directory where the header file can be found
# MINC_LIBRARIES    - the minc libraries
#
# Need to look for Netcdf and hdf5 as well

IF( MINC_FIND_QUIETLY )
  FIND_PACKAGE(NETCDF QUIET)
  FIND_PACKAGE(HDF5   QUIET)
ELSE( MINC_FIND_QUIETLY )
  FIND_PACKAGE(NETCDF)
  FIND_PACKAGE(HDF5)
ENDIF( MINC_FIND_QUIETLY )

IF( NETCDF_FOUND OR HDF5_FOUND )

set( _directories
  "${MINC_DIR}" "/usr/lib/x86_64-linux-gnu"
)
set( _librarySuffixes
  lib
  minc/lib
)
set( _includeSuffixes
  include
  minc/include
)

find_path( MINC_INCLUDE_DIR minc.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
)

find_library( MINC_minc_LIBRARY minc
    PATHS ${_directories}
    PATH_SUFFIXES ${_librarySuffixes}
)

if( HDF5_FOUND )
  find_path( MINC2_INCLUDE_DIR minc2.h
      PATHS ${_directories}
      PATH_SUFFIXES ${_includeSuffixes}
  )

  if( MINC_INCLUDE_DIR )
      set(HAVE_MINC1    ON)
  endif()

  if( MINC2_INCLUDE_DIR )
    set( MINC2_FOUND "1" )
    set(HAVE_MINC2    1)

    if( NOT MINC_INCLUDE_DIR )
      set( MINC_INCLUDE_DIR ${MINC2_INCLUDE_DIR} )
    endif()

    if( NOT MINC_minc_LIBRARY )
      find_library( MINC_minc_LIBRARY minc2
        PATHS ${_directories}
        PATH_SUFFIXES ${_librarySuffixes}
      )
    endif( NOT MINC_minc_LIBRARY )
  endif()
endif()

set( _minc_hdf5_version "1" )


if( MINC_volumeio_LIBRARY AND NOT EXISTS ${MINC_volumeio_LIBRARY} )
  set( MINC_volumeio_LIBRARY "" CACHE STRING "Minc IO lib" )
endif()

find_library( MINC_volumeio_LIBRARY volume_io2
  PATHS ${_directories}
  HINTS /usr/lib/x86_64-linux-gnu
  PATH_SUFFIXES ${_librarySuffixes}
)
if( NOT MINC_volumeio_LIBRARY OR NOT EXISTS ${MINC_volumeio_LIBRARY} )
  find_library( MINC_volumeio_LIBRARY minc_io
    PATHS ${_directories}
    HINTS /usr/lib/x86_64-linux-gnu
    PATH_SUFFIXES ${_librarySuffixes}
  )
  if( MINC_volumeio_LIBRARY AND EXISTS ${MINC_volumeio_LIBRARY} )
    set( _minc_hdf5_version "2" )
  endif()
endif()

if( NOT MINC_volumeio_LIBRARY OR NOT EXISTS ${MINC_volumeio_LIBRARY} )
  find_library( MINC_volumeio_LIBRARY volume_io
      PATHS ${_directories}
      HINTS /usr/lib/x86_64-linux-gnu
      PATH_SUFFIXES ${_librarySuffixes}
  )
endif()



IF( MINC_INCLUDE_DIR )
IF( MINC_minc_LIBRARY )
IF( MINC_volumeio_LIBRARY )

  SET( MINC_FOUND "YES" )

  set( LIBMINC_DEFINITIONS ${HDF5_DEFINITIONS} )
  if( _minc_hdf5_version STREQUAL "1" )
    set( LIBMINC_DEFINITIONS "-DH5_USE_16_API" )
  endif()

  SET(LIBMINC_INCLUDE_DIRS
     ${MINC_INCLUDE_DIR}
     ${NETCDF_INCLUDE_DIR}
     ${HDF5_INCLUDE_DIRS}
     CACHE FILEPATH "MINC include paths"
  )

  SET(LIBMINC_LIBRARIES
    ${MINC_volumeio_LIBRARY}
    ${MINC_minc_LIBRARY}
    ${NETCDF_LIBRARY}
    ${HDF5_LIBRARIES}
    CACHE FILEPATH "MINC libraries"
  )

  IF(HAVE_MINC1)
    set( LIBMINC_DEFINITIONS ${LIBMINC_DEFINITIONS} -DHAVE_MINC1=1 )
  ENDIF(HAVE_MINC1)

  IF(HAVE_MINC2)
    SET(MINC2 "1")
      # -DMINC2=1 causes problems for now in aimsminc
#     set( LIBMINC_DEFINITIONS ${LIBMINC_DEFINITIONS} -DMINC2=1 -DHAVE_MINC2=1 )
    set( LIBMINC_DEFINITIONS ${LIBMINC_DEFINITIONS} -DHAVE_MINC2=1 )
  ENDIF(HAVE_MINC2)

  set( LIBMINC_DEFINITIONS ${LIBMINC_DEFINITIONS} CACHE STRING "MINC library definitions" )

ENDIF( MINC_volumeio_LIBRARY )
ENDIF( MINC_minc_LIBRARY )
ENDIF( MINC_INCLUDE_DIR )

IF( NOT MINC_FOUND )
  SET( MINC_DIR "" CACHE PATH "Root of MINC source tree (optional)." )
  MARK_AS_ADVANCED( MINC_DIR )
ENDIF( NOT MINC_FOUND )

ELSE( NETCDF_FOUND OR HDF5_FOUND )
  MESSAGE("Minc libraries requires Netcdf or Hdf5 libraries to be set.")
ENDIF( NETCDF_FOUND OR HDF5_FOUND )

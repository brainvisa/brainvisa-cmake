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

IF( NETCDF_FOUND AND HDF5_FOUND )

set( _directories
  "${MINC_DIR}"
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
if( NOT MINC_minc_LIBRARY )
  find_library( MINC_minc_LIBRARY minc2
    PATHS ${_directories}
    PATH_SUFFIXES ${_librarySuffixes}
  )
endif( NOT MINC_minc_LIBRARY )


find_library( MINC_volumeio_LIBRARY volume_io
    PATHS ${_directories}
    PATH_SUFFIXES ${_librarySuffixes}
)
if( NOT MINC_volumeio_LIBRARY )
  find_library( MINC_volumeio_LIBRARY volume_io2
    PATHS ${_directories}
    PATH_SUFFIXES ${_librarySuffixes}
  )
endif( NOT MINC_volumeio_LIBRARY )


IF( MINC_INCLUDE_DIR )
IF( MINC_minc_LIBRARY )
IF( MINC_volumeio_LIBRARY )

  SET( MINC_FOUND "YES" )

  SET(MINC_INCLUDE_DIRS
     ${MINC_INCLUDE_DIR}
     ${NETCDF_INCLUDE_DIR}
     ${HDF5_INCLUDE_DIR}
  )

  SET(MINC_LIBRARIES
    ${MINC_volumeio_LIBRARY}
    ${MINC_minc_LIBRARY}
    ${NETCDF_LIBRARY}
    ${HDF5_LIBRARY}
  )

ENDIF( MINC_volumeio_LIBRARY )
ENDIF( MINC_minc_LIBRARY )
ENDIF( MINC_INCLUDE_DIR )

IF( NOT MINC_FOUND )
  SET( MINC_DIR "" CACHE PATH "Root of MINC source tree (optional)." )
  MARK_AS_ADVANCED( MINC_DIR )
ENDIF( NOT MINC_FOUND )

ELSE( NETCDF_FOUND AND HDF5_FOUND )
  MESSAGE("Minc libraries requires Netcdf and Hdf5 libraries to be set.")
ENDIF( NETCDF_FOUND AND HDF5_FOUND )
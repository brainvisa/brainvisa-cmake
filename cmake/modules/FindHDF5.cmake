# Try to find the hdf5 library
# Once done this will define
#
# HDF5_FOUND        - system has minc and it can be used
# HDF5_INCLUDE_DIR  - directory where the header file can be found
# HDF5_LIBRARIES    - the minc libraries
#
# Need to look for Netcdf and hdf5 as well


FIND_PATH( HDF5_INCLUDE_DIR hdf5.h
  ${HDF5_DIR}/include
  /usr/include 
)

FIND_LIBRARY( HDF5_LIBRARY hdf5
  ${HDF5_DIR}/lib
  /usr/lib
)



IF( HDF5_INCLUDE_DIR )
IF( HDF5_LIBRARY )

  SET( HDF5_FOUND "YES" )

ENDIF( HDF5_LIBRARY )
ENDIF( HDF5_INCLUDE_DIR )

IF( NOT HDF5_FOUND )
  SET( HDF5_DIR "" CACHE PATH "Root of HDF5 source tree (optional)." )
  MARK_AS_ADVANCED( HDF5_DIR )
ENDIF( NOT HDF5_FOUND )

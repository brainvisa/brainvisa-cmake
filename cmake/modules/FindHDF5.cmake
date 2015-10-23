# Try to find the hdf5 library
# Once done this will define
#
# HDF5_FOUND         - system has hdf5 and it can be used
# HDF5_INCLUDE_DIR - directory where the header file can be found
# HDF5_LIBRARIES     - the hdf5 libraries


if( NOT HDF5_FOUND )

  # First, try to use the FindHDF5 module included with CMake 2.8 and later
  include("${CMAKE_ROOT}/Modules/FindHDF5.cmake" OPTIONAL)

  # for compatibility with our older code
  if( HDF5_FOUND )
    set( HDF5_LIBRARY ${HDF5_LIBRARIES} CACHE FILEPATH "HDF5 library" )
  endif()

  # Fall back to a simpler detection method
  if( NOT HDF5_FOUND )

    FIND_PATH( HDF5_INCLUDE_DIR hdf5.h
      ${HDF5_DIR}/include
      /usr/include
    )

    FIND_LIBRARY( HDF5_LIBRARIES hdf5
      ${HDF5_DIR}/lib
      /usr/lib
    )

    IF( HDF5_INCLUDE_DIR )
    IF( HDF5_LIBRARIES )

      SET( HDF5_FOUND "YES" )

    ENDIF( HDF5_LIBRARIES )
    ENDIF( HDF5_INCLUDE_DIR )

    IF( NOT HDF5_FOUND )
      SET( HDF5_DIR "" CACHE PATH "Root of HDF5 source tree (optional)." )
      MARK_AS_ADVANCED( HDF5_DIR )
    ENDIF( NOT HDF5_FOUND )
  endif()

  # For compatibility with our older code
  if( HDF5_FOUND )
    set( HDF5_LIBRARY ${HDF5_LIBRARIES} CACHE FILEPATH "HDF5 library" )
    if( NOT HDF5_INCLUDE_DIR )
      set( HDF5_INCLUDE_DIR ${HDF5_C_INCLUDE_DIR} )
    endif()
  endif()

endif()

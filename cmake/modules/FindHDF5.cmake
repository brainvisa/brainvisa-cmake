# Try to find the hdf5 library
# Once done this will define
#
# HDF5_FOUND        - system has minc and it can be used
# HDF5_INCLUDE_DIR  - directory where the header file can be found
# HDF5_LIBRARIES    - the minc libraries
#
# Need to look for Netcdf and hdf5 as well

if( NOT HDF5_FOUND )
  if( CMAKE_VERSION VERSION_GREATER "2.8" )
      # remove local modules path from CMAKE_MODULE_PATH
      # we have to take care of duplicated entries pointing to it
      # with potentially different names (symlinks), so we have to use
      # realpath for each item.
      set( _tmp_path ${CMAKE_MODULE_PATH} )
      get_filename_component( _moddir "${brainvisa-cmake_DIR}/modules"
        REALPATH )
      set( _modpaths )
      foreach( _path ${CMAKE_MODULE_PATH} )
        get_filename_component( _p ${_path} REALPATH )
        list( APPEND _modpaths ${_p} )
      endforeach()
      list( REMOVE_DUPLICATES _modpaths )
      list( REMOVE_ITEM _modpaths "${_moddir}" )
      set(CMAKE_MODULE_PATH ${_modpaths})
      find_package( HDF5 )
      set( CMAKE_MODULE_PATH ${_tmp_path} )

      # for compatibility with our older code
      if( HDF5_FOUND )
        set( HDF5_LIBRARY ${HDF5_LIBRARIES} )
      endif()
  endif()
endif()

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

    # for compatibility with our older code
    set( HDF5_LIBRARY ${HDF5_LIBRARIES} CACHE FILEPATH "HDF5 library" )
    SET( HDF5_FOUND "YES" )

  ENDIF( HDF5_LIBRARIES )
  ENDIF( HDF5_INCLUDE_DIR )

  IF( NOT HDF5_FOUND )
    SET( HDF5_DIR "" CACHE PATH "Root of HDF5 source tree (optional)." )
    MARK_AS_ADVANCED( HDF5_DIR )
  ENDIF( NOT HDF5_FOUND )

endif()


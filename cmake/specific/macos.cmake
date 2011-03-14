if( APPLE )
  set( CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "/usr/local/jpeg"
    "/usr/local/tiff" "/usr/local/sqlite3" "/usr/local/netcdf"
    "/usr/local/hdf5" )
endif()

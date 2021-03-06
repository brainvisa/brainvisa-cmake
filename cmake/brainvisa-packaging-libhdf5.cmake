find_package( HDF5 )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  if(HDF5_VERSION)
    set( ${package_version} "${HDF5_VERSION}" PARENT_SCOPE )
  else()
    set( ${package_version} "0.0.0" PARENT_SCOPE )
  endif()
  
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS zlib RUN )
  if((LSB_DISTRIB STREQUAL ubuntu
      AND LSB_DISTRIB_RELEASE VERSION_GREATER 16.0) 
     OR (LSB_DISTRIB STREQUAL "centos linux"
        AND LSB_DISTRIB_RELEASE VERSION_GREATER "7.4"))
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS szlib RUN )
  endif()
  if( HDF5_IS_PARALLEL )
    # mpi variant: depend on libmpi
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libmpi RUN )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(HDF5_FOUND)
    # depending on cmake version, HDF5_hdf5_LIBRARY_RELEASE may not be defined
    if( HDF5_C_LIBRARIES )
      set( _libs ${HDF5_C_LIBRARIES} ${HDF5_HL_LIBRARIES} )
    elseif( HDF5_hdf5_LIBRARY_RELEASE )
      set( _libs ${HDF5_hdf5_LIBRARY_RELEASE} ${HDF5_HL_LIBRARIES} )
    else()
      set( _libs ${HDF5_LIBRARIES} ${HDF5_HL_LIBRARIES} )
    endif()
    if( NOT HDF5_HL_LIBRARIES )
      list( APPEND _libs ${HDF5_hdf5_hl_LIBRARY} )
    endif()
    set( _libs_install )
    foreach( _lib ${_libs} )
      string( REGEX MATCH "hdf5" _match ${_lib} )
      if( _match )
        list( APPEND _libs_install ${_lib} )
      endif()
    endforeach()
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${_libs_install} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


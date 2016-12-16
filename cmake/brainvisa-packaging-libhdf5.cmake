find_package( HDF5 )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  if( EXISTS "${HDF5_C_INCLUDE_DIR}/H5pubconf.h" )
    file( READ "${HDF5_C_INCLUDE_DIR}/H5pubconf.h" header )
    string( REGEX MATCH "#define[ \\t]+H5_VERSION[ \\t]+\"([^\"]+)\"" match "${header}" )
    if( match )
      set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
    endif()
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(HDF5_FOUND)
    # depending on cmake version, HDF5_hdf5_LIBRARY_RELEASE may not be defined
    if( NOT HDF5_hdf5_LIBRARY_RELEASE )
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} $
        {HDF5_LIBRARY} )
    else()
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} $
        {HDF5_hdf5_LIBRARY_RELEASE} )
    endif()
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


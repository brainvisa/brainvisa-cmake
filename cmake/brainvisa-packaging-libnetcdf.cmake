find_package( NETCDF )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  if( EXISTS "${NETCDF_INCLUDE_DIR}/netcdf_meta.h" )
    file( READ "${NETCDF_INCLUDE_DIR}/netcdf_meta.h" header )
    string( REGEX MATCH "#define[ \\t]+NC_VERSION[ \\t]+\"([^\"]+)\"" match "${header}" )
    if( match )
      set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
    endif()
  endif()
  if( NETCDF_NEEDS_MPI ) # set by find_package( NETCDF )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libmpi RUN )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV DEPENDS libmpi DEV )
  endif()
#   if( LSB_DISTRIB STREQUAL ubuntu
#       AND LSB_DISTRIB_RELEASE VERSION_GREATER 12.0 )
#     BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libcurl RUN )
#   endif()

endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(NETCDF_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${NETCDF_LIBRARY} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


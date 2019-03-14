find_package( NETCDF )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  if(NETCDF_VERSION)
    set( ${package_version} "${NETCDF_VERSION}" PARENT_SCOPE )
  else()
    set( ${package_version} "0.0.0" PARENT_SCOPE )
  endif()
  
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libhdf5 RUN )
  if( NETCDF_NEEDS_MPI ) # set by find_package( NETCDF )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libmpi RUN )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV DEPENDS libmpi DEV )
  endif()
  if( PC_NETCDF_LIBRARIES )
    list( FIND PC_NETCDF_LIBRARIES z _use_libz )
    if( _use_libz )
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS zlib RUN )
    endif()
    list( FIND PC_NETCDF_LIBRARIES sz _use_libsz )
    if( _use_libsz )
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS szlib RUN )
    endif()
  # else() # ??
  endif()
#   if( LSB_DISTRIB STREQUAL ubuntu
#       AND LSB_DISTRIB_RELEASE VERSION_GREATER 12.0 )
#     BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libcurl RUN )
#   endif()

endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(NETCDF_FOUND)
    set( _netcdf_libs )
    foreach( lib ${NETCDF_LIBRARY} )
      # filter out system libs and libs which are part of other packages
      get_filename_component( _l ${lib} NAME_WE )
      # message( "***** netcdf lib: ${_l} *****" )
      if( ${_l} STREQUAL libdl OR ${_l} STREQUAL libz OR ${_l} STREQUAL libsz
          OR ${_l} STREQUAL libpthread OR ${_l} STREQUAL libm )
        # TODO: add libcurl
        # skip
        # message( "      == skip" )
      else()
        string( REGEX MATCH "libhdf5" _l2 ${_l} )
        if( _l2 )
          # skip
          # message( "      == skip" )
        else()
          # message( "      == keep" )
          list( APPEND _netcdf_libs ${lib} )
        endif()
      endif()
    endforeach()
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${_netcdf_libs} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


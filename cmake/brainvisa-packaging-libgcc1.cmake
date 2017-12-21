find_package( LIBGCC ) 

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  if(GCC_VERSION)
    set( ${package_version} "${GCC_VERSION}" PARENT_SCOPE )
  else()
    set( ${package_version} "0.0.0" PARENT_SCOPE )
    if(NOT(CMAKE_CROSSCOMPILING AND WIN32))
      get_filename_component( real "${LIBGCC_LIBRARIES}" REALPATH )
      string( REGEX MATCH "^.*libgcc_s(_[a-zA-Z]+)?[-](.*)${CMAKE_SHARED_LIBRARY_SUFFIX}.*$" match "${real}" )
  
      if( match )
        set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
      endif()
    endif()    
  endif()
  
  if( WIN32 )
    # Add dependency to the threading library
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libwinpthread RUN )
  endif()
  
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(NOT APPLE) # packaged on linux and windows
    if(LIBGCC_FOUND)
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${LIBGCC_LIBRARIES} )
      set(${component}_PACKAGED TRUE PARENT_SCOPE)
    else()
      set(${component}_PACKAGED FALSE PARENT_SCOPE)
    endif()
  endif()
endfunction()

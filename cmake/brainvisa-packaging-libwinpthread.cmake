if( WIN32 )
  find_package( LibWinPthread REQUIRED) 
endif()

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  get_filename_component( real "${LIBWINPTHREAD_LIBRARIES}" REALPATH )
  
  if(LIBWINPTHREAD_VERSION)
    set( ${package_version} "${LIBWINPTHREAD_VERSION}" PARENT_SCOPE )
  else()
    string( REGEX MATCH "^.*libwinpthread[-](.*)${CMAKE_SHARED_LIBRARY_SUFFIX}.*$" match "${real}" )
    if( match )
      set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
    endif()
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(WIN32) # packaged only on windows
    if(LIBWINPTHREAD_FOUND)
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${LIBWINPTHREAD_LIBRARIES} )
      set(${component}_PACKAGED TRUE PARENT_SCOPE)
    else()
      set(${component}_PACKAGED FALSE PARENT_SCOPE)
    endif()
  endif()
endfunction()

find_package( OpenSSL ) 

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  if(OPENSSL_LIBRARIES)
    get_filename_component( real "${OPENSSL_LIBRARIES}" REALPATH )
    string( REGEX MATCH "^.*libssl${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
    if(match)
      set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
    endif()
  endif()
endfunction()

function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(NOT APPLE AND NOT WIN32 ) # packaged only on linux
    if( OPENSSL_FOUND)
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${OPENSSL_LIBRARIES} )
    else()
      MESSAGE( SEND_ERROR "Impossible to create packaging rules for ${component} : the package was not found." )
    endif()
  endif()
endfunction()

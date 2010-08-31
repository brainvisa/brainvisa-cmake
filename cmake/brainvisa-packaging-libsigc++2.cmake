find_package( Sigc++2 REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "no_version" PARENT_SCOPE )
  if( Sigc++2_VERSION )
    set(${package_version} ${Sigc++2_VERSION} PARENT_SCOPE )
  else()
    string( REGEX MATCH "^.*libsigc[-](.*)${CMAKE_SHARED_LIBRARY_SUFFIX}.*$" match "${Sigc++2_LIBRARIES}" )
    if( match )
      set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
    endif()
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${Sigc++2_LIBRARIES} )
endfunction()

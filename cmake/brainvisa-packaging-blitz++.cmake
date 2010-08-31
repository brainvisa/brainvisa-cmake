find_package( Blitz REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  if(BLITZ_VERSION)
    set(${package_version} ${BLITZ_VERSION} PARENT_SCOPE )
  else()
    set( ${package_version} "no_version" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${BLITZ_LIBRARIES} )
endfunction()


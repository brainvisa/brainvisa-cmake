find_package( EXPAT REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "0.0.0" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_install_RUNTIME_LIBRARIES( ${component} ${EXPAT_LIBRARIES} )
endfunction()


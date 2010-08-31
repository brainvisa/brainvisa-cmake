find_package( LibXml2 REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "no_version" PARENT_SCOPE )
  if(PC_LIBXML_VERSION)
    set(${package_version} ${PC_LIBXML_VERSION} PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${LIBXML2_LIBRARIES} )
endfunction()

find_package( LibXml2 REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO package_name package_maintainer package_version )
  set( ${package_name} brainvisa-libxml2 PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "no_version" PARENT_SCOPE )
  if(PC_LIBXML_VERSION)
    set(${package_version} ${PC_LIBXML_VERSION} PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_FIND_RUNTIME_LIBRARIES( libs ${LIBXML2_LIBRARIES} )
  BRAINVISA_INSTALL( FILES ${libs}
    DESTINATION "lib"
    COMPONENT "${component}" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  BRAINVISA_INSTALL_DIRECTORY( "${LIBXML2_INCLUDE_DIR}"
                              "include"
                              "${component}-devel" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEVDOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_SRC component )
endfunction()

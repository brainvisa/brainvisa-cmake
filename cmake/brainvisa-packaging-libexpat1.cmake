find_package( EXPAT REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO package_name package_maintainer package_version )
  set( ${package_name} brainvisa-expat1 PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "no_version" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_FIND_RUNTIME_LIBRARIES( libs ${EXPAT_LIBRARIES} )
  if(libs)
    BRAINVISA_INSTALL( FILES ${libs}
      DESTINATION "lib"
      COMPONENT "${component}" )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
# include dir is /usr/include, not possible to copy all the include directory
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEVDOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_SRC component )
endfunction()

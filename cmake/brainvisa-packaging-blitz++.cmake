find_package( Blitz REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO package_name package_maintainer package_version )
  set( ${package_name} brainvisa-blitz++ PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  if(BLITZ_VERSION)
    set(${package_version} ${BLITZ_VERSION} PARENT_SCOPE )
  else()
    set( ${package_version} "no_version" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_FIND_RUNTIME_LIBRARIES( libs ${BLITZ_LIBRARIES} )
  if(libs)
    BRAINVISA_INSTALL( FILES ${libs}
      DESTINATION "lib"
      COMPONENT "${component}" )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  BRAINVISA_INSTALL_DIRECTORY( "${BLITZ_INCLUDE_DIR}"
                              "include"
                              "${component}-devel" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEVDOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_SRC component )
endfunction()

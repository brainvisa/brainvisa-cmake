find_package( TIFF REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO package_name package_maintainer package_version )
  set( ${package_name} brainvisa-libtiff PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "no_version" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_FIND_RUNTIME_LIBRARIES( libs ${TIFF_LIBRARIES} )
  BRAINVISA_INSTALL( FILES ${libs}
    DESTINATION "lib"
    COMPONENT "${component}" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
#   not possible to install all the content of include_dir because it is /usr/include on linux
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEVDOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_SRC component )
endfunction()

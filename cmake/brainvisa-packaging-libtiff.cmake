find_package( TIFF REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} brainvisa-libtiff PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "no_version" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${TIFF_LIBRARIES} )
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

find_package( python REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO package_name package_maintainer package_version )
  set( ${package_name} brainvisa-python PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${PYTHON_VERSION}" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_INSTALL( FILES "${PYTHON_EXECUTABLE}"
    DESTINATION "bin"
    COMPONENT "${component}" )
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${PYTHON_LIBRARY} )
  # all python modules are copied in install directory but in theory, we should not copy site-packages subdirectory
  # the content of site-packages should be described in different packages.
  BRAINVISA_INSTALL_DIRECTORY( "${PYTHON_MODULES_PATH}" "lib/python${PYTHON_SHORT_VERSION}" "${component}" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  BRAINVISA_INSTALL_DIRECTORY( "${PYTHON_INCLUDE_PATH}"
                              "include"
                              "${component}-devel" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEVDOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_SRC component )
endfunction()

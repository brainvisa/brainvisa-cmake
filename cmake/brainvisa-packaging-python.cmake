find_package( python REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${PYTHON_VERSION}" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libreadline5 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libsqlite3-0 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libssl0.9.8 RUN )
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


find_package( PyQt4 )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  if (PYQT4_VERSION_STR)
    set( ${package_version} "${PYQT4_VERSION_STR}" PARENT_SCOPE )
  else()
    set( ${package_version} "0.0.0" PARENT_SCOPE )
  endif()
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS python-sip4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtgui4 RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  # nothing to package, it is already in python package
endfunction()


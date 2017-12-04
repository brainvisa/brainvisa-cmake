find_package( Numpy )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "1.0.0" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS python-numpy RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if( NUMPY_FOUND AND EXISTS "/usr/share/matplotlib" AND NOT(WIN32))
    BRAINVISA_INSTALL_DIRECTORY( "/usr/share/matplotlib" "lib/python${PYTHON_SHORT_VERSION}/dist-packages/matplotlib" ${component} )
    if( EXISTS "/etc/matplotlibrc" )
      BRAINVISA_INSTALL( FILES "/etc/matplotlibrc"
        DESTINATION "lib/python${PYTHON_SHORT_VERSION}/dist-packages/matplotlib/mpl-data"
        COMPONENT ${component}
        PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ )
    endif()
    # patch matplotlib.__init__ to search for the data path: done in python component.

    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


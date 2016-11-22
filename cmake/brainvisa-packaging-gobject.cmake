find_package( GObject )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} ${GOBJECT_VERSION} PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS glib RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(GOBJECT_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${GOBJECT_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


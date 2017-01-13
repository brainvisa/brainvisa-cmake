find_package( Glib )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} ${GLIB_VERSION} PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(GLIB_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${GLIB_LIBRARIES}
                                         ${GTHREAD_LIBRARIES}
                                         ${GMODULE_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


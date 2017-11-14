find_package( LibGettext )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  if(LIBGETTEXT_VERSION)
    # Find version
    set( ${package_version} ${LIBGETTEXT_VERSION} PARENT_SCOPE )
  else()
    set( ${package_version} "0.0.0" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(LIBGETTEXT_FOUND AND LIBGETTEXT_LIBINTL)
    
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES(${component} 
                                        ${LIBGETTEXT_LIBINTL})
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

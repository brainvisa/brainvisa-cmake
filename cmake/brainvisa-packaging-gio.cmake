find_package( Gio )

function(BRAINVISA_PACKAGING_COMPONENT_INFO
         component
         package_name
         package_maintainer
         package_version)
  set(${package_name} ${component} PARENT_SCOPE)
  set(${package_maintainer} "IFR 49" PARENT_SCOPE)
  # Find version
  set(${package_version} ${GIO_VERSION} PARENT_SCOPE)
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS glib RUN )
  if(WIN32)
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS gobject RUN )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libintl RUN )
  endif()
endfunction()

function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(GIO_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component}
                                         ${GIO_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


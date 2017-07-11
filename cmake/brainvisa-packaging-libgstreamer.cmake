find_package( GStreamer )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} ${GSTREAMER_VERSION} PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS glib RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libxml2 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libffi RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(GSTREAMER_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${GSTREAMER_LIBRARIES}
                                         ${GSTAPP_LIBRARIES}
                                         ${GSTBASE_LIBRARIES}
                                         ${GSTINTERFACES_LIBRARIES}
                                         ${GSTPBUTILS_LIBRARIES}
                                         ${GSTVIDEO_LIBRARIES}
                                         ${GSTAUDIO_LIBRARIES}
                                         ${GSTTAG_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


# find_package( LibXkbCommon-X11 )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "1.0.0" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libxcb RUN )

  file( GLOB LIBXKB_LIBRARIES
        /usr/lib/x86_64-linux-gnu/libxkbcommon-x11.so.?
        /usr/lib64/libxkbcommon-x11.so.?
        /usr/lib/libxkbcommon-x11.so.?
        /usr/lib/x86_64-linux-gnu/libxkbcommon.so.?
        /usr/lib64/libxkbcommon.so.?
        /usr/lib/libxkbcommon.so.?
      )
  if(LIBXKB_LIBRARIES)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${LIBXKB_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


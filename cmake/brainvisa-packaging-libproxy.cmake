# find_package( LibProxy )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "1.0.0" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  file( GLOB LIBPROXY_LIBRARIES
        /usr/lib/x86_64-linux-gnu/libproxy.so.?
        /usr/lib/libproxy.so.?
      )
  if(LIBPROXY_LIBRARIES)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${LIBPROXY_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


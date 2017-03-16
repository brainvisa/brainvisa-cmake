# find_package( LibPcre )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "1.0.0" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  file( GLOB LIBPCRE_LIBRARIES /lib/libpcre.so.?
        /lib/x86_64-linux-gnu/libpcre.so.? )
  if(LIBPCRE_LIBRARIES)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${LIBPCRE_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


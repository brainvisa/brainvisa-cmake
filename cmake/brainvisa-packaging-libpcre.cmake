# find_package( LibPcre )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "1.0.0" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  file( GLOB LIBPCRE_LIBRARIES
        /usr/lib/x86_64-linux-gnu/libpcre.so.?
        /lib/libpcre.so.?
        /lib/x86_64-linux-gnu/libpcre.so.?
        /usr/lib/x86_64-linux-gnu/libpcre16.so.?
        /lib/libpcre16.so.?
        /lib/x86_64-linux-gnu/libpcre16.so.?
        /usr/lib/x86_64-linux-gnu/libpcre32.so.?
        /lib/libpcre32.so.?
        /lib/x86_64-linux-gnu/libpcre32.so.?
      )
  if(LIBPCRE_LIBRARIES)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component}
      ${LIBPCRE_LIBRARIES} ${LIBPCRE16_LIBRARIES} ${LIBPCRE32_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


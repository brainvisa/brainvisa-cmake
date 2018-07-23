find_library( LIBWRAP wrap )
if( NOT LIBWRAP )
  # find libwrap.so.?
  file( GLOB LIBWRAP /usr/lib/x86_64-linux-gnu/pulseaudio/libwrap.so.? )
  if( LIBWRAP )
    set( LIBWRAP "${LIBWRAP}" CACHE STRING "libwrap library" FORCE )
  endif()
endif()

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  get_filename_component( real "${LIBWRAP}" REALPATH )
  string( REGEX MATCH "^.*libwrap${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
  if( match )
    set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if( LIBWRAP )
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} "${LIBWRAP}" )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

find_library( LIBJSON_C json-c )
if( NOT LIBJSON_C )
  # find libjson-c.so.?
  file( GLOB LIBJSON_C /lib/x86_64-linux-gnu/libjson-c.so.? )
  if( LIBJSON_C )
    set( LIBJSON_C "${LIBJSON_C}" CACHE STRING "libjson-c library" FORCE )
  endif()
endif()

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  get_filename_component( real "${LIBJSON_C}" REALPATH )
  string( REGEX MATCH "^.*libjson-c${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
  if( match )
    set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if( LIBJSON_C )
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} "${LIBJSON_C}" )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

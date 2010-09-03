find_library( LIBREADLINE5 readline )
if( NOT LIBREADLINE5 )
  # On Ubuntu 10.4 libreadline is in /lib/libreadline.so.* and CMake cannot find it
  # because there is no /lib/libreadline.so
  file( GLOB LIBREADLINE5 /lib/libreadline.so.5 )
  if( LIBREADLINE5 )
    set( LIBREADLINE5 "${LIBREADLINE5}" CACHE STRING "libreadline library" FORCE )
  endif()
endif()

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  get_filename_component( real "${LIBREADLINE5}" REALPATH )
  string( REGEX MATCH "^.*libreadline${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
  if( match )
    set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if( LIBREADLINE5 )
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} "${LIBREADLINE5}" )
  else()
    message( SEND_ERROR "Impossible to create packaging rules for ${component} : the library was not found." )
  endif()
endfunction()

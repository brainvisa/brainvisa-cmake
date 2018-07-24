find_library( LIBSNDFILE sndfile )
if( NOT LIBSNDFILE )
  # find libsndfile.so.?
  file( GLOB LIBSNDFILE /usr/lib/x86_64-linux-gnu/libsndfile.so.? )
  if( LIBSNDFILE )
    set( LIBSNDFILE "${LIBSNDFILE}" CACHE STRING "libsndfile library" FORCE )
  endif()
endif()

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  get_filename_component( real "${LIBSNDFILE}" REALPATH )
  string( REGEX MATCH "^.*libsndfile${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
  if( match )
    set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libvorbisenc RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libFLAC RUN )
  if( LIBSNDFILE )
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} "${LIBSNDFILE}" )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()
find_library( LIBPULSECOMMON pulsecommon )
if( NOT LIBPULSECOMMON )
  # find libpulsecommon.so.?
  file( GLOB LIBPULSECOMMON /usr/lib/x86_64-linux-gnu/pulseaudio/libpulsecommon-?.?.so )
  if( LIBPULSECOMMON )
    set( LIBPULSECOMMON "${LIBPULSECOMMON}" CACHE STRING "libpulsecommon library" FORCE )
  endif()
endif()

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  get_filename_component( real "${LIBPULSECOMMON}" REALPATH )
  string( REGEX MATCH "^.*libpulsecommon${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
  if( match )
    set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libsndfile RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libjson-c RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libasyncns RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libwrap RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libasyncns RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS liblzma RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libpcre RUN )
  if( LIBPULSECOMMON )
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} "${LIBPULSECOMMON}" )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

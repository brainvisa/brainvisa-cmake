find_library( LIBNCURSES5 ncurses )
if( NOT LIBNCURSES5 )
  # On Ubuntu 10.4 libncurses is in /lib/libncurses.so.* and CMake cannot find it
  # because there is no /lib/libncurses.so
  file( GLOB LIBNCURSES5 /lib/libncurses.so.5 )
  if( LIBNCURSES5 )
    set( LIBNCURSES5 "${LIBNCURSES5}" CACHE STRING "libncurses library" FORCE )
  endif()
endif()

find_library( LIBNCURSESW5 ncursesw )
if( NOT LIBNCURSESW5 )
  # On Ubuntu 10.4 libncursesw is in /lib/libncursesw.so.* and CMake cannot find it
  # because there is no /lib/libncursesw.so
  file( GLOB LIBNCURSESW5 /lib/libncursesw.so.5 )
  if( LIBNCURSESW5 )
    set( LIBNCURSESW5 "${LIBNCURSESW5}" CACHE STRING "libncursesw library" FORCE )
  endif()
endif()

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  get_filename_component( real "${LIBNCURSES5}" REALPATH )
  string( REGEX MATCH "^.*libncurses${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
  if( match )
    set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if( LIBNCURSES5 )
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} "${LIBNCURSES5}" )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
  if( LIBNCURSESW5 )
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} "${LIBNCURSESW5}" )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  endif()
endfunction()

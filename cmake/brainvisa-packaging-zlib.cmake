find_package( ZLIB )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  if( EXISTS "${ZLIB_INCLUDE_DIR}/zlib.h" )
    file( READ "${ZLIB_INCLUDE_DIR}/zlib.h" header )
    string( REGEX MATCH "#define[ \\t]*ZLIB_VERSION[ \\t]*\"([^\"]*)\"" match "${header}" )
    if( match )
      set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
    endif()
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(WIN32)
    if (ZLIB_FOUND)
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${ZLIB_LIBRARIES} )
      set(${component}_PACKAGED TRUE PARENT_SCOPE)
    else()
      set(${component}_PACKAGED FALSE PARENT_SCOPE)
    endif()
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( zlib-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if (ZLIB_FOUND)
    BRAINVISA_INSTALL( FILES "${ZLIB_INCLUDE_DIR}/zlib.h"
      "${ZLIB_INCLUDE_DIR}/zconf.h"
      "${ZLIB_INCLUDE_DIR}/zlibdefs.h"
      DESTINATION include
      COMPONENT ${component}-dev )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


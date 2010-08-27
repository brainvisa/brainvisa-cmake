find_package( ZLIB REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} brainvisa-${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "no_version" PARENT_SCOPE )
  if( EXISTS "${ZLIB_INCLUDE_DIR}/zlib.h" )
    file( READ "${ZLIB_INCLUDE_DIR}/zlib.h" header )
    string( REGEX MATCH "#define[ \\t]*ZLIB_VERSION[ \\t]*\"([^\"]*)\"" match "${header}" )
    if( match )
      set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
    endif()
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${ZLIB_LIBRARIES} )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEVDOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_SRC component )
endfunction()

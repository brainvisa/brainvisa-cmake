find_package( MINC )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  if( EXISTS "${MINC_INCLUDE_DIR}/minc.h" )
    file( READ "${MINC_INCLUDE_DIR}/minc.h" header )
    string( REGEX MATCH "#define[ \\t]*MI_VERSION[0-9_]*[ \\t]*\"MINC Version[ \\t]*([^\"]*)\"" match "${header}" )
    if( match )
      set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
    endif()
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(MINC_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${MINC_LIBRARIES} )
  else()
    MESSAGE( SEND_ERROR "Impossible to create packaging rules for ${component} : the package was not found." )
  endif()
endfunction()

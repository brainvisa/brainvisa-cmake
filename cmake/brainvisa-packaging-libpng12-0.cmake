find_package(PNG12 REQUIRED)

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "no_version" PARENT_SCOPE )
  if(PNG12_VERSION)
    set( ${package_version} "${PNG12_VERSION}" PARENT_SCOPE )
  else(PNG12_VERSION)
    if( EXISTS "${PNG12_INCLUDE_DIR}/png.h" )
      file( READ "${PNG12_INCLUDE_DIR}/png.h" header )
      string( REGEX MATCH "#define[ \\t]*PNG_LIBPNG_VER_STRING[ \\t]*\"([^\"]*)\"" match "${header}" )
      if( match )
        set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
      endif( match )
    endif()
  endif(PNG12_VERSION)
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${PNG12_LIBRARIES} )
endfunction()

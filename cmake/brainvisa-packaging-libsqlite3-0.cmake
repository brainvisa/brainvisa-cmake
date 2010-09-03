find_package( Sqlite3 ) 

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  if(SQLITE3_VERSION)
    set(${package_version} ${SQLITE3_VERSION} PARENT_SCOPE)
  else()
    set( ${package_version} "0.0.0" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if( SQLITE3_FOUND )
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${SQLITE3_LIBRARIES} )
  endif()
endfunction()

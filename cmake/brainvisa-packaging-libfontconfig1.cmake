find_package( FontConfig )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  if( FontConfig_VERSION )
    set(${package_version} ${FontConfig_VERSION} PARENT_SCOPE )
  else()
    set( ${package_version} "0.0.0" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(FontConfig_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${FontConfig_LIBRARIES} )
  else()
    MESSAGE( SEND_ERROR "Impossible to create packaging rules for ${component} : the package was not found." )
  endif()
endfunction()

if( WIN32 )
  find_package( MSVCR90 REQUIRED ) 
endif()

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "9.0.0" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(WIN32) # packaged on windows
    if(MSVCR90_FOUND)
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${MSVCR90_LIBRARIES} )
      set(${component}_PACKAGED TRUE PARENT_SCOPE)
    else()
      set(${component}_PACKAGED FALSE PARENT_SCOPE)
    endif()
  endif()
endfunction()

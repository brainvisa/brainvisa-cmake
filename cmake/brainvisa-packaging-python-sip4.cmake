find_package( SIP )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  if (SIP_VERSION)
    set( ${package_version} "${SIP_VERSION}" PARENT_SCOPE )
  else()
    set( ${package_version} "0.0.0" PARENT_SCOPE )
  endif()
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS python RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libgcc1 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libstdc++6 RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if( WIN32 )
    if(SIP_FOUND)
      BRAINVISA_INSTALL( FILES ${SIP_EXECUTABLE}
                         DESTINATION "bin"
                         COMPONENT "${component}"
                         PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )
                         
      set(${component}_PACKAGED TRUE PARENT_SCOPE)
    else()
      set(${component}_PACKAGED FALSE PARENT_SCOPE)
    endif()
  endif()
endfunction()


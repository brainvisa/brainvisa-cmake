find_package( Dot )

function( BRAINVISA_PACKAGING_COMPONENT_INFO cmake package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  if( DOT_VERSION )
    set( ${package_version} "${DOT_VERSION}" PARENT_SCOPE )
  else()
    set( ${package_version} "0.0.0" PARENT_SCOPE )
  endif()
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libcairo2 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libexpat1 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libfontconfig1 RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if( DOT_EXECUTABLE )
    BRAINVISA_INSTALL( FILES "${DOT_EXECUTABLE}"
      DESTINATION "bin"
      COMPONENT "${component}"
      PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )
  endif()
  if( DOT_LIBRARIES )
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${DOT_LIBRARIES} )
  endif()
  # Plugins
  foreach(lib ${DOT_LIBRARIES})
    get_filename_component(libdir ${lib} PATH)
    if( EXISTS "${libdir}/graphviz" )
      BRAINVISA_INSTALL( DIRECTORY "${libdir}/graphviz"
                         DESTINATION "lib"
                         USE_SOURCE_PERMISSIONS
                         COMPONENT "${component}" )
      break()
    endif()
  endforeach()
endfunction()


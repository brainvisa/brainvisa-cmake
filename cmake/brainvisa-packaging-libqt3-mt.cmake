find_package( Qt3 )
find_package( QtVersion )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION}" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(QT_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${QT_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

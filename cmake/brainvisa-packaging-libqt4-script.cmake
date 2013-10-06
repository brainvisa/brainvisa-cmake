find_package( Qt4 COMPONENTS QtScript )

function( BRAINVISA_PACKAGING_COMPONENT_INFO cmake package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtcore4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libgcc1 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libstdc++6 RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(QT_QTSCRIPT_FOUND)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND QT_QTSCRIPT_LIBRARY_DEBUG)
      set(libs ${QT_QTSCRIPT_LIBRARY_DEBUG})
    else()
      set(libs ${QT_QTSCRIPT_LIBRARY_RELEASE})
    endif()
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
    # install plugins
    if( EXISTS "${QT_PLUGINS_DIR}/script" )
      BRAINVISA_INSTALL( DIRECTORY "${QT_PLUGINS_DIR}/script"
                      DESTINATION "lib/qt-plugins"
                      USE_SOURCE_PERMISSIONS
                      COMPONENT "${component}" )
    endif()
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


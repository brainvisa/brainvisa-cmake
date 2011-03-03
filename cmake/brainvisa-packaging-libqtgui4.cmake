find_package( Qt4 COMPONENTS QtGui )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )

  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtcore4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libpng12-0 RUN )
endfunction()

function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(QT_QTGUI_FOUND)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND QT_QTGUI_LIBRARY_DEBUG)
      set(libs ${QT_QTGUI_LIBRARY_DEBUG})
    else()
      set(libs ${QT_QTGUI_LIBRARY_RELEASE})
    endif()
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
    # install plugins
    FILE(GLOB plugin "${QT_PLUGINS_DIR}/accessible/*qtaccessiblewidgets*")
    if( plugin )
      BRAINVISA_INSTALL( FILES ${plugin}
                        DESTINATION "lib/qt-plugins/accessible"
                        COMPONENT "${component}" )
    endif()
    if( EXISTS "${QT_PLUGINS_DIR}/imageformats" )
      BRAINVISA_INSTALL( DIRECTORY "${QT_PLUGINS_DIR}/imageformats"
                        DESTINATION "lib/qt-plugins"
                        USE_SOURCE_PERMISSIONS
                        COMPONENT "${component}" )
    endif()
    if( EXISTS "${QT_PLUGINS_DIR}/inputmethods" )
      BRAINVISA_INSTALL( DIRECTORY "${QT_PLUGINS_DIR}/inputmethods"
                        DESTINATION "lib/qt-plugins"
                        USE_SOURCE_PERMISSIONS
                        COMPONENT "${component}" )
    endif()
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

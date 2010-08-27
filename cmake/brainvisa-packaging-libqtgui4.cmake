find_package( Qt4 COMPONENTS QtGui REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} brainvisa-libqtgui4 PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )

  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtcore4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV DEPENDS libqtcore4 DEV )
  
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libfontconfig1 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV DEPENDS libfontconfig1 DEV )
  
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libpng12-0 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV DEPENDS libpng12-0 DEV )
endfunction()

function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(libs ${QT_QTGUI_LIBRARY_DEBUG})
  else()
    set(libs ${QT_QTGUI_LIBRARY_RELEASE})
  endif()
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
  # install plugins
  FILE(GLOB plugin "${QT_PLUGINS_DIR}/accessible/*qtaccessiblewidgets*")
  BRAINVISA_INSTALL( FILES ${plugin}
                     DESTINATION "lib/qt-plugins/accessible"
                     COMPONENT "${component}" )
  BRAINVISA_INSTALL_DIRECTORY( "${QT_PLUGINS_DIR}/imageformats"
                          "lib/qt-plugins/imageformats"
                          "${component}" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  BRAINVISA_INSTALL_DIRECTORY( "${QT_QTGUI_INCLUDE_DIR}"
                              "include/QtGui"
                              "${component}-devel" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEVDOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_SRC component )
endfunction()

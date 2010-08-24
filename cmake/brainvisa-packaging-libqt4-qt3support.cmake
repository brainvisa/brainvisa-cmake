find_package( Qt4 COMPONENTS Qt3Support REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO cmake package_name package_maintainer package_version )
  set( ${package_name} brainvisa-libqt4-qt3support PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )
endfunction()

function( BRAINVISA_PACKAGING_DEPENDENCIES component )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN libqt4-designer RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV libqt4-designer DEV )
  
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN libqt4-network RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV libqt4-network DEV )
  
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN libqt4-sql RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV libqt4-sql DEV )
 
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN libqt4-xml RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV libqt4-xml DEV )
  
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN libqtcore4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV libqtcore4 DEV )
  
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN libqtgui4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" DEV libqtgui4 DEV )

endfunction()

function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(libs ${QT_QT3SUPPORT_LIBRARY_DEBUG})
  else()
    set(libs ${QT_QT3SUPPORT_LIBRARY_RELEASE})
  endif()
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
  # install plugins
  FILE(GLOB plugin "${QT_PLUGINS_DIR}/accessible/*qtaccessiblecompatwidgets*")
  BRAINVISA_INSTALL( FILES ${plugin}
    DESTINATION "lib/qt-plugins/accessible"
    COMPONENT "${component}" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  BRAINVISA_INSTALL_DIRECTORY( "${QT_QT3SUPPORT_INCLUDE_DIR}"
                              "include/Qt3Support"
                              "${component}-devel" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEVDOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_SRC component )
endfunction()

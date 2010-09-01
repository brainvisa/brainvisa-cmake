find_package( Qt4 COMPONENTS QtDesigner REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO cmake package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqt4-script RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqt4-xml RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtcore4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtgui4 RUN )

endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND QT_QTDESIGNER_LIBRARY_DEBUG)
    set(libs ${QT_QTDESIGNER_LIBRARY_DEBUG})
  else()
    set(libs ${QT_QTDESIGNER_LIBRARY_RELEASE})
  endif()
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
endfunction()


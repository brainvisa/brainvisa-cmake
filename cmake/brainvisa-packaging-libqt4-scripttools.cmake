find_package( Qt4 COMPONENTS QtScriptTools )

function( BRAINVISA_PACKAGING_COMPONENT_INFO cmake package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtcore4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtgui4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqt4-script RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(WIN32 AND QT_QTSCRIPTTOOLS_FOUND)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND QT_QTSCRIPTTOOLS_LIBRARY_DEBUG)
      set(libs ${QT_QTSCRIPTTOOLS_LIBRARY_DEBUG})
    else()
      set(libs ${QT_QTSCRIPTTOOLS_LIBRARY_RELEASE})
    endif()
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

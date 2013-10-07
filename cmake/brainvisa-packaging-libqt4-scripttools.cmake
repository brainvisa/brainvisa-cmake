find_package( Qt4 COMPONENTS QtScriptTools )

# Try to find QtScriptTools on buggy distribs (Mandriva 2008)
# TODO: Remove this hack when cmake detects correctly the module
if (NOT QT_QTSCRIPTTOOLS_FOUND AND ${QTVERSION} VERSION_GREATER 4.5.0 )
  find_path(QT_QTSCRIPTTOOLS_INCLUDE_DIR QtScriptTools
          PATHS ${QT_HEADERS_DIR}/QtScriptTools
              ${QT_LIBRARY_DIR}/QtScriptTools.framework/Headers
          NO_DEFAULT_PATH)
  find_library(QT_QTSCRIPTTOOLS_LIBRARY QtScriptTools PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
  if (QT_QTSCRIPTTOOLS_INCLUDE_DIR AND QT_QTSCRIPTTOOLS_LIBRARY)
    set(QT_QTSCRIPTTOOLS_FOUND ON)
    set(QT_QTSCRIPTTOOLS_LIBRARY_RELEASE ${QT_QTSCRIPTTOOLS_LIBRARY} CACHE FILEPATH "Qt ScriptTools library")
  else()
    #Replace this on documentation
    set(if_QtScriptTools "<!--")
    set(end_QtScriptTools "-->")
  endif()
endif ()

function( BRAINVISA_PACKAGING_COMPONENT_INFO cmake package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtcore4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtgui4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqt4-script RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libgcc1 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libstdc++6 RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(QT_QTSCRIPTTOOLS_FOUND)
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


find_package( Qt4 COMPONENTS QtSql )

function( BRAINVISA_PACKAGING_COMPONENT_INFO cmake package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtcore4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libgcc1 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libstdc++6 RUN )
  if(EXISTS "${QT_PLUGINS_DIR}/sqldrivers")
    if(WIN32)
      # SQL driver plugin is linked with libsqlite3.0 on Windows
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libsqlite3-0 RUN )
    endif()
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(QT_QTSQL_FOUND)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND QT_QTSQL_LIBRARY_DEBUG) 
      set(libs ${QT_QTSQL_LIBRARY_DEBUG})
    else()
      set(libs ${QT_QTSQL_LIBRARY_RELEASE})
    endif()
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
    if(EXISTS "${QT_PLUGINS_DIR}/sqldrivers")
      BRAINVISA_INSTALL( DIRECTORY "${QT_PLUGINS_DIR}/sqldrivers"
                      DESTINATION "lib/qt-plugins"
                      USE_SOURCE_PERMISSIONS
                      COMPONENT "${component}" )
    endif()
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( libqt4-sql-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(QT_QTSQL_FOUND)
    BRAINVISA_INSTALL_DIRECTORY( "${QT_QTSQL_INCLUDE_DIR}" include/qt4/QtSql
      ${component}-dev )
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

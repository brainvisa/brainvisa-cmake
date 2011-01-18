find_package( Qt4 COMPONENTS QtSql )

function( BRAINVISA_PACKAGING_COMPONENT_INFO cmake package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtcore4 RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND QT_QTSQL_LIBRARY_DEBUG) 
    set(libs ${QT_QTSQL_LIBRARY_DEBUG})
  else()
    set(libs ${QT_QTSQL_LIBRARY_RELEASE})
  endif()
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
  BRAINVISA_INSTALL_DIRECTORY( "${QT_PLUGINS_DIR}/sqldrivers"
                          "lib/qt-plugins/sqldrivers"
                          "${component}" )

endfunction()


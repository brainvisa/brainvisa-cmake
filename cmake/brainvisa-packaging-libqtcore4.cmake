find_package( Qt4 COMPONENTS QtCore )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libstdc++6 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libgcc1 RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND QT_QTCORE_LIBRARY_DEBUG)
    set(libs ${QT_QTCORE_LIBRARY_DEBUG})
  else()
    set(libs ${QT_QTCORE_LIBRARY_RELEASE})
  endif()
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
  # install plugins
  BRAINVISA_INSTALL_DIRECTORY( "${QT_PLUGINS_DIR}/codecs"
                          "lib/qt-plugins/codecs"
                          "${component}" )
  # qtconfig
  BRAINVISA_INSTALL( FILES "${QT_BINARY_DIR}/qtconfig"
    DESTINATION "bin"
    COMPONENT "${component}"
    PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )
    
  # create qt.conf to enable finding qt plugins
  if(QT_VERSION_MAJOR GREATER 4 OR QT_VERSION_MAJOR EQUAL 4)
    set(dest "bin")
    if(WIN32)
      set( dest "lib/python" )
    endif()
    set(content "[Paths]\nPrefix = ../..\nPlugins = lib/qt-plugins\n")
    if(APPLE)
      set(content "[Paths]\nPrefix = ../../../..\nPlugins = lib/qt-plugins\n")
    endif()
    BRAINVISA_INSTALL(CODE "file(WRITE \"\${CMAKE_INSTALL_PREFIX}/${dest}/qt.conf\" \"${content}\")"
      COMPONENT "${component}")
  endif()
endfunction()

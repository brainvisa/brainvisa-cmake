find_package( Qt4 COMPONENTS QtCore REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO package_name package_maintainer package_version )
  set( ${package_name} brainvisa-libqtcore4 PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )
endfunction()

# function that defines the dependencies of this package that need to be packaged
function( BRAINVISA_PACKAGING_DEPENDENCIES component )
  if( UNIX )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN libstdc++6 RUN )
  endif()
  
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN libgcc1 RUN )
endfunction()

function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(libs ${QT_QTCORE_LIBRARY_DEBUG})
  else()
    set(libs ${QT_QTCORE_LIBRARY_RELEASE})
  endif()
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
  # install plugins
  BRAINVISA_INSTALL_DIRECTORY( "${QT_PLUGINS_DIR}/codecs"
                          "lib/qt-plugins/codecs"
                          "${component}" )

endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  BRAINVISA_INSTALL_DIRECTORY( "${QT_QTCORE_INCLUDE_DIR}"
                              "include/QtCore"
                              "${component}-devel" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEVDOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_SRC component )
endfunction()

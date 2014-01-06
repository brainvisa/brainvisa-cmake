find_package( Qt4 COMPONENTS QtOpenGL )

function( BRAINVISA_PACKAGING_COMPONENT_INFO cmake package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtcore4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtgui4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libgcc1 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libstdc++6 RUN )
  # weak dependency on mesa as an alternative when opengl 3D rendering doesn't work
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libgl1-mesa-swx11 RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(QT_QTOPENGL_FOUND)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND QT_QTOPENGL_LIBRARY_DEBUG)
      set(libs ${QT_QTOPENGL_LIBRARY_DEBUG})
    else()
      set(libs ${QT_QTOPENGL_LIBRARY_RELEASE})
    endif()
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
    if(EXISTS "${QT_PLUGINS_DIR}/graphicssystems")
      BRAINVISA_INSTALL( DIRECTORY "${QT_PLUGINS_DIR}/graphicssystems"
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
set( libqt4-opengl-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(QT_QTOPENGL_FOUND)
    BRAINVISA_INSTALL_DIRECTORY( "${QT_QTOPENGL_INCLUDE_DIR}" include/qt4/QtOpenGL
      ${component}-dev )
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

find_package( Qt4 COMPONENTS QtMultimedia )

# found on http://qt.gitorious.org/pyside/setantas-pyside-shiboken/blobs/3c7f55855b45168818ef6fc5e58b30f1c7e4d133/cmake/Macros/FindQt4Extra.cmake
# Try to find QtMultimedia
# TODO: Remove this hack when cmake support QtMultimedia module
if (NOT QT_QTMULTIMEDIA_FOUND AND ${QTVERSION} VERSION_GREATER 4.5.9)
  find_path(QT_QTMULTIMEDIA_INCLUDE_DIR QtMultimedia
          PATHS ${QT_HEADERS_DIR}/QtMultimedia
              ${QT_LIBRARY_DIR}/QtMultimedia.framework/Headers
          NO_DEFAULT_PATH)
  find_library(QT_QTMULTIMEDIA_LIBRARY QtMultimedia PATHS ${QT_LIBRARY_DIR} NO_DEFAULT_PATH)
  if (QT_QTMULTIMEDIA_INCLUDE_DIR AND QT_QTMULTIMEDIA_LIBRARY)
    set(QT_QTMULTIMEDIA_FOUND ON)
  else()
    #Replace this on documentation
    set(if_QtMultimedia "<!--")
    set(end_QtMultimedia "-->")
  endif()
endif ()

function( BRAINVISA_PACKAGING_COMPONENT_INFO cmake package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtcore4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqtgui4 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libgcc1 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libstdc++6 RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(QT_QTMULTIMEDIA_FOUND)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND QT_QTMULTIMEDIA_LIBRARY_DEBUG)
      set(libs ${QT_QTMULTIMEDIA_LIBRARY_DEBUG})
    else()
      # set(libs ${QT_QTMULTIMEDIA_LIBRARY_RELEASE})
      set(libs ${QT_QTMULTIMEDIA_LIBRARY})
    endif()
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( libqt4-multimedia-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(QT_QTMULTIMEDIA_FOUND)
    BRAINVISA_INSTALL_DIRECTORY( "${QT_QTMULTIMEDIA_INCLUDE_DIR}" include/qt4/QtMultimedia
      ${component}-dev )
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

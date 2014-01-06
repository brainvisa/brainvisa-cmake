find_package( Qt4 COMPONENTS phonon )

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
  if(QT_PHONON_FOUND)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND QT_PHONON_LIBRARY_DEBUG)
      set(libs ${QT_PHONON_LIBRARY_DEBUG})
    else()
      set(libs ${QT_PHONON_LIBRARY_RELEASE})
    endif()
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( libqt4-phonon-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(QT_PHONON_FOUND)
    BRAINVISA_INSTALL_DIRECTORY( "${QT_PHONON_INCLUDE_DIR}" include/qt4/phonon
      ${component}-dev )
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

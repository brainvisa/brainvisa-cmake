find_package( Qt5Gui )
find_package( LibAudio )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION}" PARENT_SCOPE )

  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqt5core RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libpng12 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libgcc1 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libstdc++6 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libxcb RUN )
  if( LIBAUDIO_FOUND AND NOT(CMAKE_CROSSCOMPILING AND WIN32))
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libaudio RUN )
  endif()
  # TODO: add deps: libgraphite2, libGL, libfreetype
  find_package( GObject QUIET )
  if( GOBJECT_FOUND )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS gobject RUN )
  endif()
  if( LSB_DISTRIB STREQUAL "ubuntu"
      AND LSB_DISTRIB_RELEASE VERSION_GREATER "16.04" )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libfreetype6 RUN )
  endif()
  if( LSB_DISTRIB STREQUAL "ubuntu"
      AND LSB_DISTRIB_RELEASE VERSION_GREATER "18.0" )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS zlib RUN )
    # it's png16 actually
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libpng12 RUN )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libharfbuzz RUN )
  endif()
endfunction()

function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(Qt5Gui_FOUND)
    set( libs )
    foreach( _lib ${Qt5Gui_LIBRARIES})
      # get lib file
      get_target_property( _lib_loc ${_lib} LOCATION )
      # get the .so without version number
      string( REGEX REPLACE "^(.*${CMAKE_SHARED_LIBRARY_SUFFIX})(\\..*)?$"
              "\\1" _lib_loc ${_lib_loc} )
      list( APPEND libs ${_lib_loc} )
    endforeach()
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${libs} )
    # install plugins
    set( _plugins_dir )
    foreach( plugin ${Qt5Gui_PLUGINS} )
      get_target_property( _loc ${plugin} LOCATION )
      # message( "Plugin ${plugin} is at location ${_loc}" )
      set( _plugins ${_plugins} ${_loc} )
      get_filename_component( _dir ${_loc} PATH )
      get_filename_component( _dir ${_dir} NAME )
      list( APPEND _plugins_${_dir} ${_loc} )
      list( APPEND _plugins_dir ${_dir} )
    endforeach()
    if( _plugins_dir )
      list( REMOVE_DUPLICATES _plugins_dir )
      foreach( _dir ${_plugins_dir} )
        BRAINVISA_INSTALL( FILES ${_plugins_${dir}}
                           DESTINATION "lib/qt-plugins/${_dir}"
                           COMPONENT "${component}" )
      endforeach()
    else()
      # Qt5Gui_PLUGINS is empty
      get_filename_component( _dir ${libs} PATH )
      set( _plugins_dir "${_dir}/qt5/plugins" )
      if( EXISTS ${_plugins_dir} )
        if( EXISTS "${_plugins_dir}/imageformats" )
          BRAINVISA_INSTALL( DIRECTORY "${_plugins_dir}/imageformats"
                             DESTINATION "lib/qt5/plugins"
                             USE_SOURCE_PERMISSIONS
                             COMPONENT "${component}" )
        endif()
      endif()
    endif()
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( libqt5gui-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(Qt5Gui_FOUND)
    foreach( _include ${Qt5Gui_INCLUDE_DIRS} )
      get_filename_component( _name ${_include} NAME )
      if( _name STREQUAL "QtGui" )
        BRAINVISA_INSTALL_DIRECTORY( "${_include}" include/qt5/${_name}
          ${component}-dev )
      endif()
    endforeach()
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

find_package( Qt5WebKit )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )

  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqt5network RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libsqlite3-0 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libxslt RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libxml2 RUN )
  # this dependency is only present on ubuntu >= 18.04
  if( LSB_DISTRIB STREQUAL "ubuntu"
      AND LSB_DISTRIB_RELEASE VERSION_EQUAL "16.04" )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqt5opengl RUN )
  endif()
  if( LSB_DISTRIB STREQUAL "ubuntu"
      AND LSB_DISTRIB_RELEASE VERSION_GREATER "16.0" )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libgstreamer RUN )
  endif()
  if( LSB_DISTRIB STREQUAL "ubuntu"
      AND LSB_DISTRIB_RELEASE VERSION_GREATER "18.0" )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqt5quick RUN )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqt5webchannel RUN )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqt5positioning RUN )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libqt5sensors RUN )
  endif()
  # TODO
  # ub18: libwoff2dec.so.1.0.2 libwebp.so.6 libhyphen.so.0
endfunction()

function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(Qt5WebKit_FOUND)
    set( libs )
    foreach( _lib ${Qt5WebKit_LIBRARIES})
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
    foreach( plugin ${Qt5WebKit_PLUGINS} )
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
                           DESTINATION "lib/qt5/plugins/${_dir}"
                           COMPONENT "${component}" )
      endforeach()
    endif()
    # libexec dir
    get_filename_component( _dir ${libs} PATH )
    set( _libexec_dir "${_dir}/qt5/libexec" )
    if( EXISTS ${_libexec_dir} )
      BRAINVISA_INSTALL( DIRECTORY "${_libexec_dir}"
                         DESTINATION "lib/qt5"
                         USE_SOURCE_PERMISSIONS
                         COMPONENT "${component}" )
    endif()
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( libqt5webkit-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(Qt5WebKit_FOUND)
    foreach( _include ${Qt5WebKit_INCLUDE_DIRS} )
      get_filename_component( _name ${_include} NAME )
      if( _name STREQUAL "QtWebKit" )
        BRAINVISA_INSTALL_DIRECTORY( "${_include}" include/qt5/${_name}
          ${component}-dev )
      endif()
    endforeach()
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

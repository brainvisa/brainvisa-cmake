find_package( Qt5Core )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION}" PARENT_SCOPE )

  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libstdc++6 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libgcc1 RUN )
  if( UNIX )
    # this (weak) dependency is only present on linux/ubuntu
    find_package( Libicui18n QUIET )
    if( LIBICUI18N_FOUND )
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN
        RECOMMENDS libicui18n RUN )
    endif()
    find_package( Glib QUIET )
    if( GLIB_FOUND )
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS glib RUN )
    endif()
    if( LSB_DISTRIB STREQUAL "ubuntu"
        AND LSB_DISTRIB_RELEASE VERSION_GREATER "18.0" )
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN
                                       DEPENDS libdoubleconversion RUN )
    endif()
    find_package( LibPcre )
    if( LIBPCRE_FOUND )
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libpcre RUN )
    endif()
    find_package( LibHarfbuzz )
    if( LIBHARFBUZZ_FOUND )
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libharfbuzz
                                       RUN )
    endif()
    find_package( LibGraphite2 QUIET )
    if( LIBGRAPHITE2_FOUND )
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libgraphite2
                                       RUN )
    endif()
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(Qt5Core_FOUND)
    set( libs )
    foreach( _lib ${Qt5Core_LIBRARIES})
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
    foreach( plugin ${Qt5Core_PLUGINS} )
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

    # create qt.conf to enable finding qt plugins
    set(dest "bin")
    set(content "[Paths]\nPrefix = ../..\nPlugins = lib/qt5/plugins\n")
    if(APPLE)
      set(content "[Paths]\nPrefix = ../../../..\nPlugins = lib/qt5/plugins\n")
    endif()
    BRAINVISA_INSTALL(CODE "file(WRITE \"\${CMAKE_INSTALL_PREFIX}/${dest}/qt.conf\" \"${content}\")"
      COMPONENT "${component}")
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( libqt5core-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(Qt5Core_FOUND)
    foreach( _include ${Qt5Core_INCLUDE_DIRS} )
      get_filename_component( _name ${_include} NAME )
      if( _name STREQUAL "QtCore" )
        BRAINVISA_INSTALL_DIRECTORY( "${_include}" include/qt5/${_name}
          ${component}-dev )
      endif()
    endforeach()
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

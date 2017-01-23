# A CMake find module for GStreamer-1.0.
#
# Once done, this module will define
# GSTREAMER_FOUND - system has GStreamer
# GSTREAMER_INCLUDE_DIRS - the GStreamer include directory
# GSTREAMER_LIBRARIES - link to these to use GStreamer
# GSTREAMER_VERSION - version of GStreamer used
# GSTAPP_LIBRARIES - link to these to use libgstapp
# GSTBASE_LIBRARIES - link to these to use libgstbase
# GSTINTERFACES_LIBRARIES - link to these to use libgstinterfaces
# GSTPBUTILS_LIBRARIES - link to these to use libgstpbutils
# GSTVIDEO_LIBRARIES - link to these to use libgstvideo

find_package(PkgConfig)
if(PKG_CONFIG_FOUND) # Glib search is supported only through pkg_config.
  pkg_search_module(_GSTREAMER gstreamer-1.0)
  if( _GSTREAMER_FOUND )
    set( _gstreamer_ver 1.0 )
  else()
    pkg_search_module(_GSTREAMER gstreamer-0.10) # ubuntu 12.04
    if( _GSTREAMER_FOUND )
      set( _gstreamer_ver 0.10 )
    endif()
  endif()
  if( _GSTREAMER_FOUND )
    find_library( GSTREAMER_LIBRARIES ${_GSTREAMER_LIBRARIES}
                  PATHS ${_GSTREAMER_LIBRARY_DIRS} )
    pkg_search_module(_GSTAPP gstreamer-app-${_gstreamer_ver})
    if(_GSTAPP_FOUND)
      find_library( GSTAPP_LIBRARIES ${_GSTAPP_LIBRARIES}
                    PATHS ${_GSTAPP_LIBRARY_DIRS} )
    endif()
    pkg_search_module(_GSTBASE gstreamer-base-${_gstreamer_ver})
    if(_GSTBASE_FOUND)
      find_library( GSTBASE_LIBRARIES gstbase-${_gstreamer_ver}
                    PATHS ${_GSTBASE_LIBRARY_DIRS} )
    endif()
    pkg_search_module(_GSTINTERFACES gstreamer-interfaces-${_gstreamer_ver})
    if(_GSTINTERFACES_FOUND)
      find_library( GSTINTERFACES_LIBRARIES gstinterfaces-${_gstreamer_ver}
                    PATHS ${_GSTINTERFACES_LIBRARY_DIRS} )
    endif()
    pkg_search_module(_GSTPBUTILS gstreamer-pbutils-${_gstreamer_ver})
    if(_GSTPBUTILS_FOUND)
      find_library( GSTPBUTILS_LIBRARIES gstpbutils-${_gstreamer_ver}
                    PATHS ${_GSTPBUTILS_LIBRARY_DIRS} )
    endif()
    pkg_search_module(_GSTVIDEO gstreamer-video-${_gstreamer_ver})
    if(_GSTVIDEO_FOUND)
      find_library( GSTVIDEO_LIBRARIES gstvideo-${_gstreamer_ver}
                    PATHS ${_GSTVIDEO_LIBRARY_DIRS} )
    endif()
    set( GSTREAMER_INCLUDE_DIRS ${_GSTREAMER_INCLUDE_DIRS} CACHE PATH "paths to GStreamer header files" )
    set( GSTREAMER_VERSION "${_GSTREAMER_VERSION}" CACHE STRING "version of GStreamer library")

    if( GSTREAMER_INCLUDE_DIRS AND GSTREAMER_LIBRARIES )
      set( GSTREAMER_FOUND TRUE CACHE BOOL "specify that GStreamer library was found")
    endif()
  endif()
endif()


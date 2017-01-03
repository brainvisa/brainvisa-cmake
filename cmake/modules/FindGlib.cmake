# A CMake find module for Glib-2.0.
#
# http://openslide.org
#
# Once done, this module will define
# GLIB_FOUND - system has Glib
# GLIB_INCLUDE_DIRS - the Glib include directory
# GLIB_LIBRARIES - link to these to use Glib
# GLIB_VERSION - version of Glib used

find_package(PkgConfig)
if(PKG_CONFIG_FOUND) # Glib search is supported only through pkg_config.
  pkg_search_module(_GLIB glib-2.0)
  if(_GLIB_FOUND)
    find_library( GLIB_LIBRARIES1 ${_GLIB_LIBRARIES}
                  PATHS ${_GLIB_LIBRARY_DIRS} )
    pkg_search_module(_GLIB gthread-2.0)
    if(_GTHREAD_FOUND)
      find_library( GTHREAD_LIBRARIES ${_GTHREAD_LIBRARIES}
                    PATHS ${_GTHREAD_LIBRARY_DIRS} )
    endif()
    set( GLIB_LIBRARIES ${GLIB_LIBRARIES1} ${GTHREAD_LIBRARIES} CACHE PATH "paths to Glib/Gthread lib files" )
    set( GLIB_INCLUDE_DIRS ${_GLIB_INCLUDE_DIRS} CACHE PATH "paths to Glib header files" )
    set( GLIB_VERSION "${_GLIB_VERSION}" CACHE STRING "version of Glib library")

    if( GLIB_INCLUDE_DIRS AND GLIB_LIBRARIES )
      set( GLIB_FOUND TRUE CACHE BOOL "specify that Glib library was found")
    endif()
  endif()
endif()


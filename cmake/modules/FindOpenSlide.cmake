# A CMake find module for the OpenSlide microscopy file reader library.
#
# http://openslide.org
#
# Once done, this module will define
# OPENSLIDE_FOUND - system has OpenSlide
# OPENSLIDE_INCLUDE_DIRS - the OpenSlide include directory
# OPENSLIDE_LIBRARIES - link to these to use OpenSlide
# OPENSLIDE_VERSION - version of OpenSlide used

find_package(PkgConfig)
if(PkgConfig_FOUND) # OpenSlide search is supported only through pkg_config.
  pkg_search_module(_OPENSLIDE openslide)
  if(_OPENSLIDE_FOUND)
    find_library( OPENSLIDE_LIBRARIES ${_OPENSLIDE_LIBRARIES}
                  PATHS ${_OPENSLIDE_LIBRARY_DIRS} )
    set( OPENSLIDE_INCLUDE_DIRS ${_OPENSLIDE_INCLUDE_DIRS} CACHE PATH "paths to OpenSlide header files" )
    set( OPENSLIDE_VERSION "${_OPENSLIDE_VERSION}" CACHE STRING "version of OpenSlide library")

    if( OPENSLIDE_INCLUDE_DIRS AND OPENSLIDE_LIBRARIES )
      set( OPENSLIDE_FOUND TRUE CACHE BOOL "specify that OpenSlide library was found")
    endif()
  endif()
endif()


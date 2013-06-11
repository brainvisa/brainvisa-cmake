# A CMake find module for the OpenSlide microscopy file reader library.
#
# http://openslide.org
#
# Once done, this module will define
# OPENSLIDE_FOUND - system has OpenSlide
# OPENSLIDE_INCLUDE_DIRS - the OpenSlide include directory
# OPENSLIDE_LIBRARIES - link to these to use OpenSlide

find_package(PkgConfig REQUIRED)
pkg_search_module(OPENSLIDE REQUIRED openslide)
unset(_result)
unset(_lib)
unset(_libpath)
foreach(_lib ${OPENSLIDE_LIBRARIES})
  find_library(_libpath ${_lib} ${OPENSLIDE_LIBRARY_DIRS} NO_DEFAULT_PATH)
  set(_result ${_result} ${_libpath})
endforeach()

set(OPENSLIDE_LIBRARIES ${_result})
unset(_result)
unset(_lib)
unset(_libpath)

# message("OPENSLIDE_INCLUDE_DIRS : ${OPENSLIDE_INCLUDE_DIRS}")
# if( OPENSLIDE_LIBRARIES AND OPENSLIDE_INCLUDE_DIRS )
#   set( OPENSLIDE_FOUND TRUE )
# else()
# 
#   find_path( OPENSLIDE_INCLUDE_DIRS "openslide.h"
#     PATHS ${OPENSLIDE_DIR}/include
#     /usr/local/include
#     /usr/include  )
# 
#   find_library( OPENSLIDE_LIBRARIES libopenslide
#     PATHS ${OPENSLIDE_DIR}/lib
#     /usr/local/lib
#     /usr/lib )
# 
#   if( OPENSLIDE_LIBRARIES AND OPENSLIDE_INCLUDE_DIRS )
#     set( OPENSLIDE_FOUND TRUE )
#   else()
#   
#     set( OPENSLIDE_FOUND FALSE )
#   
#     if( OPENSLIDE_FIND_REQUIRED )
#         message( SEND_ERROR "OpenSlide library was not found." )
#     else()
#       if(NOT OPENSLIDE_FIND_QUIETLY)
#         message(STATUS "OpenSlide library was not found.")
#       endif()
#     endif()
#   
#   endif()
# 
# endif()
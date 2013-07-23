# A CMake find module for the OpenSlide microscopy file reader library.
#
# http://openslide.org
#
# Once done, this module will define
# OPENSLIDE_FOUND - system has OpenSlide
# OPENSLIDE_INCLUDE_DIRS - the OpenSlide include directory
# OPENSLIDE_LIBRARIES - link to these to use OpenSlide

find_package(PkgConfig)
if(PkgConfig_FOUND) # OpenSlide search is supported only through pkg_config.
  pkg_search_module(OPENSLIDE openslide)
  unset(_result)
  unset(_lib)
  unset(_libpath)
  if(OPENSLIDE_FOUND)
    foreach(_lib ${OPENSLIDE_LIBRARIES})
      find_library(_libpath ${_lib} ${OPENSLIDE_LIBRARY_DIRS} NO_DEFAULT_PATH)
      set(_result ${_result} ${_libpath})
    endforeach()

    set(OPENSLIDE_LIBRARIES ${_result})

    unset(_result)
    unset(_lib)
    unset(_libpath)
  endif()
endif()


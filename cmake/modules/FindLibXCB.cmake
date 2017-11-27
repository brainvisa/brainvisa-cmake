# Find LibXCB
#
# LIBXCB_FOUND
# LIBXCB_LIBRARIES - XCB libraries (may include xcb-render and xcb-shm if found)

IF(LIBXCB_LIBRARIES)
  # already found
  SET(LIBXCB_FOUND TRUE)
ELSE()

  # First try to search cairo through pkg_config.
  find_package(PkgConfig)
  message("**** FindLibXCB ****")
  if(PKG_CONFIG_FOUND)
    pkg_search_module(_LIBXCB xcb)
    if(_LIBXCB_FOUND)
      find_library( LIBXCB_LIBRARY ${_LIBXCB_LIBRARIES}
                    PATHS ${_LIBXCB_LIBRARY_DIRS} )
      set( LIBXCB_INCLUDE_DIRS ${_LIBXCB_INCLUDE_DIRS} CACHE PATH "Paths to xcb header files" )
      set( LIBXCB_VERSION "${_LIBXCB_VERSION}" CACHE STRING "Version of xcb library")

      if( LIBXCB_LIBRARY )
        set( LIBXCB_FOUND TRUE)

        # look for xcb-render and xcb-shm
        pkg_search_module(_LIBXCB_RENDER xcb-render)
        if(_LIBXCB_RENDER_FOUND)
          find_library( LIBXCB_RENDER_LIBRARY ${_LIBXCB_RENDER_LIBRARIES}
               PATH ${_LIBXCB_RENDER_LIBRARY_DIRS} )
        endif()
        pkg_search_module(_LIBXCB_SHM xcb-shm)
        if(_LIBXCB_SHM_FOUND)
          find_library( LIBXCB_SHM_LIBRARY ${_LIBXCB_SHM_LIBRARIES}
               PATH ${_LIBXCB_SHM_LIBRARY_DIRS} )
        endif()
        set( LIBXCB_LIBRARIES ${LIBXCB_LIBRARY} ${LIBXCB_RENDER_LIBRARY} ${LIBXCB_SHM_LIBRARY} CACHE PATH "LibXCB libraries" FORCE )
      endif()
    endif()
  endif()

  if(NOT LIBXCB_LIBRARIES)
    find_library(LIBXCB_LIBRARIES xcb)
    if(NOT LIBXCB_LIBRARIES)
      file( GLOB LIBXCB_LIBRARIES /usr/lib/libxcb.so.? )
    endif()
  endif()

  IF(LIBCAIRO_LIBRARIES)
    set(LIBXCB_LIBRARIES ${LIBXCB_LIBRARIES} CACHE PATH "LibXCB libraries" FORCE)
    SET(LIBXCB_FOUND TRUE)
  ELSE()
    SET(LIBXCB_FOUND FALSE)

    IF( LIBXCB_FIND_REQUIRED )
        MESSAGE( SEND_ERROR "LibXCB was not found." )
    ENDIF()
    IF(NOT LIBXCB_FIND_QUIETLY)
        MESSAGE(STATUS "LibXCB was not found.")
    ENDIF()
  ENDIF()

ENDIF()


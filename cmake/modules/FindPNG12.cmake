# Find PNG12
#
# PNG12_INCLUDE_DIR - paths to PNG12 header files
# PNG12_LIBRARIES - the PNG12 library
#

IF(EXISTS PNG12_LIBRARIES)
  # already found  
  SET(PNG12_FOUND TRUE)
ELSE(EXISTS PNG12_LIBRARIES)
  # use pkg-config to get the directories and then use these values
  # in the FIND_PATH() and FIND_LIBRARY() calls
  FIND_PACKAGE(PkgConfig)
  PKG_CHECK_MODULES(LIBPNG libpng)

  IF(LIBPNG_FOUND)
    FIND_LIBRARY( PNG12_LIBRARIES ${LIBPNG_LIBRARIES} )
    SET(PNG12_FOUND TRUE)
    SET(PNG12_VERSION ${LIBPNG_VERSION})
    set(PNG12_INCLUDE_DIR ${LIBPNG_INCLUDEDIR})
  ELSE(LIBPNG_FOUND)
    FIND_PATH( PNG12_INCLUDE_DIR png.h /usr/include/libpng12 NO_DEFAULT_PATH )
    FIND_PATH( PNG12_INCLUDE_DIR png.h )
    FIND_LIBRARY( PNG12_LIBRARIES png12 )

    SET(PNG12_FOUND FALSE)
    IF( PNG12_INCLUDE_DIR AND PNG12_LIBRARIES )
      SET( PNG12_FOUND TRUE )
    ENDIF( PNG12_INCLUDE_DIR AND PNG12_LIBRARIES )

    IF(NOT PNG12_FOUND)
      IF( PNG12_FIND_REQUIRED )
        MESSAGE( SEND_ERROR "PNG12 was not found." )
      ENDIF( PNG12_FIND_REQUIRED )
      IF(NOT PNG12_FIND_QUIETLY)
        MESSAGE(STATUS "PNG12 was not found.")
      ENDIF(NOT PNG12_FIND_QUIETLY)
    ENDIF(NOT PNG12_FOUND)

    SET( PNG12_LIBRARIES "${PNG12_LIBRARIES}" CACHE PATH "PNG12 libraries" )
  ENDIF(LIBPNG_FOUND)

ENDIF(EXISTS PNG12_LIBRARIES)


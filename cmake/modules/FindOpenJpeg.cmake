# Try to find the openjpeg (jpeg 2000)  library
# Once done this will define
#
# OPENJPEG_FOUND        - system has openjpeg and it can be used
# OPENJPEG_INCLUDE_DIRS - directory where the header file can be found
# OPENJPEG_LIBRARIES    - the openjpeg libraries

IF( OPENJPEG_INCLUDE_DIRS AND OPENJPEG_LIBRARIES )
  SET( OPENJPEG_FOUND TRUE )
ELSE()
  FIND_PATH( OPENJPEG_INCLUDE_DIRS openjpeg.h
    /usr/local/include/openjpeg
    /usr/local/include
    /usr/include/openjpeg
    /usr/include
  )

  SET( OPENJPEG_NAMES ${OPENJPEG_NAMES} openjpeg )
  FIND_LIBRARY( OPENJPEG_LIBRARY
    NAMES ${OPENJPEG_NAMES}
    PATHS /usr/lib /usr/local/lib
  )
  
  IF( OPENJPEG_INCLUDE_DIRS AND OPENJPEG_LIBRARIES )
    SET( OPENJPEG_FOUND TRUE )
  ELSE()
    IF( NOT OPENJPEG_FOUND )
      SET( OPENJPEG_DIR "" CACHE PATH "Root of OpenJpeg source tree (optional)." )
      MARK_AS_ADVANCED( OPENJPEG_DIR )
    ENDIF( NOT OPENJPEG_FOUND )
    IF( OPENJPEG_FIND_REQUIRED )
        MESSAGE( SEND_ERROR "OpenJpeg library was not found." )
    ELSE()
      IF( NOT OPENJPEG_FIND_QUIETLY )
        MESSAGE( STATUS "OpenJpeg library was not found." )
      ENDIF()
    ENDIF()
  ENDIF()
  
ENDIF()
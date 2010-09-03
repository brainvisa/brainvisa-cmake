# Find LibReadline
#
# LIBREADLINE_FOUND
# LIBREADLINE_LIBRARIES - the readline library

IF(LIBREADLINE_LIBRARIES)
  # already found  
  SET(LIBREADLINE_FOUND TRUE)
ELSE()
  FIND_LIBRARY( LIBREADLINE_LIBRARIES readline )
  IF(LIBREADLINE_LIBRARIES)
    SET(LIBREADLINE_FOUND TRUE)
  ELSE()
    SET(LIBREADLINE_FOUND FALSE)
      
    IF( LIBREADLINE_FIND_REQUIRED )
        MESSAGE( SEND_ERROR "LibReadline was not found." )
    ENDIF()
    IF(NOT LIBREADLINE_FIND_QUIETLY)
        MESSAGE(STATUS "LibReadline was not found.")
    ENDIF()
  ENDIF()

ENDIF()


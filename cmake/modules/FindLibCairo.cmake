# Find LibCairo
#
# LIBCAIRO_FOUND
# LIBCAIRO_LIBRARIES - cairo library

IF(LIBCAIRO_LIBRARIES)
  # already found  
  SET(LIBCAIRO_FOUND TRUE)
ELSE()
  find_library(LIBCAIRO_LIBRARIES cairo)
  if(NOT LIBCAIRO_LIBRARIES)
    file( GLOB LIBCAIRO_LIBRARIES /usr/lib/libcairo.so.? )
  endif()
  IF(LIBCAIRO_LIBRARIES)
    set(LIBCAIRO_LIBRARIES ${LIBCAIRO_LIBRARIES} CACHE PATH "LibCairo libraries" FORCE)
    SET(LIBCAIRO_FOUND TRUE)
  ELSE()
    SET(LIBCAIRO_FOUND FALSE)
      
    IF( LIBCAIRO_FIND_REQUIRED )
        MESSAGE( SEND_ERROR "LibCairo was not found." )
    ENDIF()
    IF(NOT LIBCAIRO_FIND_QUIETLY)
        MESSAGE(STATUS "LibCairo was not found.")
    ENDIF()
  ENDIF()

ENDIF()


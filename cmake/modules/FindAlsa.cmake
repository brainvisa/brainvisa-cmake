# Find dot executable and libraries
# The following variables are set:
#
#  ALSA_FOUND - Was dot found
#  ALSA_LIBRARIES - asound dynamic library

if( ALSA_LIBRARIES )

  set( ALSA_FOUND true )

else()
    
  find_library( ALSA_LIBRARIES asound )

  IF(ALSA_LIBRARIES)
    SET(ALSA_FOUND TRUE)
  ELSE()
    SET(ALSA_FOUND FALSE)
      
    IF( ALSA_FIND_REQUIRED )
        MESSAGE( SEND_ERROR "Library asound was not found." )
    ENDIF()
    IF(NOT ALSA_FIND_QUIETLY)
        MESSAGE(STATUS "Library asound was not found.")
    ENDIF()
  ENDIF()

endif()

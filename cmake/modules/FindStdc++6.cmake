# Find Stdc++
#
# STDCPP_FOUND
# STDCPP_LIBRARIES - the stdc++6 library

IF(STDCPP_LIBRARIES)
  # already found  
  SET(STDCPP_FOUND TRUE)
ELSE(STDCPP_LIBRARIES)
  FIND_FILE( STDCPP_LIBRARIES "libstdc++.so.6" 
     PATHS /usr/lib64 /usr/lib)

  IF( STDCPP_LIBRARIES )
    SET(STDCPP_FOUND TRUE)
  ELSE()
    IF( WIN32 )
      BRAINVISA_FIND_FSENTRY( STDCPP_LIBRARIES PATTERNS "libstdc++-6*" PATHS $ENV{PATH} )
    ENDIF()
    IF( NOT STDCPP_LIBRARIES )
      SET(STDCPP_FOUND FALSE)
        
      IF( STDCPP_FIND_REQUIRED )
          MESSAGE( SEND_ERROR "Stdc++6 was not found." )
      ENDIF()
      IF(NOT STDCPP_FIND_QUIETLY)
          MESSAGE(STATUS "Stdc++6 was not found.")
      ENDIF()
    ENDIF()
  ENDIF()

ENDIF()


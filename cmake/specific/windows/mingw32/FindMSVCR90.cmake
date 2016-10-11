# Find MSVCR90
#
# MSVCR90_FOUND
# MSVCR90_LIBRARIES - the MS Visual C Runtime library (version 9.0)

if (WIN32)
  if( MSVCR90_LIBRARIES )
    # Already found  
    set( MSVCR90_FOUND TRUE )
  else()
    find_library( MSVCR90_LIBRARIES NAMES msvcr90 )

    if( MSVCR90_LIBRARIES )
      set( MSVCR90_LIBRARIES "${MSVCR90_LIBRARIES}" CACHE PATH "MS Visual C Runtime library (version 9.0)" FORCE )
      set( MSVCR90_FOUND TRUE )
    else()
      set( MSVCR90_FOUND FALSE )
        
      if( MSVCR90_FIND_REQUIRED )
          message( SEND_ERROR "MSVCR90 was not found." )
      elseif( NOT MSVCR90_FIND_QUIETLY )
          message( STATUS "MSVCR90 was not found." )
      endif()
    endif()
  endif()
endif()


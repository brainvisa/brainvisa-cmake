# Find LIBWINPTHREAD
#
# LIBWINPTHREAD_FOUND
# LIBWINPTHREAD_LIBRARIES - the winpthread library

if (WIN32)
  if( LIBWINPTHREAD_LIBRARIES )
    # Already found  
    set( LIBWINPTHREAD_FOUND TRUE )
  else()
    # We use gcc version to get the winpthread version
    find_package(LIBGCC)
    find_library( LIBWINPTHREAD_LIBRARIES NAMES winpthread )
    
    if( NOT LIBWINPTHREAD_LIBRARIES )
      # Try to find it using MinGW
      find_package(MinGW)
      if( MINGW_FOUND )
        file( GLOB LIBWINPTHREAD_LIBRARIES "${MINGW_BIN_DIR}/libwinpthread*" )
      endif()
    endif()
    
    if( LIBWINPTHREAD_LIBRARIES )
      set( LIBWINPTHREAD_FOUND TRUE )
      set( LIBWINPTHREAD_LIBRARIES "${LIBWINPTHREAD_LIBRARIES}" CACHE PATH "Pthread library for windows" FORCE )
      set( LIBWINPTHREAD_VERSION "${GCC_VERSION}" CACHE PATH "Pthread library version" FORCE )
    else()
      set( LIBWINPTHREAD_FOUND FALSE )
        
      if( LIBWINPTHREAD_FIND_REQUIRED )
          message( SEND_ERROR "LIBWINPTHREAD was not found." )
      elseif( NOT LIBWINPTHREAD_FIND_QUIETLY )
          message( STATUS "LIBWINPTHREAD was not found." )
      endif()
    endif()
  endif()
endif()


# Find LIBGCC
#
# LIBGCC_FOUND
# LIBGCC_LIBRARIES - the gcc library

if( LIBGCC_LIBRARIES )
  # already found  
  set( LIBGCC_FOUND TRUE )
else()
  find_library( LIBGCC_LIBRARIES gcc_s )
  if( NOT LIBGCC_LIBRARIES )
    # On Ubuntu 10.4 libgcc_s is in /lib/libgcc_s.so.1 and CMake cannot find it
    # because there is no /lib/libgcc_s.so
    file( GLOB LIBGCC_LIBRARIES /lib/libgcc_s.so.? )
    if( LIBGCC_LIBRARIES )
      set( LIBGCC_LIBRARIES "${LIBGCC_LIBRARIES}" CACHE PATH "libgcc_s library" FORCE )
    endif()
  endif()
  if( LIBGCC_LIBRARIES )
    set( LIBGCC_FOUND TRUE )
  else()
    set( LIBGCC_FOUND FALSE )
      
    if( LIBGCC_FIND_REQUIRED )
        message( SEND_ERROR "LIBGCC was not found." )
    elseif( NOT LIBGCC_FIND_QUIETLY )
        message( STATUS "LIBGCC was not found." )
    endif()
  endif()
endif()


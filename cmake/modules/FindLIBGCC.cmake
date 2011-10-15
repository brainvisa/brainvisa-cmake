# Find LIBGCC
#
# LIBGCC_FOUND
# LIBGCC_LIBRARIES - the gcc library

if( LIBGCC_LIBRARIES )
  # already found  
  set( LIBGCC_FOUND TRUE )
else()
  find_library( LIBGCC_LIBRARIES NAMES gcc_s gcc_s_dw2-1 )
  if( NOT LIBGCC_LIBRARIES )
    # On Ubuntu 10.4 libgcc_s is in /lib/libgcc_s.so.1 and CMake cannot find it
    # because there is no /lib/libgcc_s.so
    file( GLOB LIBGCC_LIBRARIES /lib/libgcc_s.so )
    if( NOT LIBGCC_LIBRARIES )
      execute_process( COMMAND "${CMAKE_CXX_COMPILER}" "-v"
        ERROR_VARIABLE _gcc_v )
      string( REGEX MATCH "gcc version ([0-9]+.[0-9]+)" _gccver "${_gcc_v}" )
      set( GCC_VERSION ${CMAKE_MATCH_1} PARENT_SCOPE CACHE STRING "gcc version" )
      file( GLOB LIBGCC_LIBRARIES "/usr/lib/gcc/x86_64-linux-gnu/${_gccver}/libgcc_s.so" )
    endif()
    if( NOT LIBGCC_LIBRARIES )
        file( GLOB LIBGCC_LIBRARIES "/usr/lib/gcc/i686-linux-gnu/${_gccver}/libgcc_s.so" )
    endif()
    if( NOT LIBGCC_LIBRARIES )
      file( GLOB LIBGCC_LIBRARIES /usr/lib/ure/lib/libgcc_s.so.? )
    endif()
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


# Find LIBQUADMATH
#
# LIBQUADMATH_FOUND
# LIBQUADMATH_LIBRARIES - the quadmath library

if( LIBQUADMATH_LIBRARIES )
  # Already found  
  set( LIBQUADMATH_FOUND TRUE )
else()
  
  find_library( LIBQUADMATH_LIBRARIES NAMES quadmath quadmath-0 )
  if( NOT LIBQUADMATH_LIBRARIES )
    if( NOT LIBQUADMATH_LIBRARIES )
      execute_process( COMMAND "${CMAKE_CXX_COMPILER}" "-v"
        ERROR_VARIABLE _gcc_v )
      string( REGEX MATCH "gcc version ([0-9]+.[0-9]+)" _gccver "${_gcc_v}" )
      set( GCC_VERSION ${CMAKE_MATCH_1} CACHE STRING "gcc version" )
      set( _GCCPATH "/usr/lib/gcc/${CMAKE_LIBRARY_ARCHITECTURE}/${GCC_VERSION}" )
      find_library( LIBQUADMATH_LIBRARIES quadmath quadmath-0 PATHS ${_GCCPATH} )
      if( NOT LIBQUADMATH_LIBRARIES )
        file( GLOB LIBQUADMATH_LIBRARIES "${_GCCPATH}/libquadmath.so" )
      endif()
      unset( _GCCPATH )
    endif()
    if( NOT LIBQUADMATH_LIBRARIES )
      # Try to find it using MinGW
      find_package(MinGW)
      if( MINGW_FOUND )
        file( GLOB LIBQUADMATH_LIBRARIES "${MINGW_BIN_DIR}/libquadmath*" )
      else()
        file( GLOB LIBQUADMATH_LIBRARIES /usr/lib/ure/lib/libquadmath.so.? )
      endif()
    endif()
    if( LIBQUADMATH_LIBRARIES )
      set( LIBQUADMATH_LIBRARIES "${LIBQUADMATH_LIBRARIES}" CACHE PATH "LIBQUADMATH library" FORCE )
    endif()
  endif()
  if( LIBQUADMATH_LIBRARIES )
    set( LIBQUADMATH_FOUND TRUE )
  else()
    set( LIBQUADMATH_FOUND FALSE )
      
    if( LIBQUADMATH_FIND_REQUIRED )
        message( SEND_ERROR "LIBQUADMATH was not found." )
    elseif( NOT LIBQUADMATH_FIND_QUIETLY )
        message( STATUS "LIBQUADMATH was not found." )
    endif()
  endif()
endif()


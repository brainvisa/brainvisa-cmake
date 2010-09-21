# Find LibGFortran
#
# LIBGFORTRAN_FOUND
# LIBGFORTRAN_LIBRARIES - the gfortran and g2c libraries

if( LIBGFORTRAN_LIBRARIES )
  # already found  
  set( LIBGFORTRAN_FOUND TRUE )
else()
  find_library( LIBGFORTRAN gfortran )
  if( NOT LIBGFORTRAN )
    # On Mandriva-2008 libgfortran is in /usr/lib/libgfortran.so.2 and CMake cannot find it
    # because there is no /usr/lib/libgfortran.so
    file( GLOB LIBGFORTRAN /usr/lib/libgfortran.so.? )
  endif()
  # g2c doesn't mean to be mandatory on ubuntu or macos
  find_library( LIBG2C g2c )
  if( NOT LIBG2C )
    file( GLOB LIBG2C /usr/lib/libg2c.so.? )
  endif()
  if( LIBGFORTRAN )
    set( LIBGFORTRAN_LIBRARIES ${LIBGFORTRAN_LIBRARIES} "${LIBGFORTRAN}" )
    unset(LIBGFORTRAN CACHE)
  endif()
  if( LIBG2C )
    set( LIBGFORTRAN_LIBRARIES ${LIBGFORTRAN_LIBRARIES} "${LIBG2C}" )
    unset(LIBG2C CACHE)
  endif()
  if( LIBGFORTRAN_LIBRARIES )
    set( LIBGFORTRAN_FOUND TRUE )
    set( LIBGFORTRAN_LIBRARIES "${LIBGFORTRAN_LIBRARIES}" CACHE PATH "gfortran libraries" FORCE )
  else()
    set( LIBGFORTRAN_FOUND FALSE )
    if( LIBGFORTRAN_FIND_REQUIRED )
        message( SEND_ERROR "LIBGFORTRAN was not found." )
    elseif( NOT LIBGFORTRAN_FIND_QUIETLY )
        message( STATUS "LIBGFORTRAN was not found." )
    endif()
  endif()
endif()



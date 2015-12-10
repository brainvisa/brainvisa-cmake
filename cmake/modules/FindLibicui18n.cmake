# Find LIBICUI18N
#
# LIBICUI18N_FOUND
# LIBICUI18N_LIBRARIES - the icui18n libraries

if( LIBICUI18N_LIBRARIES )
  # Already found
  set( LIBICUI18N_FOUND TRUE )
else()

  set( _libs )
  find_library( _lib NAMES icui18n )
  if( _lib )
    set( LIBICUI18N_FOUND TRUE )
    list( APPEND _libs ${_lib} )
    unset( _lib CACHE )
    find_library( _lib NAMES icuuc )
    if( _lib )
      list( APPEND _libs ${_lib} )
    endif()
    unset( _lib CACHE )
    find_library( _lib NAMES icudata )
    if( _lib )
      list( APPEND _libs ${_lib} )
    endif()

    set( LIBICUI18N_LIBRARIES ${_libs} CACHE FILEPATH "libicui18n libraries" )

  else()
    set( LIBICUI18N_FOUND FALSE )

    if( LIBICUI18N_FIND_REQUIRED )
        message( SEND_ERROR "LIBICUI18N was not found." )
    elseif( NOT LIBICUI18N_FIND_QUIETLY )
        message( STATUS "LIBICUI18N was not found." )
    endif()
  endif()

  unset( _lib CACHE )
endif()


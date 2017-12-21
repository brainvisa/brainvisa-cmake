# Find qwt include dir and library
# The following variables are set:
#
#  QWT_FOUND - Was qwt found
#  QWT_LIBRARY -  qwt dynamic library
#  QWT_INCLUDE_DIR - include directory where to find qwt.h

if(QWT_LIBRARY AND QWT_INCLUDE_DIR)
  set(QWT_FOUND TRUE) 
endif()

if( NOT QWT_FOUND )
  set( paths qwt-qt${DESIRED_QT_VERSION} qwt5-qt${DESIRED_QT_VERSION} qwt qwt5 )
  set( include_paths)
  set( lib_paths)
  foreach( path ${paths} )
    set( include_paths ${include_paths} "${path}" "${path}/include" )
    set( lib_paths ${lib_paths} "${path}" "${path}/lib" )
  endforeach()
  set(include_paths ${include_paths} "include")
  set(lib_paths ${lib_paths} "lib")

  # First look only in paths from CMAKE_PREFIX_PATH
  find_path( QWT_INCLUDE_DIR qwt.h 
             PATHS ${CMAKE_PREFIX_PATH} ENV QWTDIR
             PATH_SUFFIXES ${include_paths}
             NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  find_library( QWT_LIBRARY 
                NAMES qwt-qt${DESIRED_QT_VERSION} qwt5-qt${DESIRED_QT_VERSION} qwt5 qwt
                PATHS ${CMAKE_PREFIX_PATH} ENV QWTDIR
                PATH_SUFFIXES ${lib_paths}
                NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )

  # Then look into all standard paths
  find_path( QWT_INCLUDE_DIR qwt.h 
             PATH_SUFFIXES ${include_paths} )
  find_library( QWT_LIBRARY 
                NAMES qwt-qt${DESIRED_QT_VERSION} qwt5-qt${DESIRED_QT_VERSION} qwt5 qwt
                PATH_SUFFIXES ${lib_paths} )

  # check that it is linked against the correct version of Qt
  if( QWT_LIBRARY AND (UNIX AND NOT APPLE) )
    execute_process( COMMAND ldd ${QWT_LIBRARY} OUTPUT_VARIABLE _qwt_libs )
    if( DESIRED_QT_VERSION EQUAL 4 )
      string( REGEX MATCH ".*(libQt5[^$]*)$" _match ${_qwt_libs} )
      if( _match )
        message( "Qwt is found but is linked against a different version of Qt" )
        unset( QWT_LIBRARY CACHE )
        unset( QWT_LIBRARY )
      endif()
    elseif( DESIRED_QT_VERSION EQUAL 5 )
      string( REGEX MATCH ".*(libQt[^$]*\\.so\\.4[^$]*)$" _match ${_qwt_libs} )
      if( _match )
        message( "Qwt is found but is linked against a different version of Qt" )
        unset( QWT_LIBRARY CACHE )
        unset( QWT_LIBRARY )
      endif()
    endif()
  endif()

  SET(QWT_FOUND FALSE)
  IF(QWT_INCLUDE_DIR AND QWT_LIBRARY)
    
    if(NOT QWT_VERSION)
      # Try to find qwt version
      if( EXISTS "${QWT_INCLUDE_DIR}/qwt_global.h" )
        include("${CMAKE_CURRENT_LIST_DIR}/UseHexConvert.cmake")
        file( READ "${QWT_INCLUDE_DIR}/qwt_global.h" header )
        string( REGEX MATCH "#define[ \\t]+QWT_VERSION[ \\t]+0x([0-9a-fA-F][0-9a-fA-F])([0-9a-fA-F][0-9a-fA-F])([0-9a-fA-F][0-9a-fA-F]).*" match "${header}" )

        if( match )
          # Convert hexadecimal values
          set(__major_hex_version "${CMAKE_MATCH_1}")
          set(__minor_hex_version "${CMAKE_MATCH_2}")
          set(__micro_hex_version "${CMAKE_MATCH_3}")
          HEX2DEC(__major_version "${__major_hex_version}")
          HEX2DEC(__minor_version "${__minor_hex_version}")
          HEX2DEC(__micro_version "${__micro_hex_version}")
            
          set(QWT_VERSION 
              "${__major_version}.${__minor_version}.${__micro_version}" 
              CACHE STRING "Qwt library version")
          unset(__major_hex_version)
          unset(__minor_hex_version)
          unset(__micro_hex_version)
          unset(__major_version)
          unset(__minor_version)
          unset(__micro_version)
        endif()
      endif()
    endif()
    
    SET(QWT_FOUND TRUE)
  ENDIF(QWT_INCLUDE_DIR AND QWT_LIBRARY)

  IF(NOT QWT_FOUND)
    IF(NOT QWT_FIND_QUIETLY)
      MESSAGE(STATUS "Qwt was not found.")
    ELSE(NOT QWT_FIND_QUIETLY)
      IF(QWT_FIND_REQUIRED)
        MESSAGE(FATAL_ERROR "Qwt was not found.")
      ENDIF(QWT_FIND_REQUIRED)
    ENDIF(NOT QWT_FIND_QUIETLY)
  ENDIF(NOT QWT_FOUND)
endif()

if( NOT QWT_FOUND )
  set( paths qwt-qt${DESIRED_QT_VERSION} qwt5-qt${DESIRED_QT_VERSION} qwt qwt5 )
  set( include_paths )
  set( lib_paths )
  foreach( path ${paths} )
    set( include_paths ${include_paths} "${path}" "${path}/include" )
    set( lib_paths ${lib_paths} "${path}" "${path}/lib" )
  endforeach()

  # First look only in paths from CMAKE_PREFIX_PATH
  find_path( QWT_INCLUDE_DIR qwt.h 
             PATHS ${CMAKE_PREFIX_PATH}
             PATH_SUFFIXES ${include_paths}
             NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  find_library( QWT_LIBRARY 
                NAMES qwt5-qt${DESIRED_QT_VERSION} qwt-qt${DESIRED_QT_VERSION} qwt5 qwt
                PATHS ${CMAKE_PREFIX_PATH}
                PATH_SUFFIXES ${lib_paths}
                NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH )
  # Then look into all standard paths
  find_path( QWT_INCLUDE_DIR qwt.h 
             PATH_SUFFIXES ${include_paths} )
  find_library( QWT_LIBRARY 
                NAMES qwt5-qt${DESIRED_QT_VERSION} qwt-qt${DESIRED_QT_VERSION} qwt5 qwt
                PATH_SUFFIXES ${lib_paths} )
  
  SET(QWT_FOUND FALSE)
  IF(QWT_INCLUDE_DIR AND QWT_LIBRARY)
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

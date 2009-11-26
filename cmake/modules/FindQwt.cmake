IF( QWT_FOUND )
ELSE ( QWT_FOUND )

FIND_PATH( QWT_INCLUDE_DIR qwt.h 
               PATHS ${QT_INCLUDE_DIR} /usr/local/qwt/include /usr/include/qwt
               PATH_SUFFIXES qwt qwt5 qwt-qt${DESIRED_QT_VERSION} qwt5-qt${DESIRED_QT_VERSION} include qwt/include qwt5/include qwt-qt${DESIRED_QT_VERSION}/include qwt5-qt${DESIRED_QT_VERSION}/include
               ENV PATH )

FIND_LIBRARY( QWT_LIBRARY 
              NAMES qwt5-qt${DESIRED_QT_VERSION} qwt-qt${DESIRED_QT_VERSION} qwt5 qwt
              PATHS /usr/local /usr
              PATH_SUFFIXES qwt qwt5 qwt-qt${DESIRED_QT_VERSION} qwt5-qt${DESIRED_QT_VERSION} lib qwt/lib qwt5/lib qwt-qt${DESIRED_QT_VERSION}/lib qwt5-qt${DESIRED_QT_VERSION}/lib
            )

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


ENDIF( QWT_FOUND )

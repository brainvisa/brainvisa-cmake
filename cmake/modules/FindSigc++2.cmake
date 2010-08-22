# Find Sigc++2
#
# Sigc++2_INCLUDE_DIRS - paths to Sigc++2 header files
# Sigc++2_LIBRARIES - the Sigc++2 library
#

IF(EXISTS Sigc++2_INCLUDE_DIR)
  # already found  
  SET(Sigc++2_FOUND TRUE)
  SET( Sigc++2_INCLUDE_DIRS "${Sigc++2_INCLUDE_DIR}" "${Sigc++2_CONFIG_DIR}" )
ELSE(EXISTS Sigc++2_INCLUDE_DIR)
  # use pkg-config to get the directories and then use these values
  # in the FIND_PATH() and FIND_LIBRARY() calls
  FIND_PACKAGE(PkgConfig)
  PKG_CHECK_MODULES(SIGCPP2 sigc++-2.0)

  IF(SIGCPP2_FOUND)
    FIND_LIBRARY( Sigc++2_LIBRARIES ${SIGCPP2_LIBRARIES} )
    FIND_PATH( Sigc++2_INCLUDE_DIR sigc++/sigc++.h /usr/include/sigc++-2.0 NO_DEFAULT_PATH )
    FIND_PATH( Sigc++2_INCLUDE_DIR sigc++/sigc++.h )
    FIND_PATH( Sigc++2_CONFIG_DIR  sigc++config.h  PATHS /usr/lib/sigc++-2.0/include NO_DEFAULT_PATH )
    FIND_PATH( Sigc++2_CONFIG_DIR  sigc++config.h )
    SET(Sigc++2_FOUND TRUE)
    SET(Sigc++2_VERSION ${SIGCPP2_VERSION})
  ELSE(SIGCPP2_FOUND)
    FIND_PATH( Sigc++2_INCLUDE_DIR sigc++/sigc++.h /usr/include/sigc++-2.0 NO_DEFAULT_PATH )
    FIND_PATH( Sigc++2_INCLUDE_DIR sigc++/sigc++.h )
    FIND_PATH( Sigc++2_CONFIG_DIR  sigc++config.h  PATHS /usr/lib/sigc++-2.0/include NO_DEFAULT_PATH )
    FIND_PATH( Sigc++2_CONFIG_DIR  sigc++config.h )
    FIND_LIBRARY( Sigc++2_LIBRARIES sigc-2.0 )

    SET(Sigc++2_FOUND FALSE)
    IF( Sigc++2_INCLUDE_DIR AND Sigc++2_CONFIG_DIR AND Sigc++2_LIBRARIES )
      SET( Sigc++2_FOUND TRUE )
    ENDIF( Sigc++2_INCLUDE_DIR AND Sigc++2_CONFIG_DIR AND Sigc++2_LIBRARIES )

    IF(NOT Sigc++2_FOUND)
      IF( Sigc++2_FIND_REQUIRED )
        MESSAGE( SEND_ERROR "Sigc++-2.0 was not found." )
      ENDIF( Sigc++2_FIND_REQUIRED )
      IF(NOT Sigc++2_FIND_QUIETLY)
        MESSAGE(STATUS "Sigc++-2.0 was not found.")
      ENDIF(NOT Sigc++2_FIND_QUIETLY)
    ENDIF(NOT Sigc++2_FOUND)

    SET( Sigc++2_LIBRARIES "${Sigc++2_LIBRARIES}" CACHE PATH "Sigc++2 libraries" )
  ENDIF(SIGCPP2_FOUND)

  SET( Sigc++2_INCLUDE_DIRS "${Sigc++2_INCLUDE_DIR}" "${Sigc++2_CONFIG_DIR}" )

ENDIF(EXISTS Sigc++2_INCLUDE_DIR)


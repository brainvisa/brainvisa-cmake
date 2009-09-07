# - find DCMTK libraries
#

#  DCMTK_INCLUDE_DIR   - Directories to include to use DCMTK
#  DCMTK_LIBRARIES     - Files to link against to use DCMTK
#  DCMTK_FOUND         - If false, don't try to use DCMTK
#  DCMTK_DIR           - (optional) Source directory for DCMTK
#
# DCMTK_DIR can be used to make it simpler to find the various include
# directories and compiled libraries if you've just compiled it in the
# source tree. Just set it to the root of the tree where you extracted
# the source.
#
# Written for VXL by Amitha Perera. -> Hacked by P. Fillard
# Hacked again by Yann Cointepas


set( _includeDirectories
  "${DCMTK_DIR}/include"
  /usr/local/include
  /usr/include
)
set( _libraryDirectories
  "${DCMTK_DIR}/lib"
  /usr/local/lib
  /usr/lib
)
set( _pathSuffixes
  "dcmtk/include"
  "dcmtk/lib"
)

If( NOT DCMTK_PRE_353 )
  FIND_PATH( DCMTK_config_INCLUDE_DIR dcmtk/config/osconfig.h
    ${_includeDirectories}
    PATH_SUFFIXES ${_pathSuffixes}
  )
ENDIF( NOT DCMTK_PRE_353 )

IF( NOT DCMTK_config_INCLUDE_DIR OR DCMTK_PRE_353 )
  # For DCMTK <= 3.5.3
  FIND_PATH( DCMTK_config_INCLUDE_DIR osconfig.h
    ${_includeDirectories}
    PATH_SUFFIXES ${_pathSuffixes}
  )
  IF( DCMTK_config_INCLUDE_DIR )
    SET( DCMTK_PRE_353 TRUE CACHE STRING
      "if DcmTk version is older or equal to  3.5.3" )
    mark_as_advanced( DCMTK_PRE_353 )
  ENDIF( DCMTK_config_INCLUDE_DIR )
ELSE( NOT DCMTK_config_INCLUDE_DIR )
ENDIF( NOT DCMTK_config_INCLUDE_DIR OR DCMTK_PRE_353 )

IF( DCMTK_PRE_353 )
  # For DCMTK <= 3.5.3

  FIND_PATH( DCMTK_ofstd_INCLUDE_DIR ofstd/ofstdinc.h
    ${_includeDirectories}
    PATH_SUFFIXES ${_pathSuffixes}
  )

  FIND_PATH( DCMTK_dcmdata_INCLUDE_DIR dcmdata/dctypes.h
    ${_includeDirectories}
    PATH_SUFFIXES ${_pathSuffixes}
  )

  FIND_PATH( DCMTK_dcmimgle_INCLUDE_DIR dcmimgle/dcmimage.h
    ${_includeDirectories}
    PATH_SUFFIXES ${_pathSuffixes}
  )

ELSE( DCMTK_PRE_353 )
  # For DCMTK >= 3.5.4

  FIND_PATH( DCMTK_ofstd_INCLUDE_DIR dcmtk/ofstd/ofstdinc.h
    ${_includeDirectories}
    PATH_SUFFIXES ${_pathSuffixes}
  )


  FIND_PATH( DCMTK_dcmdata_INCLUDE_DIR dcmtk/dcmdata/dctypes.h
    ${_includeDirectories}
    PATH_SUFFIXES ${_pathSuffixes}
  )

  FIND_PATH( DCMTK_dcmimgle_INCLUDE_DIR dcmtk/dcmimgle/dcmimage.h
    ${_includeDirectories}
    PATH_SUFFIXES ${_pathSuffixes}
  )

ENDIF( DCMTK_PRE_353 )

FIND_LIBRARY( DCMTK_ofstd_LIBRARY ofstd
  ${_libraryDirectories}
  PATH_SUFFIXES ${_pathSuffixes}
)

FIND_LIBRARY( DCMTK_dcmdata_LIBRARY dcmdata
  ${_libraryDirectories}
  PATH_SUFFIXES ${_pathSuffixes}
)

FIND_LIBRARY( DCMTK_dcmimgle_LIBRARY dcmimgle
  ${_libraryDirectories}
  PATH_SUFFIXES ${_pathSuffixes}
)

FIND_LIBRARY(DCMTK_imagedb_LIBRARY imagedb
  ${_libraryDirectories}
  PATH_SUFFIXES ${_pathSuffixes}
)

FIND_LIBRARY(DCMTK_dcmnet_LIBRARY dcmnet
  ${_libraryDirectories}
  PATH_SUFFIXES ${_pathSuffixes}
)


IF( DCMTK_config_INCLUDE_DIR )
IF( DCMTK_ofstd_INCLUDE_DIR )
IF( DCMTK_ofstd_LIBRARY )
IF( DCMTK_dcmdata_INCLUDE_DIR )
IF( DCMTK_dcmdata_LIBRARY )
IF( DCMTK_dcmimgle_INCLUDE_DIR )
IF( DCMTK_dcmimgle_LIBRARY )

  SET( DCMTK_FOUND "YES" )
  IF( DCMTK_PRE_353 )
    SET( DCMTK_INCLUDE_DIR
      ${DCMTK_config_INCLUDE_DIR}
      ${DCMTK_ofstd_INCLUDE_DIR}/ofstd
      ${DCMTK_dcmdata_INCLUDE_DIR}/dcmdata
      ${DCMTK_dcmimgle_INCLUDE_DIR}/dcmimgle
    )
  ELSE( DCMTK_PRE_353 )
    SET( DCMTK_INCLUDE_DIR
      ${DCMTK_config_INCLUDE_DIR}
      ${DCMTK_config_INCLUDE_DIR}/dcmtk/config
      ${DCMTK_ofstd_INCLUDE_DIR}/dcmtk/ofstd
      ${DCMTK_dcmdata_INCLUDE_DIR}/dcmtk/dcmdata
      ${DCMTK_dcmimgle_INCLUDE_DIR}/dcmtk/dcmimgle
    )
  ENDIF( DCMTK_PRE_353 )

  SET( DCMTK_LIBRARIES
    ${DCMTK_dcmimgle_LIBRARY}
    ${DCMTK_dcmdata_LIBRARY}
    ${DCMTK_ofstd_LIBRARY}
    ${DCMTK_config_LIBRARY}
  )
  IF( APPLE )
    SET( DCMTK_LIBRARIES ${DCMTK_LIBRARIES} z )
  ENDIF( APPLE )

  IF(DCMTK_imagedb_LIBRARY)
   SET(DCMTK_LIBRARIES
   ${DCMTK_LIBRARIES}
   ${DCMTK_imagedb_LIBRARY}
   )
  ENDIF(DCMTK_imagedb_LIBRARY)

  IF(DCMTK_dcmnet_LIBRARY)
   SET( DCMTK_LIBRARIES
   ${DCMTK_LIBRARIES}
   ${DCMTK_dcmnet_LIBRARY}
   )
   IF(EXISTS /etc/debian_version AND EXISTS /lib/libwrap.so.0)
     SET( DCMTK_LIBRARIES
     ${DCMTK_LIBRARIES}
     /lib/libwrap.so.0
     )
   ENDIF(EXISTS /etc/debian_version AND EXISTS /lib/libwrap.so.0)
   
  ENDIF(DCMTK_dcmnet_LIBRARY)

  IF( WIN32 )
    SET( DCMTK_LIBRARIES ${DCMTK_LIBRARIES} netapi32 )
  ENDIF( WIN32 )

ENDIF( DCMTK_dcmimgle_LIBRARY )
ENDIF( DCMTK_dcmimgle_INCLUDE_DIR )
ENDIF( DCMTK_dcmdata_LIBRARY )
ENDIF( DCMTK_dcmdata_INCLUDE_DIR )
ENDIF( DCMTK_ofstd_LIBRARY )
ENDIF( DCMTK_ofstd_INCLUDE_DIR )
ENDIF( DCMTK_config_INCLUDE_DIR )


if( DCMTK_FOUND )
  if( NOT DCMTK_FIND_QUIETLY )
    if( DCMTK_PRE_353 )
      message( STATUS "Found dcmtk <= 3.5.3" )
    else( DCMTK_PRE_353 )
      message( STATUS "Found dcmtk >= 3.5.4" )
    endif( DCMTK_PRE_353 )
  endif( NOT DCMTK_FIND_QUIETLY )
else( DCMTK_FOUND )
  set( DCMTK_DIR "" CACHE PATH "Root of DCMTK source tree (optional)." )
  mark_as_advanced( DCMTK_DIR )
  if( NOT DCMTK_FIND_QUIETLY )
    if( DCMTK_FIND_REQUIRED )
      message( FATAL_ERROR "dcmtk not found" )
    else( DCMTK_FIND_REQUIRED )
      message( STATUS "dcmtk not found" )
    endif( DCMTK_FIND_REQUIRED )
  endif( NOT DCMTK_FIND_QUIETLY )
endif( DCMTK_FOUND )


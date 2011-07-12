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
# Hacked again by Cyril Poupon


set( _directories
  "${DCMTK_DIR}"
)

if( NOT _directories )
set( _directories
  "$ENV{DCMTK_DIR}"
)
endif()
  
set( _includeSuffixes
  include
  dcmtk/include
  include/dcmtk
  dcmtk
)
set( _librarySuffixes
  lib
  dcmtk/lib
)
set( _shareSuffixes 
  share/dcmtk
  dcmtk/share/dcmtk
)
if( NOT DCMTK_PRE_353 )
  find_path( DCMTK_config_INCLUDE_DIR config/osconfig.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
  )
endif()

if( NOT DCMTK_config_INCLUDE_DIR OR DCMTK_PRE_353 )
  # For DCMTK <= 3.5.3
  find_path( DCMTK_config_INCLUDE_DIR osconfig.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
  )
  if( DCMTK_config_INCLUDE_DIR )
    set( DCMTK_PRE_353 TRUE CACHE STRING
      "if DcmTk version is older or equal to  3.5.3" )
    mark_as_advanced( DCMTK_PRE_353 )
  endif( DCMTK_config_INCLUDE_DIR )
endif()

if( DCMTK_PRE_353 )
  # For DCMTK <= 3.5.3

  find_path( DCMTK_ofstd_INCLUDE_DIR ofstd/ofstdinc.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
  )

  find_path( DCMTK_dcmdata_INCLUDE_DIR dcmdata/dctypes.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
  )

  find_path( DCMTK_dcmimgle_INCLUDE_DIR dcmimgle/dcmimage.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
  )

else()
  # For DCMTK >= 3.5.4


  find_path( DCMTK_ofstd_INCLUDE_DIR dcmtk/ofstd/ofstdinc.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
  )

  # For DCMTK >= 3.6.0
  find_path( DCMTK_oflog_INCLUDE_DIR dcmtk/oflog/logger.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
  )

  find_path( DCMTK_dcmdata_INCLUDE_DIR dcmtk/dcmdata/dctypes.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
  )

  find_path( DCMTK_dcmnet_INCLUDE_DIR dcmtk/dcmnet/dcmtrans.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
  )

  find_path( DCMTK_dcmtls_INCLUDE_DIR dcmtk/dcmtls/tlslayer.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
  )

  find_path( DCMTK_dcmimgle_INCLUDE_DIR dcmtk/dcmimgle/dcmimage.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
  )

  find_path( DCMTK_dcmjpeg_INCLUDE_DIR dcmtk/dcmjpeg/djdijg16.h
    PATHS ${_directories}
    PATH_SUFFIXES ${_includeSuffixes}
  )

endif()

find_library( DCMTK_ofstd_LIBRARY ofstd
    PATHS ${_directories}
    PATH_SUFFIXES ${_librarySuffixes}
)

# For DCMTK >= 3.6.0
find_library(DCMTK_oflog_LIBRARY oflog
  PATHS ${_directories}
  PATH_SUFFIXES ${_librarySuffixes}
)

find_library( DCMTK_dcmdata_LIBRARY dcmdata
    PATHS ${_directories}
    PATH_SUFFIXES ${_librarySuffixes}
)

find_library( DCMTK_dcmnet_LIBRARY dcmnet
    PATHS ${_directories}
    PATH_SUFFIXES ${_librarySuffixes}
)

find_library( DCMTK_dcmtls_LIBRARY dcmtls
    PATHS ${_directories}
    PATH_SUFFIXES ${_librarySuffixes}
)

find_library( DCMTK_dcmimgle_LIBRARY dcmimgle
    PATHS ${_directories}
    PATH_SUFFIXES ${_librarySuffixes}
)

find_library(DCMTK_dcmjpeg_LIBRARY dcmjpeg
  PATHS ${_libraryDirectories}
  PATH_SUFFIXES ${_pathSuffixes}
)

find_library(DCMTK_ijg8_LIBRARY ijg8
  PATHS ${_libraryDirectories}
  PATH_SUFFIXES ${_pathSuffixes}
)

find_library(DCMTK_ijg12_LIBRARY ijg12
  PATHS ${_libraryDirectories}
  PATH_SUFFIXES ${_pathSuffixes}
)

find_library(DCMTK_ijg16_LIBRARY ijg16
  PATHS ${_libraryDirectories}
  PATH_SUFFIXES ${_pathSuffixes}
)

find_file( DCMTK_dict dicom.dic
    PATHS ${_directories} ${CMAKE_LIBRARY_PATH} ${CMAKE_FRAMEWORK_PATH}
    PATH_SUFFIXES ${_librarySuffixes} ${_shareSuffixes}
)

if( DCMTK_config_INCLUDE_DIR AND
    DCMTK_ofstd_INCLUDE_DIR AND
    DCMTK_ofstd_LIBRARY AND
    DCMTK_dcmdata_INCLUDE_DIR AND
    DCMTK_dcmdata_LIBRARY AND
    DCMTK_dcmimgle_INCLUDE_DIR AND
    DCMTK_dcmimgle_LIBRARY )

  SET( DCMTK_FOUND "YES" )
  IF( DCMTK_PRE_353 )
    SET( DCMTK_INCLUDE_DIR
      ${DCMTK_config_INCLUDE_DIR}
      ${DCMTK_ofstd_INCLUDE_DIR}/ofstd
      ${DCMTK_dcmdata_INCLUDE_DIR}/dcmdata
      ${DCMTK_dcmimgle_INCLUDE_DIR}/dcmimgle
    )
  ELSE()
    SET( DCMTK_INCLUDE_DIR
      ${DCMTK_config_INCLUDE_DIR}
      ${DCMTK_config_INCLUDE_DIR}/dcmtk/config
      ${DCMTK_ofstd_INCLUDE_DIR}/dcmtk/ofstd
      ${DCMTK_dcmdata_INCLUDE_DIR}/dcmtk/dcmdata
      ${DCMTK_dcmimgle_INCLUDE_DIR}/dcmtk/dcmnet
      ${DCMTK_dcmimgle_INCLUDE_DIR}/dcmtk/dcmtls
      ${DCMTK_dcmimgle_INCLUDE_DIR}/dcmtk/dcmimgle
      ${DCMTK_dcmimgle_INCLUDE_DIR}/dcmtk/dcmjpeg
#      ${DCMTK_config_INCLUDE_DIR}/config
#      ${DCMTK_ofstd_INCLUDE_DIR}/ofstd
#      ${DCMTK_dcmdata_INCLUDE_DIR}/dcmdata
#      ${DCMTK_dcmimgle_INCLUDE_DIR}/dcmnet
#      ${DCMTK_dcmimgle_INCLUDE_DIR}/dcmtls
#      ${DCMTK_dcmimgle_INCLUDE_DIR}/dcmimgle
#      ${DCMTK_dcmimgle_INCLUDE_DIR}/dcmjpeg
    )
  ENDIF()

  # For DCMTK >= 3.6.0
  IF(DCMTK_oflog_LIBRARY)
   SET(DCMTK_INCLUDE_DIR
     ${DCMTK_INCLUDE_DIR}
     ${DCMTK_oflog_INCLUDE_DIR}/oflog
     ${DCMTK_oflog_INCLUDE_DIR}/dcmtk/oflog
   )
   SET(DCMTK_LIBRARIES
     ${DCMTK_LIBRARIES}
     ${DCMTK_dcmimgle_LIBRARY}
     ${DCMTK_dcmdata_LIBRARY}
     ${DCMTK_oflog_LIBRARY}
     ${DCMTK_ofstd_LIBRARY}
     ${DCMTK_config_LIBRARY}
   )
  ELSE(DCMTK_oflog_LIBRARY)
    SET( DCMTK_LIBRARIES
      ${DCMTK_dcmimgle_LIBRARY}
      ${DCMTK_dcmdata_LIBRARY}
      ${DCMTK_ofstd_LIBRARY}
      ${DCMTK_config_LIBRARY}
  )
  ENDIF(DCMTK_oflog_LIBRARY)

  IF( APPLE )
    find_package( ZLIB )
    if( ZLIB_FOUND )
      SET( DCMTK_LIBRARIES ${DCMTK_LIBRARIES} ${ZLIB_LIBRARIES} )
    endif( ZLIB_FOUND )
  ENDIF( APPLE )

  IF(DCMTK_dcmjpeg_LIBRARY)
   SET(DCMTK_LIBRARIES
   ${DCMTK_LIBRARIES}
   ${DCMTK_dcmjpeg_LIBRARY}
   )
  ENDIF(DCMTK_dcmjpeg_LIBRARY)

  IF(DCMTK_ijg8_LIBRARY)
   SET(DCMTK_LIBRARIES
   ${DCMTK_LIBRARIES}
   ${DCMTK_ijg8_LIBRARY}
   )
  ENDIF(DCMTK_ijg8_LIBRARY)
  
  IF(DCMTK_ijg12_LIBRARY)
   SET(DCMTK_LIBRARIES
   ${DCMTK_LIBRARIES}
   ${DCMTK_ijg12_LIBRARY}
   )
  ENDIF(DCMTK_ijg12_LIBRARY)

  IF(DCMTK_ijg16_LIBRARY)
   SET(DCMTK_LIBRARIES
   ${DCMTK_LIBRARIES}
   ${DCMTK_ijg16_LIBRARY}
   )
  ENDIF(DCMTK_ijg16_LIBRARY)

  IF(DCMTK_dcmnet_LIBRARY)
   SET( DCMTK_LIBRARIES
   ${DCMTK_dcmnet_LIBRARY}
   ${DCMTK_LIBRARIES}
   )
   IF(EXISTS /etc/debian_version AND EXISTS /lib64/libwrap.so.0)
     SET( DCMTK_LIBRARIES
     ${DCMTK_LIBRARIES}
     /lib64/libwrap.so.0
     )
   ELSE()
    IF(EXISTS /etc/redhat-release AND EXISTS /usr/lib64/libwrap.so.0)
      SET( DCMTK_LIBRARIES
      ${DCMTK_LIBRARIES}
      /usr/lib64/libwrap.so.0
      )
    ELSE()
      IF(EXISTS /etc/debian_version AND EXISTS /lib/libwrap.so.0)
        SET( DCMTK_LIBRARIES
        ${DCMTK_LIBRARIES}
        /lib/libwrap.so.0
        )
      ELSE()
        IF(EXISTS /etc/redhat-release AND EXISTS /usr/lib/libwrap.so.0)
          SET( DCMTK_LIBRARIES
          ${DCMTK_LIBRARIES}
          /usr/lib/libwrap.so.0
          )
        ENDIF(EXISTS /etc/redhat-release AND EXISTS /usr/lib/libwrap.so.0)
      ENDIF(EXISTS /etc/debian_version AND EXISTS /lib/libwrap.so.0)
    ENDIF()
   ENDIF()

  ENDIF(DCMTK_dcmnet_LIBRARY)

  if( DCMTK_dcmtls_LIBRARY )
    find_package( OpenSSL )
    if( OPENSSL_FOUND )
      set( DCMTK_LIBRARIES ${OPENSSL_LIBRARIES} "${DCMTK_dcmtls_LIBRARY}" ${DCMTK_LIBRARIES} )
    endif()
  endif()

  IF( WIN32 )
    find_library(netapi32 netapi32.dll)
    SET( DCMTK_LIBRARIES ${DCMTK_LIBRARIES} ${netapi32} )
  ENDIF( WIN32 )

  IF( UNIX )
    find_package( ZLIB REQUIRED)
    if( ZLIB_FOUND )
      SET( DCMTK_LIBRARIES ${DCMTK_LIBRARIES} ${ZLIB_LIBRARIES} )
    endif( ZLIB_FOUND )
  ENDIF( UNIX )

endif()


if( NOT DCMTK_FOUND )
  set( DCMTK_DIR "" CACHE PATH "Root of DCMTK source tree (optional)." )
  mark_as_advanced( DCMTK_DIR )
  if( NOT DCMTK_FIND_QUIETLY )
    if( DCMTK_FIND_REQUIRED )
      message( FATAL_ERROR "dcmtk not found" )
    else()
      message( STATUS "dcmtk not found" )
    endif()
  endif()
endif()


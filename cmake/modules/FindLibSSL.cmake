# Find LibSSL
#
# LIBSSL_FOUND
# LIBSSL_LIBRARIES - ssl and crypto libraries

IF(LIBSSL_LIBRARIES)
  # already found  
  SET(LIBSSL_FOUND TRUE)
ELSE()
  find_package(OpenSSL)
  FIND_LIBRARY( CRYPTO_LIBRARY crypto )
  IF(OPENSSL_LIBRARIES AND CRYPTO_LIBRARY)
    SET(LIBSSL_LIBRARIES ${OPENSSL_LIBRARIES} "${CRYPTO_LIBRARY}")
    set(LIBSSL_LIBRARIES ${LIBSSL_LIBRARIES} CACHE PATH "LibSSL libraries")
    SET(LIBSSL_FOUND TRUE)
  ELSE()
    SET(LIBSSL_FOUND FALSE)
      
    IF( LIBSSL_FIND_REQUIRED )
        MESSAGE( SEND_ERROR "LIBSSL was not found." )
    ENDIF()
    IF(NOT LIBSSL_FIND_QUIETLY)
        MESSAGE(STATUS "LIBSSL was not found.")
    ENDIF()
  ENDIF()

ENDIF()


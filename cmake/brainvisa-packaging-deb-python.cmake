find_package( python REQUIRED )

macro( python_INFO )
  set( BRAINVISA_PACKAGE_NAME brainvisa-python )
  set( BRAINVISA_PACKAGE_MAIN_PROJECT brainvisa )
  set( BRAINVISA_PACKAGE_MAINTAINER "IFR 49 - CEA" )
  set( BRAINVISA_PACKAGE_VERSION "${PYTHON_VERSION}" )
  set( ${BRAINVISA_PACKAGE_NAME}_VERSION "${BRAINVISA_PACKAGE_VERSION}" )
endmacro()


function( BRAINVISA_PACKAGING_RUN pack_type dependency_type component component_pack_type version_ranges binary_independent )
  python_INFO()

  set( deb_package "${component}" PARENT_SCOPE )
  set( deb_version_ranges "${version_ranges}" PARENT_SCOPE )


  list( FIND BRAINVISA_THIRDPARTY_COMPONENTS "${BRAINVISA_PACKAGE_NAME}" result )
  if( result EQUAL -1 )
    set( BRAINVISA_THIRDPARTY_COMPONENTS ${BRAINVISA_THIRDPARTY_COMPONENTS} "${BRAINVISA_PACKAGE_NAME}" CACHE STRING INTERNAL FORCE )
    BRAINVISA_ADD_COMPONENT( ${BRAINVISA_PACKAGE_NAME}
                              GROUP runtime
                              DESCRIPTION "runtime files for ${BRAINVISA_PACKAGE_NAME}" )
            
    BRAINVISA_INSTALL( FILES "${PYTHON_EXECUTABLE}"
      DESTINATION "bin"
      COMPONENT "${BRAINVISA_PACKAGE_NAME}" )
    BRAINVISA_INSTALL( FILES "${PYTHON_LIBRARY}"
      DESTINATION "lib"
      COMPONENT "${BRAINVISA_PACKAGE_NAME}" )
    BRAINVISA_INSTALL_DIRECTORY( "${PYTHON_MODULES_PATH}" "python" "${BRAINVISA_PACKAGE_NAME}" )

    CREATE_RUN_PACKAGE()
  endif()
endfunction()


function( BRAINVISA_PACKAGING_DEV pack_type dependency_type component component_pack_type version_ranges binary_independent )
  python_INFO()

  set( deb_package "${component}-dev" PARENT_SCOPE )
  set( deb_version_ranges "${version_ranges}" PARENT_SCOPE )

  list( FIND BRAINVISA_THIRDPARTY_COMPONENTS "${BRAINVISA_PACKAGE_NAME}-dev" result )
  if( result EQUAL -1 )
    set( BRAINVISA_THIRDPARTY_COMPONENTS ${BRAINVISA_THIRDPARTY_COMPONENTS} "${BRAINVISA_PACKAGE_NAME}-dev" CACHE STRING INTERNAL FORCE )

    BRAINVISA_ADD_COMPONENT( ${BRAINVISA_PACKAGE_NAME}-devel
                              GROUP devel
                              DESCRIPTION "Developpement files for ${BRAINVISA_PACKAGE_NAME}" )
    BRAINVISA_INSTALL_DIRECTORY( "${PYTHON_INCLUDE_PATH}"
                                "include"
                                ${BRAINVISA_PACKAGE_NAME}-devel )
    
    CREATE_DEV_PACKAGE()
  endif()
endfunction()


function( BRAINVISA_PACKAGING_DOC )
endfunction()


function( BRAINVISA_PACKAGING_DEVDOC )
endfunction()


function( BRAINVISA_PACKAGING_SRC )
endfunction()

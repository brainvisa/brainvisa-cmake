find_package( python REQUIRED )

macro( DO_deb_DEPENDENCIES_python pack_type dependency_type component component_pack_type version_ranges binary_independent )
  unset( deb_package )
  set( deb_version_ranges "${version_ranges}" )
  if( "${component_pack_type}" STREQUAL "RUN" )
    set( deb_package "${component}" )
  elseif( "${component_pack_type}" STREQUAL "DEV" )
    set( deb_package "${component}-dev" )
  elseif( "${component_pack_type}" STREQUAL "SRC" )
    set( deb_package "${component}-src" )
  elseif( "${component_pack_type}" STREQUAL "DOC" )
    set( deb_package "${component}-doc" )
  elseif( "${component_pack_type}" STREQUAL "DEVDOC" )
    set( deb_package "${component}-doc" )
  else()
    message( SEND_ERROR "${component} does not have debian package type \"${component_pack_type}\"" )
  endif()
  
  if( "${component_pack_type}" STREQUAL "RUN" )
    set( BRAINVISA_PACKAGE_NAME brainvisa-python )
    set( BRAINVISA_PACKAGE_MAIN_PROJECT brainvisa-cmake )
    set( BRAINVISA_PACKAGE_MAINTAINER "IFR 49 - CEA" )
    set( BRAINVISA_PACKAGE_VERSION_MAJOR ${brainvisa-cmake_VERSION_MAJOR} )
    set( BRAINVISA_PACKAGE_VERSION_MINOR ${brainvisa-cmake_VERSION_MINOR} )
    set( BRAINVISA_PACKAGE_VERSION_PATCH ${brainvisa-cmake_VERSION_PATCH} )
    BRAINVISA_ADD_COMPONENT( ${BRAINVISA_PACKAGE_NAME}
                            GROUP runtime
                            DESCRIPTION "runtime files for ${BRAINVISA_PACKAGE_NAME}" )
  
    #include( "${brainvisa-cmake_DIR}/packaging-${BRAINVISA_PACKAGE_TYPE}.cmake" )
  endif()
endmacro()


set( BRAINVISA_PACKAGING_TEMPORARY_DIRECTORY "/tmp" CACHE PATH "Temporary directory used to create packages" )

function( GET_DEBIAN_PACKAGE_NAME package_name )
  string( REPLACE "_" "-" DEBIAN_PACKAGE_NAME "${package_name}" )
  set( DEBIAN_PACKAGE_NAME "${DEBIAN_PACKAGE_NAME}" PARENT_SCOPE )
endfunction()

function( GET_DEBIAN_ARCHITECTURE )
  execute_process( COMMAND apt-config dump RESULT_VARIABLE result OUTPUT_VARIABLE output )
  if( result GREATER -1 )
    string( REGEX MATCH "APT::Architecture \"([^;]*)\";" match "${output}" )
    if( match )
      set( DEBIAN_ARCHITECTURE ${CMAKE_MATCH_1} PARENT_SCOPE )
    else()
      set( DEBIAN_ARCHITECTURE "${CMAKE_SYSTEM_PROCESSOR}" PARENT_SCOPE )
    endif()
  else()
    set( DEBIAN_ARCHITECTURE "${CMAKE_SYSTEM_PROCESSOR}" PARENT_SCOPE )
  endif()
endfunction()


macro( CREATE_RUN_PACKAGE )
  GET_DEBIAN_PACKAGE_NAME( ${BRAINVISA_PACKAGE_NAME} )
  GET_DEBIAN_ARCHITECTURE()
  set( DEB_RUN_DEPENDENCIES )
  if( ${BRAINVISA_PACKAGE_NAME}_DEB_RUN_DEPENDS )
    string( REPLACE ";" "," dependencies "${${BRAINVISA_PACKAGE_NAME}_DEB_RUN_DEPENDS}" )
    set( DEB_RUN_DEPENDENCIES "${DEB_RUN_DEPENDENCIES}Depends: ${dependencies}\n" )
  endif()
  if( ${BRAINVISA_PACKAGE_NAME}_DEB_RUN_RECOMMENDS )
    string( REPLACE ";" "," dependencies "${${BRAINVISA_PACKAGE_NAME}_DEB_RUN_RECOMMENDS}" )
    set( DEB_RUN_DEPENDENCIES "${DEB_RUN_DEPENDENCIES}Recommends: ${dependencies}\n" )
  endif()
  if( ${BRAINVISA_PACKAGE_NAME}_DEB_RUN_SUGGESTS )
    string( REPLACE ";" "," dependencies "${${BRAINVISA_PACKAGE_NAME}_DEB_RUN_SUGGESTS}" )
    set( DEB_RUN_DEPENDENCIES "${DEB_RUN_DEPENDENCIES}Suggests: ${dependencies}\n" )
  endif()
  if( ${BRAINVISA_PACKAGE_NAME}_DEB_RUN_ENHANCES )
    string( REPLACE ";" "," dependencies "${${BRAINVISA_PACKAGE_NAME}_DEB_RUN_ENHANCES}" )
    set( DEB_RUN_DEPENDENCIES "${DEB_RUN_DEPENDENCIES}Enhances: ${dependencies}\n" )
  endif()
  
  configure_file( "${brainvisa-cmake_DIR}/debian-control-run.in"
                  "${CMAKE_BINARY_DIR}/debian/control-${BRAINVISA_PACKAGE_NAME}-run" 
                  @ONLY )

  set( _tmpDir "${BRAINVISA_PACKAGING_TEMPORARY_DIRECTORY}/brainvisa-cmake_${BRAINVISA_PACKAGE_NAME}" )
  set( _packageNameRun "${CMAKE_BINARY_DIR}/${BRAINVISA_PACKAGE_NAME}-${BRAINVISA_PACKAGE_VERSION}-${BRAINVISA_PACKAGE_SUFFIX}.deb" )

  add_custom_command( OUTPUT "${_packageNameRun}"
    COMMENT "Creating package \"${_packageNameRun}\""
    COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}/DEBIAN"
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/debian/control-${BRAINVISA_PACKAGE_NAME}-run" "${_tmpDir}/DEBIAN/control"
    COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}${CMAKE_INSTALL_PREFIX}" -DCOMPONENT=${BRAINVISA_PACKAGE_NAME} -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
    COMMAND dpkg --build "${_tmpDir}" "${_packageNameRun}"
    COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
  )
  add_custom_target( "${BRAINVISA_PACKAGE_NAME}-package-run"
    DEPENDS "${_packageNameRun}" )
endmacro()


macro( CREATE_DEV_PACKAGE )
  GET_DEBIAN_PACKAGE_NAME( ${BRAINVISA_PACKAGE_NAME} )
  GET_DEBIAN_ARCHITECTURE()
  set( DEB_DEV_DEPENDENCIES )
  if( ${BRAINVISA_PACKAGE_NAME}_DEB_DEV_DEPENDS )
    string( REPLACE ";" "," dependencies "${${BRAINVISA_PACKAGE_NAME}_DEB_DEV_DEPENDS}" )
    set( DEB_DEV_DEPENDENCIES "${DEB_DEV_DEPENDENCIES}Depends: ${dependencies}\n" )
  endif()
  if( ${BRAINVISA_PACKAGE_NAME}_DEB_DEV_RECOMMENDS )
    string( REPLACE ";" "," dependencies "${${BRAINVISA_PACKAGE_NAME}_DEB_DEV_RECOMMENDS}" )
    set( DEB_DEV_DEPENDENCIES "${DEB_DEV_DEPENDENCIES}Recommends: ${dependencies}\n" )
  endif()
  if( ${BRAINVISA_PACKAGE_NAME}_DEB_DEV_SUGGESTS )
    string( REPLACE ";" "," dependencies "${${BRAINVISA_PACKAGE_NAME}_DEB_DEV_SUGGESTS}" )
    set( DEB_DEV_DEPENDENCIES "${DEB_DEV_DEPENDENCIES}Suggests: ${dependencies}\n" )
  endif()
  if( ${BRAINVISA_PACKAGE_NAME}_DEB_DEV_ENHANCES )
    string( REPLACE ";" "," dependencies "${${BRAINVISA_PACKAGE_NAME}_DEB_DEV_ENHANCES}" )
    set( DEB_DEV_DEPENDENCIES "${DEB_DEV_DEPENDENCIES}Enhances: ${dependencies}\n" )
  endif()
  
  configure_file( "${brainvisa-cmake_DIR}/debian-control-dev.in"
                  "${CMAKE_BINARY_DIR}/debian/control-${BRAINVISA_PACKAGE_NAME}-dev" 
                  @ONLY )

  set( _tmpDir "${BRAINVISA_PACKAGING_TEMPORARY_DIRECTORY}/brainvisa-cmake_${BRAINVISA_PACKAGE_NAME}" )
  set( _packageNameDev "${CMAKE_BINARY_DIR}/${BRAINVISA_PACKAGE_NAME}-dev-${BRAINVISA_PACKAGE_VERSION}-${BRAINVISA_PACKAGE_SUFFIX}.deb" )

  add_custom_command( OUTPUT "${_packageNameDev}"
    COMMENT "Creating package \"${_packageNameDev}\""
    COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}-dev"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}-dev"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}-dev/DEBIAN"
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/debian/control-${BRAINVISA_PACKAGE_NAME}-dev" "${_tmpDir}-dev/DEBIAN/control"
    COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}-dev${CMAKE_INSTALL_PREFIX}" -DCOMPONENT=${BRAINVISA_PACKAGE_NAME}-devel -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
    COMMAND dpkg --build "${_tmpDir}-dev" "${_packageNameDev}"
    COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}-dev"
  )
  add_custom_target( "${BRAINVISA_PACKAGE_NAME}-package-dev"
    DEPENDS "${_packageNameDev}" )
endmacro()


macro( CREATE_DOC_PACKAGE )
endmacro()


macro( CREATE_DEVDOC_PACKAGE )
endmacro()


macro( CREATE_SRC_PACKAGE )
endmacro()

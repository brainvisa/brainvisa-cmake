foreach( package_type RUN DEV DOC SRC )
  set( DEB_${package_type}_DEPENDENCIES )
  if( ${BRAINVISA_PACKAGE_NAME}_DEB_${package_type}_DEPENDS )
    string( REPLACE ";" "," dependencies "${${BRAINVISA_PACKAGE_NAME}_DEB_${package_type}_DEPENDS}" )
    set( DEB_${package_type}_DEPENDENCIES "${DEB_${package_type}_DEPENDENCIES}Depends: ${dependencies}\n" )
  endif()
  if( ${BRAINVISA_PACKAGE_NAME}_DEB_${package_type}_RECOMMENDS )
    string( REPLACE ";" "," dependencies "${${BRAINVISA_PACKAGE_NAME}_DEB_${package_type}_RECOMMENDS}" )
    set( DEB_${package_type}_DEPENDENCIES "${DEB_${package_type}_DEPENDENCIES}Recommends: ${dependencies}\n" )
  endif()
  if( ${BRAINVISA_PACKAGE_NAME}_DEB_${package_type}_SUGGESTS )
    string( REPLACE ";" "," dependencies "${${BRAINVISA_PACKAGE_NAME}_DEB_${package_type}_SUGGESTS}" )
    set( DEB_${package_type}_DEPENDENCIES "${DEB_${package_type}_DEPENDENCIES}Suggests: ${dependencies}\n" )
  endif()
  if( ${BRAINVISA_PACKAGE_NAME}_DEB_${package_type}_ENHANCES )
    string( REPLACE ";" "," dependencies "${${BRAINVISA_PACKAGE_NAME}_DEB_${package_type}_ENHANCES}" )
    set( DEB_${package_type}_DEPENDENCIES "${DEB_${package_type}_DEPENDENCIES}Enhances: ${dependencies}\n" )
  endif()
endforeach()

configure_file( "${brainvisa-cmake_DIR}/debian-control-run.in"
                "${CMAKE_BINARY_DIR}/debian/control-${BRAINVISA_PACKAGE_NAME}-run" 
                @ONLY )
configure_file( "${brainvisa-cmake_DIR}/debian-control-dev.in"
                "${CMAKE_BINARY_DIR}/debian/control-${BRAINVISA_PACKAGE_NAME}-dev" 
                @ONLY )


set( BRAINVISA_PACKAGING_TEMPORARY_DIRECTORY "/tmp" CACHE PATH "Temporary directory used to create packages" )
set( _tmpDir "${BRAINVISA_PACKAGING_TEMPORARY_DIRECTORY}/brainvisa-cmake_${BRAINVISA_PACKAGE_NAME}" )
set( _packageSuffix "${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}" )
set( _packageNameRun "${CMAKE_BINARY_DIR}/${BRAINVISA_PACKAGE_NAME}-${${BRAINVISA_PACKAGE_NAME}_VERSION}-${_packageSuffix}.deb" )
set( _packageNameDev "${CMAKE_BINARY_DIR}/${BRAINVISA_PACKAGE_NAME}-dev-${${BRAINVISA_PACKAGE_NAME}_VERSION}-${_packageSuffix}.deb" )

add_custom_command( OUTPUT "${_packageNameRun}"
  COMMENT "Creating package \"${_packageNameRun}\""
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}/DEBIAN"
  COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/debian/control-${BRAINVISA_PACKAGE_NAME}-run" "${_tmpDir}/DEBIAN/control"
  COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}" -DCOMPONENT=${BRAINVISA_PACKAGE_NAME} -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
  COMMAND dpkg --build "${_tmpDir}" "${_packageNameRun}"
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
)
add_custom_target( "${BRAINVISA_PACKAGE_NAME}-package-run"
  DEPENDS "${_packageNameRun}" )


add_custom_command( OUTPUT "${_packageNameDev}"
  COMMENT "Creating package \"${_packageNameDev}\""
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}-dev"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}-dev"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}-dev/DEBIAN"
  COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/debian/control-${BRAINVISA_PACKAGE_NAME}-dev" "${_tmpDir}-dev/DEBIAN/control"
  COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}-dev" -DCOMPONENT=${BRAINVISA_PACKAGE_NAME}-devel -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
  COMMAND dpkg --build "${_tmpDir}-dev" "${_packageNameDev}"
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}-dev"
)
add_custom_target( "${BRAINVISA_PACKAGE_NAME}-package-dev"
  DEPENDS "${_packageNameDev}" )


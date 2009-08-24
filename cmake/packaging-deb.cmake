configure_file( "${brainvisa-cmake_DIR}/debian-control-run.in"
                "${CMAKE_BINARY_DIR}/debian/control-${PROJECT_NAME}-run" 
                @ONLY )
configure_file( "${brainvisa-cmake_DIR}/debian-control-dev.in"
                "${CMAKE_BINARY_DIR}/debian/control-${PROJECT_NAME}-dev" 
                @ONLY )


set( BRAINVISA_PACKAGING_TEMPORARY_DIRECTORY "/tmp" CACHE PATH "Temporary directory used to create packages" )
set( _tmpDir "${BRAINVISA_PACKAGING_TEMPORARY_DIRECTORY}/brainvisa-cmake_${PROJECT_NAME}" )
set( _packageSuffix "${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}" )
set( _packageNameRun "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${${PROJECT_NAME}_VERSION}-${_packageSuffix}.deb" )
set( _packageNameDev "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-dev-${${PROJECT_NAME}_VERSION}-${_packageSuffix}.deb" )

add_custom_command( OUTPUT "${_packageNameRun}"
  COMMENT "Creating package \"${_packageNameRun}\""
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}/DEBIAN"
  COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/debian/control-${PROJECT_NAME}-run" "${_tmpDir}/DEBIAN/control"
  COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}" -DCOMPONENT=${PROJECT_NAME} -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
  COMMAND dpkg --build "${_tmpDir}" "${_packageNameRun}"
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
)
add_custom_target( "${PROJECT_NAME}-package-run"
  DEPENDS "${_packageNameRun}" )


add_custom_command( OUTPUT "${_packageNameDev}"
  COMMENT "Creating package \"${_packageNameDev}\""
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}-dev"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}-dev"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}-dev/DEBIAN"
  COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/debian/control-${PROJECT_NAME}-dev" "${_tmpDir}-dev/DEBIAN/control"
  COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}-dev" -DCOMPONENT=${PROJECT_NAME}-devel -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
  COMMAND dpkg --build "${_tmpDir}-dev" "${_packageNameDev}"
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}-dev"
)
add_custom_target( "${PROJECT_NAME}-package-dev"
  DEPENDS "${_packageNameDev}" )


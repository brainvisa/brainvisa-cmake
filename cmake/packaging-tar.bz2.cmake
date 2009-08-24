set( BRAINVISA_PACKAGING_TEMPORARY_DIRECTORY "/tmp" CACHE PATH "Temporary directory used to create packages" )
set( _tmpDir "${BRAINVISA_PACKAGING_TEMPORARY_DIRECTORY}/brainvisa-cmake_${PROJECT_NAME}" )
set( _packageSuffix "${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}" )
set( _packageNameRun "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-${${PROJECT_NAME}_VERSION}-${_packageSuffix}.tar.bz2" )
set( _packageNameDev "${CMAKE_BINARY_DIR}/${PROJECT_NAME}-dev-${${PROJECT_NAME}_VERSION}-${_packageSuffix}.tar.bz2" )

add_custom_command( OUTPUT "${_packageNameRun}"
  COMMENT "Creating package \"${_packageNameRun}\""
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}/DEBIAN"
  COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}" -DCOMPONENT=${PROJECT_NAME} -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
  COMMAND tar "--directory=${_tmpDir}" -jcf "${_packageNameRun}" .
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}"
)
add_custom_target( "${PROJECT_NAME}-package-run"
  DEPENDS "${_packageNameRun}" )


add_custom_command( OUTPUT "${_packageNameDev}"
  COMMENT "Creating package \"${_packageNameDev}\""
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}-dev"
  COMMAND ${CMAKE_COMMAND} -E make_directory "${_tmpDir}-dev"
  COMMAND ${CMAKE_COMMAND} "-DCMAKE_INSTALL_PREFIX=${_tmpDir}-dev" -DCOMPONENT=${PROJECT_NAME}-devel -P "${CMAKE_BINARY_DIR}/cmake_install.cmake"
  COMMAND tar "--directory=${_tmpDir}-dev" -jcf "${_packageNameDev}" .
  COMMAND ${CMAKE_COMMAND} -E remove_directory "${_tmpDir}-dev"
)
add_custom_target( "${PROJECT_NAME}-package-dev"
  DEPENDS "${_packageNameDev}" )


find_package( Qt4 COMPONENTS Qt3Support REQUIRED )

function( BRAINVISA_PACKAGING_COMPONENT_INFO package_name package_maintainer package_version )
  set( ${package_name} brainvisa-libqt4-qt3support PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    BRAINVISA_FIND_RUNTIME_LIBRARIES(libs ${QT_QT3SUPPORT_LIBRARY_DEBUG})
  else()
    BRAINVISA_FIND_RUNTIME_LIBRARIES(libs ${QT_QT3SUPPORT_LIBRARY_RELEASE})
  endif()
  BRAINVISA_INSTALL( FILES ${libs}
    DESTINATION "lib"
    COMPONENT "${component}" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  BRAINVISA_INSTALL_DIRECTORY( "${QT_QT3SUPPORT_INCLUDE_DIR}"
                              "include/Qt3Support"
                              "${component}-devel" )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_DEVDOC component )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_SRC component )
endfunction()

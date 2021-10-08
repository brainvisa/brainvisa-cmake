find_package( brainvisa-cmake REQUIRED )

function( BRAINVISA_GLOB_AND_FILTER glob variable )
  file( ${glob} allFiles ${ARGN} )
  set( result )
  foreach( f ${allFiles} )
    get_filename_component( n "${f}" NAME )
    if ( NOT IS_DIRECTORY "${f}" AND NOT n STREQUAL ".svn" )
      set( result ${result} "${f}" )
    endif ()
  endforeach()
  set( ${variable} ${result} PARENT_SCOPE )
endfunction()



set( brainvisa-cmake_INSTALL_PREFIX "share/brainvisa-cmake-${brainvisa-cmake_VERSION_MAJOR}.${brainvisa-cmake_VERSION_MINOR}" )

# configure_file( cmake/brainvisa-cmake-config-version.cmake.in
#                 "${brainvisa-cmake_INSTALL_PREFIX}/cmake/brainvisa-cmake-config-version.cmake"
#                 @ONLY )
install( FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/brainvisa-cmake-config.cmake
              #  "${CMAKE_BINARY_DIR}/${brainvisa-cmake_INSTALL_PREFIX}/cmake/brainvisa-cmake-config-version.cmake"
         DESTINATION "${brainvisa-cmake_INSTALL_PREFIX}/cmake"
         COMPONENT brainvisa-cmake )
configure_file( version.py.in
                "python/brainvisa/maker/version.py"
                @ONLY )
install( FILES "${CMAKE_BINARY_DIR}/python/brainvisa/maker/version.py"
         DESTINATION "python/brainvisa/maker"
         COMPONENT brainvisa-cmake )

if( DESIRED_QT_VERSION )
  add_definitions( -DDESIRED_QT_VERSION=${DESIRED_QT_VERSION} )
endif()

install( DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/python"
         DESTINATION "."
         USE_SOURCE_PERMISSIONS
         COMPONENT brainvisa-cmake
         PATTERN "*~" EXCLUDE )


# install( DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/etc"
#          DESTINATION "."
#          USE_SOURCE_PERMISSIONS
#          COMPONENT brainvisa-cmake
#          PATTERN ".svn" EXCLUDE
#          PATTERN "*~" EXCLUDE )

# if(NOT CPack_CMake_INCLUDED)
#   include( CPack )
# endif()

# if( NOT TARGET install-runtime )
#   cpack_add_component_group( runtime
#                              DISPLAY_NAME "Runtime"
#                              DESCRIPTION "All elements necessary to use ${PROJECT_NAME} at runtime without developpement files such as C++ headers." )
#   add_custom_target( install-runtime )
# endif()

# if( NOT TARGET install-${PROJECT_NAME} )
#   cpack_add_component( ${PROJECT_NAME} )
#   add_custom_target( install-${PROJECT_NAME}
#                      COMMAND if [ -n "$(BRAINVISA_INSTALL_PREFIX)" ] \; then "${CMAKE_COMMAND}" -DCMAKE_INSTALL_PREFIX="$(BRAINVISA_INSTALL_PREFIX)" -DCOMPONENT=${PROJECT_NAME} -P "${CMAKE_BINARY_DIR}/build_files/${PROJECT_NAME}/cmake_install.cmake" \; else "${CMAKE_COMMAND}" -DCOMPONENT=${PROJECT_NAME} -P "${CMAKE_BINARY_DIR}/build_files/${PROJECT_NAME}/cmake_install.cmake" \; fi )
#   add_dependencies( install-runtime install-${PROJECT_NAME} )
# endif()


       
  find_package( Sphinx )
  find_package( python )

  BRAINVISA_GENERATE_SPHINX_DOC( "doc/sphinx"
    "share/doc/${PROJECT_NAME}-${brainvisa-cmake_VERSION_MAJOR}.${brainvisa-cmake_VERSION_MINOR}" USER )


# Set default Qt desired version
set( DESIRED_QT_VERSION 4 CACHE STRING "Pick a version of QT to use: 3 or 4" )

if( BRAINVISA_PACKAGING )
  set( BRAINVISA_THIRDPARTY_COMPONENTS "" CACHE INTERNAL "" )
endif()

BRAINVISA_CREATE_MAIN_COMPONENTS()
  
foreach( component ${BRAINVISA_COMPONENTS} )
  if( BRAINVISA_SOURCES_${component} )
    set( ${component}_IS_BEING_COMPILED TRUE CACHE BOOL INTERNAL )
    message( STATUS "Configuring component ${component} from source directory \"${BRAINVISA_SOURCES_${component}}\"" )
    if( component STREQUAL brainvisa-cmake )
      file( MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/build_files/${component}" )
      execute_process( COMMAND "${CMAKE_COMMAND}" "-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}" "${BRAINVISA_SOURCES_${component}}"
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/build_files/${component}" )
      execute_process( COMMAND "${CMAKE_BUILD_TOOL}" install
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/build_files/${component}" )
    else()
      add_subdirectory( "${BRAINVISA_SOURCES_${component}}" "build_files/${component}" )
    endif()
  endif()
endforeach()

if( BRAINVISA_DEPENDENCY_GRAPH )
  file( APPEND "${BRAINVISA_DEPENDENCY_GRAPH}" "}\n" )
endif()


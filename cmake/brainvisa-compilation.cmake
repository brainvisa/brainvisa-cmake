# Set default Qt desired version
set( DESIRED_QT_VERSION 4 CACHE STRING "Pick a version of QT to use: 3 or 4" )

set( BRAINVISA_BVMAKER True )

set( CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "${CMAKE_BINARY_DIR}" )
include_directories( "${CMAKE_BINARY_DIR}/include" )

if( BRAINVISA_DEPENDENCY_GRAPH )
  set( BRAINVISA_THIRDPARTY_COMPONENTS "" CACHE INTERNAL "" )
endif()

BRAINVISA_CREATE_MAIN_COMPONENTS()
  
foreach( component ${BRAINVISA_COMPONENTS} )
  if( BRAINVISA_SOURCES_${component} )
    set( ${component}_IS_BEING_COMPILED TRUE CACHE BOOL INTERNAL )
    if( EXISTS "${BRAINVISA_SOURCES_${component}}/broken_component.log" )
      message( "WARNING: Component ${component} is ignored because its compilation was not possible. When the problem is fixed, the component can be reactivated by removing \"${BRAINVISA_SOURCES_${component}}/broken_component.log\"" )
    else()
      message( STATUS "Configuring component ${component} from source directory \"${BRAINVISA_SOURCES_${component}}\"" )
      if( component STREQUAL brainvisa-cmake )
        file( MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/build_files/${component}" )
        execute_process( COMMAND "${CMAKE_COMMAND}" "-G" "${CMAKE_GENERATOR}" "-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}" "${BRAINVISA_SOURCES_${component}}"
          WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/build_files/${component}"
          OUTPUT_QUIET 
          ERROR_QUIET )
        execute_process( COMMAND "${CMAKE_BUILD_TOOL}" install
          WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/build_files/${component}"
          OUTPUT_QUIET 
          ERROR_QUIET )
      else()
        add_subdirectory( "${BRAINVISA_SOURCES_${component}}" "build_files/${component}" )
      endif()
    endif()
  endif()
endforeach()

if( BRAINVISA_DEPENDENCY_GRAPH )
  file( APPEND "${BRAINVISA_DEPENDENCY_GRAPH}" "}\n" )
endif()


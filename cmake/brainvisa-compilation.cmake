if( EXISTS "${CMAKE_BINARY_DIR}/bv_maker.cmake" )
  include( "${CMAKE_BINARY_DIR}/bv_maker.cmake" )
  foreach( component ${BRAINVISA_COMPONENTS} )
    file( GLOB _share_list "${CMAKE_BINARY_DIR}/share/${component}-*" )
    foreach( _share ${_share_list} )
      if( NOT "${_share}/cmake" STREQUAL "${${component}_DIR}" )
        message( "WARNING: removing \"${_share}\" directory to avoid confusion with \"${${component}_DIR}\"" )
        execute_process( COMMAND "${CMAKE_COMMAND}" -E remove_directory "${_share}" )
      endif()
    endforeach()
  endforeach()
endif()

# Set default Qt desired version
set( DESIRED_QT_VERSION 4 CACHE STRING "Pick a version of QT to use: 3 or 4" )

set( BRAINVISA_BVMAKER True )

set( CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "${CMAKE_BINARY_DIR}" )
include_directories( "${CMAKE_BINARY_DIR}/include" )

if( BRAINVISA_DEPENDENCY_GRAPH )
  set( BRAINVISA_THIRDPARTY_COMPONENTS "" CACHE INTERNAL "" )
endif()

BRAINVISA_CREATE_MAIN_COMPONENTS()

function( silent_execute_process working_directory )
  execute_process( COMMAND ${ARGN}
    WORKING_DIRECTORY "${working_directory}"
    RESULT_VARIABLE result
    OUTPUT_QUIET 
    ERROR_QUIET )
  if( NOT result EQUAL 0 )
    set( command )
    foreach( i ${ARGN} )
      set( command "${command} \"${i}\"" )
    endforeach()
    message( "ERROR: command failed:${command}" )
    message( "       working directory = \"${working_directory}\"" )
    message( "---------- command output ----------"  )
    execute_process( COMMAND ${ARGN} WORKING_DIRECTORY "${working_directory}" )
    message( "---------- end of command output ----------"  )
    message( FATAL_ERROR )
  endif()
endfunction()

# First pass to configure brainvisa-cmake component    
list( FIND BRAINVISA_COMPONENTS brainvisa-cmake where )
if( where GREATER -1 )
  set( component brainvisa-cmake )
  if( BRAINVISA_SOURCES_${component} )
    set( ${component}_IS_BEING_COMPILED TRUE CACHE BOOL INTERNAL )
    message( STATUS "Configuring component ${component} from source directory \"${BRAINVISA_SOURCES_${component}}\"" )
    file( MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/build_files/${component}" )
    silent_execute_process( "${CMAKE_BINARY_DIR}/build_files/${component}" "${CMAKE_COMMAND}" "-G" "${CMAKE_GENERATOR}" "-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_BINARY_DIR}" "${BRAINVISA_SOURCES_${component}}" )
    silent_execute_process( "${CMAKE_BINARY_DIR}/build_files/${component}" "${CMAKE_BUILD_TOOL}" install )
    set_property( GLOBAL PROPERTY BRAINVISA_CMAKE_CONFIG_DONE )
    unset( brainvisa-cmake_DIR CACHE )
    unset( brainvisa-cmake_DIR )
  endif()
endif()

message( "!!!!2!!!! CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH}" )
message( "!!!!2!!!! brainvisa-cmake_DIR ${brainvisa-cmake_DIR}" )

# Second pass to configure all other components
foreach( component ${BRAINVISA_COMPONENTS} )
  if( NOT component STREQUAL brainvisa-cmake )
    if( BRAINVISA_SOURCES_${component} )
      set( ${component}_IS_BEING_COMPILED TRUE CACHE BOOL INTERNAL )
      if( EXISTS "${BRAINVISA_SOURCES_${component}}/broken_component.log" )
        message( "WARNING: Component ${component} is ignored because its compilation was not possible. When the problem is fixed, the component can be reactivated by removing \"${BRAINVISA_SOURCES_${component}}/broken_component.log\"" )
      else()
        message( STATUS "Configuring component ${component} from source directory \"${BRAINVISA_SOURCES_${component}}\"" )
        add_subdirectory( "${BRAINVISA_SOURCES_${component}}" "build_files/${component}" )
      endif()
    endif()
  endif()
endforeach()

if( BRAINVISA_DEPENDENCY_GRAPH )
  file( APPEND "${BRAINVISA_DEPENDENCY_GRAPH}" "}\n" )
endif()

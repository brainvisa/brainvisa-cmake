find_package( brainvisa-cmake REQUIRED )

function( BRAINVISA_FIND_COMPONENT_SOURCES project component )
  if( NOT project )
    set( project ${component} )
  endif()
  set( current_version )
  set( current_sources )
  message( STATUS "looking for ${component} sources directory" )
  foreach( path ${BRAINVISA_SOURCES} )
    message( STATUS "  recursively finding project_info.cmake in \"${path}/${project}\" " )
    file( GLOB_RECURSE projects_info "${path}/${project}/project_info.cmake" )
    foreach( info ${projects_info} )
      get_filename_component( sources_dir "${info}" PATH )
      get_filename_component( branch "${sources_dir}" NAME )
      if( "${branch}" STREQUAL "trunk" )
        set( version_type "trunk" )
      else()
        get_filename_component( tmp "${sources_dir}" PATH )
        get_filename_component( branch_type "${tmp}" NAME )
        if( "${branch_type}" STREQUAL "branches" )
          set( version_type "stable" )
        elseif( "${branch_type}" STREQUAL "tags" )
          set( version_type "tag" )
         else()
           set( version_type "unknown" )
        endif()
      endif()

      include( "${info}" )
      
      message( STATUS "  found ${BRAINVISA_PACKAGE_NAME} version ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH} (${version_type}) in \"${sources_dir}\"." )

      set( version_types stable trunk tag )
      list( FIND version_types "${BRAINVISA_SOURCES_${component}}" result )
      if( NOT result EQUAL -1 )
        set( version_selection ${BRAINVISA_SOURCES_${component}} )
      elseif( BRAINVISA_VERSION_SELECTION_${project} )
        set( version_selection ${BRAINVISA_VERSION_SELECTION_${project}} )
      else()
        set( version_selection ${BRAINVISA_VERSION_SELECTION} )
      endif()
      if( "${component}" STREQUAL "${BRAINVISA_PACKAGE_NAME}" AND ( "${version_selection}" STREQUAL "${version_type}" OR "${version_type}" STREQUAL "unknown" ) )
        if( NOT current_version )
          message( STATUS "  --> selected because it is the first version found" )
          set( current_version "${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}" )
          set( current_sources ${sources_dir} )
        elseif( "${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}" VERSION_GREATER "${current_version}" )
          message( STATUS "  --> selected because version is newer than ${current_version}" )
          set( current_version "${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}" )
          set( current_sources ${sources_dir} )
        else()
          message( STATUS "  skipped because version is older than ${current_version}" )
        endif()
      else()
        message( STATUS "  ignored because component is not ${component} or version type is not ${version_selection}" )
      endif()
    endforeach()
    if( current_version )
      break()
    endif()
  endforeach()
  unset( BRAINVISA_SOURCES_${component} CACHE )
  if( current_version )
    set( BRAINVISA_SOURCES_${component} "${current_sources}" CACHE PATH "directory containing sources for component ${component}" )
    message( STATUS "selected sources for ${component} version ${current_version} are in \"${BRAINVISA_SOURCES_${component}}\"" )
  else()
    set( BRAINVISA_SOURCES_${component} "NOTFOUND" CACHE PATH "directory containing sources for component ${component}" )
    message( STATUS "sources for ${component} not found" )
  endif()
  mark_as_advanced( BRAINVISA_SOURCES_${component} )
  set( _BRAINVISA_SOURCES_${component} "${BRAINVISA_SOURCES_${component}}" CACHE INTERNAL "" )
endfunction()


set( CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "${CMAKE_BINARY_DIR}" )

# Set default Qt desired version
set( DESIRED_QT_VERSION 4 CACHE STRING "Pick a version of QT to use: 3 or 4" )

if( NOT DEFINED BRAINVISA_SOURCES )
  file( TO_CMAKE_PATH "$ENV{BRAINVISA_SOURCES}" BRAINVISA_SOURCES )
  set( BRAINVISA_SOURCES "${BRAINVISA_SOURCES}" CACHE PATH "Directories where to look for sources." )
endif()

if( NOT DEFINED BRAINVISA_VERSION_SELECTION )
  set( BRAINVISA_VERSION_SELECTION stable CACHE STRING "Type of branch that is used for automatic sources selection. Possible values are \"trunk\", \"stable\" and \"tag\"." )
  set( _BRAINVISA_VERSION_SELECTION "${BRAINVISA_VERSION_SELECTION}" CACHE INTERNAL "" )
endif()

if( NOT BRAINVISA_SOURCES )
  message( FATAL_ERROR "BRAINVISA_SOURCES has not been defined, brainvsisa-cmake will not be able to find the projects source directories." )
endif()

include( "${brainvisa-cmake_DIR}/brainvisa-projects.cmake" )

set( stop NO )
set( reset_projects )
if( NOT DEFINED BRAINVISA_PROJECTS )
  set( reset_projects "${BRAINVISA_ALL_PROJECTS}" )
  set( stop YES )
  message( "BRAINVISA_PROJECTS had been set to its default value. Configuration had been canceled to allow you to eventually adjust projects list, version selection, Qt desired version, etc. Configuration must be restarted when done." )
elseif( NOT "${BRAINVISA_PROJECTS}" STREQUAL "${_BRAINVISA_PROJECTS}" )
  message( "BRAINVISA_PROJECTS changed, all components sources updated" )
  set( reset_projects "${BRAINVISA_PROJECTS}" )
endif()
if( NOT reset_projects AND NOT "${BRAINVISA_VERSION_SELECTION}" STREQUAL "${_BRAINVISA_VERSION_SELECTION}" )
  message( "BRAINVISA_VERSION_SELECTION changed, components list updated" )
  set( reset_projects "${BRAINVISA_PROJECTS}" )
  set( _BRAINVISA_VERSION_SELECTION "${BRAINVISA_VERSION_SELECTION}" CACHE INTERNAL "" )
endif()


if( reset_projects )
  unset( BRAINVISA_PROJECTS CACHE )
  unset( BRAINVISA_COMPONENTS CACHE )
  foreach( project ${reset_projects} )
    set( component_found NO )
    if( BRAINVISA_ALL_COMPONENTS_${project} )
      set( components "${BRAINVISA_ALL_COMPONENTS_${project}}" )
    else()
      set( components ${project} )
    endif()
    foreach( component ${components} )
      BRAINVISA_FIND_COMPONENT_SOURCES( ${project} ${component} )
      if( BRAINVISA_SOURCES_${component} )
        set( component_found YES )
        set( BRAINVISA_COMPONENTS ${BRAINVISA_COMPONENTS} ${component} )
      endif()
    endforeach()
    if( component_found )
      set( BRAINVISA_PROJECTS ${BRAINVISA_PROJECTS} ${project} )
    endif()
  endforeach()
  set( BRAINVISA_PROJECTS "${BRAINVISA_PROJECTS}" CACHE STRING "List of all projects that have at least one component to compile" FORCE )
  set( _BRAINVISA_PROJECTS "${BRAINVISA_PROJECTS}" CACHE INTERNAL "" )
  set( BRAINVISA_COMPONENTS ${BRAINVISA_COMPONENTS} CACHE STRING "List of all components to compile" FORCE )
  mark_as_advanced( BRAINVISA_COMPONENTS )
endif()

foreach( component ${BRAINVISA_COMPONENTS} )
  if( NOT DEFINED BRAINVISA_SOURCES_${component} OR ( BRAINVISA_SOURCES_${component} AND NOT IS_DIRECTORY "${BRAINVISA_SOURCES_${component}}" ) )
    BRAINVISA_FIND_COMPONENT_SOURCES( "${BRAINVISA_PROJECT_${component}}" ${component} )
    message( "BRAINVISA_SOURCES_${component} has been set to \"${BRAINVISA_SOURCES_${component}}\"" )
  endif()
endforeach()

if( stop )
  return()
endif()


if( BRAINVISA_PACKAGING )
  set( BRAINVISA_THIRDPARTY_COMPONENTS "" CACHE INTERNAL "" )
endif()

BRAINVISA_CREATE_MAIN_COMPONENTS()
  
foreach( component ${BRAINVISA_COMPONENTS} )
  if( BRAINVISA_SOURCES_${component} )
    set( ${component}_IS_BEING_COMPILED TRUE CACHE BOOL INTERNAL )
    message( STATUS "Configuring component ${component} from source directory \"${BRAINVISA_SOURCES_${component}}\"" )
    add_subdirectory( "${BRAINVISA_SOURCES_${component}}" "build_files/${component}" )
  endif()
endforeach()

if( BRAINVISA_DEPENDENCY_GRAPH )
  file( APPEND "${BRAINVISA_DEPENDENCY_GRAPH}" "}\n" )
endif()


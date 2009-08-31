

function( BRAINVISA_READ_COMPONENT_INFOS )
  if( "${ARGV0}" STREQUAL "QUIET" )
    set( verbose FALSE )
  else()
    set( verbose TRUE )
  endif()

  # Look for all project_info.cmake files in source trees
  set( projects_info )
  set( _all_projects )
  set( _default_projects )
  set( _default_components )
  foreach( dir ${BRAINVISA_SOURCES} )
    set( projects_info ${projects_info} "${dir}/project_info.cmake" )
  endforeach()
  file( GLOB_RECURSE projects_info ${projects_info} )
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
    # Check mandatory variables
    foreach( v BRAINVISA_PACKAGE_MAIN_PROJECT BRAINVISA_PACKAGE_NAME )
      if( NOT ${v} )
        message( SEND_ERROR "${v} not declared in \"${info}\"" )
      endif()
    endforeach()

    # Update complete projects list
    list( FIND _all_projects "${BRAINVISA_PACKAGE_MAIN_PROJECT}" result )
    if( result EQUAL -1 )
      set( _all_projects ${_all_projects} "${BRAINVISA_PACKAGE_MAIN_PROJECT}" )
      set( _components_${BRAINVISA_PACKAGE_MAIN_PROJECT} )
    endif()
    list( FIND _components_${BRAINVISA_PACKAGE_MAIN_PROJECT} "${BRAINVISA_PACKAGE_NAME}" result )
    if( result EQUAL -1 )
      set( _components_${BRAINVISA_PACKAGE_MAIN_PROJECT} ${_components_${BRAINVISA_PACKAGE_MAIN_PROJECT}} "${BRAINVISA_PACKAGE_NAME}" )
    endif()

    if( BRAINVISA_VERSION_SELECTION_${BRAINVISA_PACKAGE_MAIN_PROJECT} )
      set( version_selection "${BRAINVISA_VERSION_SELECTION_${BRAINVISA_PACKAGE_MAIN_PROJECT}}" )
    else()
      set( version_selection "${BRAINVISA_VERSION_SELECTION}" )
    endif()
    if( "${version_selection}" STREQUAL "${version_type}" )
      # Update default projects list
      list( FIND _default_projects "${BRAINVISA_PACKAGE_MAIN_PROJECT}" result )
      if( result EQUAL -1 )
        set( _default_projects ${_default_projects} "${BRAINVISA_PACKAGE_MAIN_PROJECT}" )
      endif()
    endif()
    
    set( defaultComponent FALSE )
    list( FIND BRAINVISA_PROJECTS "${BRAINVISA_PACKAGE_MAIN_PROJECT}" result )
    if( NOT result EQUAL -1 )
      # Two if statements because CMake does not seem to allow parentheses in conditions
      if( "${version_selection}" STREQUAL "${version_type}" OR "${version_type}" STREQUAL "unknown" )
        set( defaultComponent TRUE )
      endif()
    endif()
#     set( selectComponent FALSE )
#     list( FIND BRAINVISA_COMPONENTS "${BRAINVISA_PACKAGE_NAME}" result )
#     if( defaultComponent OR NOT result EQUAL -1 )
#       set( selectComponent TRUE )
#     endif()

    # Update components list
    if( defaultComponent )
      list( FIND _default_components "${BRAINVISA_PACKAGE_NAME}" result )
      if( result EQUAL -1 )
        set( _default_components ${_default_components} "${BRAINVISA_PACKAGE_NAME}" )
      endif()
    endif()

    if( defaultComponent )
      if( _version_${BRAINVISA_PACKAGE_NAME} )
        if( "${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}" VERSION_GREATER "${_version_${BRAINVISA_PACKAGE_NAME}}" )
          set( _version_${BRAINVISA_PACKAGE_NAME} "${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}" )
          set( _sources_${BRAINVISA_PACKAGE_NAME} "${sources_dir}" )
          if( verbose )
            message( STATUS "Selected newer ${BRAINVISA_PACKAGE_NAME} version ${_version_${BRAINVISA_PACKAGE_NAME}} in \"${sources_dir}\"." )
          endif()
        elseif( verbose )
          message( STATUS "Ignored older ${BRAINVISA_PACKAGE_NAME} version ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH} in \"${sources_dir}\"." )
        endif()
      else()
        set( _version_${BRAINVISA_PACKAGE_NAME} "${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}" )
        set( _sources_${BRAINVISA_PACKAGE_NAME} "${sources_dir}" )
        if( verbose )
          message( STATUS "Selected ${BRAINVISA_PACKAGE_NAME} version ${_version_${BRAINVISA_PACKAGE_NAME}} in \"${sources_dir}\"." )
        endif()
      endif()
    elseif( verbose )
      message( STATUS "Ignored ${BRAINVISA_PACKAGE_NAME} version ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH} in \"${sources_dir}\"." )
    endif()
  endforeach()

  # Export variables to parent scope
  set( _all_projects "${_all_projects}" PARENT_SCOPE )
  foreach( project ${_all_projects} )
#     message( "!set( _components_${project} ${_components_${project}} PARENT_SCOPE )!" )
    set( _components_${project} ${_components_${project}} PARENT_SCOPE )
  endforeach()
  set( _default_projects "${_default_projects}" PARENT_SCOPE )
  set( _default_components "${_default_components}" PARENT_SCOPE )
  foreach( component ${_default_components} )
    set( _sources_${component} "${_sources_${component}}" PARENT_SCOPE )
  endforeach()
endfunction()

set( CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "${CMAKE_BINARY_DIR}" )

set( stropProcessing FALSE )
if( NOT DEFINED BRAINVISA_SOURCES )
  file( TO_CMAKE_PATH "$ENV{BRAINVISA_SOURCES}" BRAINVISA_SOURCES )
  set( BRAINVISA_SOURCES "${BRAINVISA_SOURCES}" CACHE PATH "Directories where to look for sources." )
endif()

if( NOT DEFINED BRAINVISA_VERSION_SELECTION )
  set( BRAINVISA_VERSION_SELECTION trunk CACHE STRING "Type of branch that is used for automatic sources selection. Possible values are \"trunk\", \"stable\" and \"tag\"." )
  message( "BRAINVISA_VERSION_SELECTION has been set to its default value (\"${BRAINVISA_VERSION_SELECTION})\". Please check that this value is correct and launch the configuration again." )
  set( stopProcessing TRUE )
endif()

if( NOT BRAINVISA_SOURCES )
  message( FATAL_ERROR "BRAINVISA_SOURCES has not been defined, brainvsisa-cmake will not be able to find the projects source directories." )
endif()

# Build projects list
if( NOT BRAINVISA_PROJECTS OR NOT "${BRAINVISA_PROJECTS}" STREQUAL "${_BRAINVISA_PROJECTS}" )
  message( "BRAINVISA_PROJECTS has changed. Components list and sources had been reset." )

  # Clear components list
  foreach( component ${_BRAINVISA_COMPONENTS} )
    unset( BRAINVISA_SOURCES_${component} CACHE )
  endforeach()
  unset( BRAINVISA_COMPONENTS CACHE )
  unset( _BRAINVISA_COMPONENTS CACHE )

  # Get projects list
  BRAINVISA_READ_COMPONENT_INFOS( QUIET )
  set( BRAINVISA_PROJECTS ${_default_projects} CACHE STRING "List of main BrainVISA projects to build." )
  foreach( project ${_all_projects} )
    set( BRAINVISA_VERSION_SELECTION_${project} "" CACHE STRING "Type or branch that is used for automatic sources selection. Possible values are \"trunk\", \"stable\" and \"tag\"." FORCE )
    mark_as_advanced( BRAINVISA_VERSION_SELECTION_${project} )
    set( _BRAINVISA_VERSION_SELECTION_${project} "${BRAINVISA_VERSION_SELECTION_${project}}" CACHE INTERNAL "" )
  endforeach()
  set( _BRAINVISA_PROJECTS "${BRAINVISA_PROJECTS}" CACHE INTERNAL "" )
endif()


# Build components list
if( NOT BRAINVISA_COMPONENTS OR NOT "${BRAINVISA_COMPONENTS}" STREQUAL "${_BRAINVISA_COMPONENTS}" )
  # Clear components list
  foreach( component ${_BRAINVISA_COMPONENTS} )
    list( FIND BRAINVISA_COMPONENTS "${component}" result )
    if( result EQUAL -1 )
      unset( BRAINVISA_SOURCES_${component} CACHE )
    endif()
  endforeach()
  # Update components list
  BRAINVISA_READ_COMPONENT_INFOS()
  set( read_info FALSE )
  set( BRAINVISA_COMPONENTS ${_default_components} CACHE PATH "List of main BrainVISA components to build." )
  set( _BRAINVISA_COMPONENTS ${BRAINVISA_COMPONENTS} CACHE INTERNAL "" )
else()
  set( read_info TRUE )
  foreach( project ${BRAINVISA_PROJECTS} )
    if( NOT "${_BRAINVISA_VERSION_SELECTION_${project}}" STREQUAL "${BRAINVISA_VERSION_SELECTION_${project}}" )
      if( read_info )
        BRAINVISA_READ_COMPONENT_INFOS()
        set( read_info FALSE )
      endif()
      foreach( component ${_components_${project}} )
        unset( BRAINVISA_SOURCES_${component} CACHE )
      endforeach()
      string( REPLACE ";" ", " components "${_components_${project}}" )
      message( "Version selection of project ${project} have changed. Sources for its components (${components}) have been reset to default values." )
      set( _BRAINVISA_VERSION_SELECTION_${project} "${BRAINVISA_VERSION_SELECTION_${project}}" CACHE INTERNAL "" )
    endif()
  endforeach()
endif()
foreach( component ${BRAINVISA_COMPONENTS} )
  if( NOT BRAINVISA_SOURCES_${component} )
    if( read_info )
      BRAINVISA_READ_COMPONENT_INFOS()
      set( read_info FALSE )
    endif()
    set( BRAINVISA_SOURCES_${component} "${_sources_${component}}" CACHE PATH "Source directory for component ${component}" )
    mark_as_advanced( BRAINVISA_SOURCES_${component} )
  endif()
endforeach()

if( stopProcessing )
  return()
endif()


# Initialize dependencies
set( BRAINVISA_DEPENDENCY_GRAPH "NO" CACHE FILEPATH "File name where a Graphviz dependency graph will be created. Set to \"NO\" to disable dependency graph." )
if( BRAINVISA_DEPENDENCY_GRAPH )
  set( BRAINVISA_DEPENDENCY_NODES CACHE STRING INTERNAL FORCE )
  file( WRITE "${BRAINVISA_DEPENDENCY_GRAPH}" "digraph {\n" )
  foreach( component ${BRAINVISA_COMPONENTS} )
    foreach( sourceNodeLabel "${component}" "${component}-dev" )
      list( FIND BRAINVISA_DEPENDENCY_NODES ${sourceNodeLabel} sourceNode )
      if( sourceNode EQUAL -1 )
        list( LENGTH BRAINVISA_DEPENDENCY_NODES sourceNode )
        set( BRAINVISA_DEPENDENCY_NODES ${BRAINVISA_DEPENDENCY_NODES} "${sourceNodeLabel}" CACHE STRING INTERNAL FORCE )
        file( APPEND "${BRAINVISA_DEPENDENCY_GRAPH}" "${sourceNode} [ label=\"${sourceNodeLabel}\" ]\n" )
      endif()
    endforeach()
  endforeach()
endif()
  
BRAINVISA_CREATE_MAIN_COMPONENTS()
  
foreach( component ${BRAINVISA_COMPONENTS} )
  set( ${component}_IS_BEING_COMPILED TRUE CACHE BOOL INTERNAL )
endforeach()

foreach( component ${BRAINVISA_COMPONENTS} )
  message( STATUS "Configuring component ${component} from source directory \"${BRAINVISA_SOURCES_${component}}\"" )
  add_subdirectory( "${BRAINVISA_SOURCES_${component}}" "build_files/${component}" )
endforeach()
if( BRAINVISA_PACKAGING )
  set( runPackages )
  set( devPackages )
  foreach( component ${BRAINVISA_COMPONENTS} ${BRAINVISA_EXTERNAL_COMPONENTS} )
    set( runPackages ${runPackages} "${component}-package-run" )
    set( devPackages ${devPackages} "${component}-package-dev" )
  endforeach()
  add_custom_target( packages-run )
  add_dependencies( packages-run ${runPackages} )
  add_custom_target( packages-dev )
  add_dependencies( packages-dev ${devPackages} )
  add_custom_target( packages )
  add_dependencies( packages packages-run packages-dev )
endif()

if( BRAINVISA_DEPENDENCY_GRAPH )
  file( APPEND "${BRAINVISA_DEPENDENCY_GRAPH}" "}\n" )
endif()

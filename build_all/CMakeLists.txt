cmake_minimum_required( VERSION 2.6 )

set( CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}" ${CMAKE_PREFIX_PATH} )

find_package( brainvisa-cmake REQUIRED )
BRAINVISA_CREATE_MAIN_COMPONENTS()

function( BRAINVISA_READ_COMPONENT_INFOS )
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
    
    list( FIND BRAINVISA_PROJECTS "${BRAINVISA_PACKAGE_MAIN_PROJECT}" result )
    if( NOT result EQUAL -1 )
      # Two if because CMake does not seem to allow parentheses in conditions
      if( "${version_selection}" STREQUAL "${version_type}" OR "${version_type}" STREQUAL "unknown" )
        # Update components list
        list( FIND _all_components "${BRAINVISA_PACKAGE_NAME}" result )
        if( result EQUAL -1 )
          set( _default_components ${_default_components} "${BRAINVISA_PACKAGE_NAME}" )
          set( _version_${BRAINVISA_PACKAGE_NAME} "${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}" )
          set( _sources_${BRAINVISA_PACKAGE_NAME} "${sources_dir}" )
          message( STATUS "Selected ${BRAINVISA_PACKAGE_NAME} version ${_version_${BRAINVISA_PACKAGE_NAME}} in \"${sources_dir}\"." )
        elseif( "${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}" VERSION_GREATER "${_version_${BRAINVISA_PACKAGE_NAME}}" )
          set( _version_${BRAINVISA_PACKAGE_NAME} "${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}" )
          set( _sources_${BRAINVISA_PACKAGE_NAME} "${sources_dir}" )
          message( STATUS "Selected ${BRAINVISA_PACKAGE_NAME} version ${_version_${BRAINVISA_PACKAGE_NAME}} in \"${sources_dir}\"." )
        else()
          message( STATUS "Ignored ${BRAINVISA_PACKAGE_NAME} version ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH} in \"${sources_dir}\" because it is not in selected components." )
        endif()
      else()
        message( STATUS "Ignored ${BRAINVISA_PACKAGE_NAME} version ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH} in \"${sources_dir}\" because its version type \"${version_type}\" differs from the selected one \"${version_selection}\"." )
      endif()
    else()
      message( STATUS "Ignored ${BRAINVISA_PACKAGE_NAME} version ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH} in \"${sources_dir}\" because it is not in selected projects." )
    endif()
  endforeach()
  
  # Export variables to parent scope
  set( _all_projects "${_all_projects}" PARENT_SCOPE )
  set( _default_projects "${_default_projects}" PARENT_SCOPE )
  set( _default_components "${_default_components}" PARENT_SCOPE )
  foreach( component ${_default_components} )
    set( _sources_${component} "${_sources_${component}}" PARENT_SCOPE )
  endforeach()
endfunction()


function( BRAINVISA_COMPONENTS_SELECTION )
  set( STOP_PROCESSING FALSE PARENT_SCOPE )
  if( NOT DEFINED BRAINVISA_SOURCES OR 
      NOT DEFINED BRAINVISA_VERSION_SELECTION OR
      NOT "${BRAINVISA_SOURCES}" STREQUAL "${_BRAINVISA_SOURCES}" OR
      NOT "${BRAINVISA_VERSION_SELECTION}" STREQUAL "${_BRAINVISA_VERSION_SELECTION}" )
    BRAINVISA_SYSTEM_PATH_TO_LIST( BRAINVISA_SOURCES "$ENV{BRAINVISA_SOURCES}" )
    set( BRAINVISA_SOURCES "${BRAINVISA_SOURCES}" CACHE PATH "Directories where to look for sources." )
    set( BRAINVISA_VERSION_SELECTION trunk CACHE STRING "Type of branch that is used for automatic sources selection. Possible values are \"trunk\", \"stable\" and \"tag\"." )
    BRAINVISA_READ_COMPONENT_INFOS()
    set( BRAINVISA_PROJECTS ${_default_projects} CACHE PATH "List of main BrainVISA projects to build." FORCE )
    foreach( project ${_all_projects} )
      set( BRAINVISA_VERSION_SELECTION_${project} "" CACHE STRING "Type or branch that is used for automatic sources selection. Possible values are \"trunk\", \"stable\" and \"tag\"." FORCE )
      mark_as_advanced( BRAINVISA_VERSION_SELECTION_${project} )
    endforeach()
    message( "BRAINVISA_SOURCES, BRAINVISA_VERSION_SELECTION had been modified. Therefore, BRAINVISA_PROJECTS had been reset to default value. Configuration has been stopped to allow you to check the content of these variables." )
    set( _BRAINVISA_SOURCES "${BRAINVISA_SOURCES}" CACHE INTERNAL STRING )
    set( _BRAINVISA_VERSION_SELECTION "${BRAINVISA_VERSION_SELECTION}" CACHE INTERNAL STRING )
    set( _BRAINVISA_PROJECTS "" CACHE INTERNAL STRING )
    set( STOP_PROCESSING TRUE PARENT_SCOPE )
    return()
  endif()

  if( NOT BRAINVISA_PROJECTS OR NOT "${BRAINVISA_PROJECTS}" STREQUAL "${_BRAINVISA_PROJECTS}" )
    message( "BRAINVISA_PROJECTS has changed. Components list and sources had been reset." )
    BRAINVISA_READ_COMPONENT_INFOS()
    set( BRAINVISA_COMPONENTS ${_default_components} CACHE PATH "List of main BrainVISA components to build." FORCE )
    foreach( component ${BRAINVISA_COMPONENTS} )
      set( BRAINVISA_SOURCES_${component} "${_sources_${component}}" CACHE PATH "Source directory for component ${component}" FORCE )
      mark_as_advanced( BRAINVISA_SOURCES_${component} )
    endforeach()
    BRAINVISA_READ_COMPONENT_INFOS()
    set( _BRAINVISA_PROJECTS "${BRAINVISA_PROJECTS}" CACHE INTERNAL STRING )
  endif()


#   if( NOT "${BRAINVISA_PROJECTS}" STREQUAL "${_brainvisa_projects}" )
#     BRAINVISA_FIND_COMPONENTS( "${BRAINVISA_PROJECTS}" "${BRAINVISA_SOURCES}" )
#     set( _brainvisa_projects "${BRAINVISA_PROJECTS}" CACHE INTERNAL )
#   endif()
# 
# 
#   if( NOT DEFINED BRAINVISA_COMPONENTS )
#     set( BRAINVISA_COMPONENTS "anatomist-free;anatomist-gpl;sulci-private;sulci-gpl;sulci-data;axon_web;brainrat-private;brainrat-gpl;bioprocessing;connectomist-gpl;connectomist-private;datamind;nuclear_processing-gpl;nuclear_processing-private;cortical_surface-gpl;cortical_surface-private;axon;brainvisa-system;build-config;brainvisa-cmake;brainvisa-svn;data_storage_client;fmri-gpl;installer;brainvisa-share;aims-gpl;aims-free;latex;bibliography;documentation;web;soma-base;soma-io;soma-qtgui;t1mri-private;t1mri-gpl" CACHE PATH "List of components to compile" )
#   endif( NOT DEFINED BRAINVISA_COMPONENTS )
#   
#   set( BRAINVISA_SOURCES_BRANCH_TYPE trunk CACHE PATH "Type of the SVN branch used to select source projects. Can be \"trunk\" or \"stable\"." )
endfunction()











function( BRAINVISA_FIND_PROJECT_SOURCES_BRANCH output project branch_type )
  # Look for all project_info.cmake files in source trees
  set( info )
  foreach( dir ${BRAINVISA_SOURCES} )
    set( info ${info} "${dir}/project_info.cmake" )
  endforeach( dir ${BRAINVISA_SOURCES} )
  file( GLOB_RECURSE info ${info} )
  
#  message( "BRAINVISA_FIND_PROJECT_SOURCES_BRANCH: looking for ${project} branch ${branch}" )

  # Find compatible projects
  set( trunk_sources )
  set( stable_sources )
  foreach( info ${info} )
#    message( "BRAINVISA_FIND_PROJECT_SOURCES_BRANCH: read ${info}" )
    include( "${info}" )
    if( BRAINVISA_PACKAGE_NAME STREQUAL "${project}" )
      get_filename_component( sources_dir "${info}" PATH )
      get_filename_component( branch "${sources_dir}" NAME )
      if( ${branch} STREQUAL "trunk" )
        set( trunk_sources "${sources_dir}" )
#        message( "BRAINVISA_FIND_PROJECT_SOURCES_BRANCH: found trunk branch: version ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}" )
      else( ${branch} STREQUAL "trunk" )
        get_filename_component( tmp "${sources_dir}" PATH )
        get_filename_component( current_branch_type "${tmp}" NAME )
        if( ${current_branch_type} STREQUAL "branches" )
#          message( "BRAINVISA_FIND_PROJECT_SOURCES_BRANCH: found branch ${branch} of type ${current_branch_type}: version ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}" )
          if( stable_sources )
            if( ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH} VERSION_GREATER ${stable_version} )
              set( selected TRUE )
            endif( ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH} VERSION_GREATER ${stable_version} )
          else( stable_sources )
            set( selected TRUE )
          endif( stable_sources )
          if( selected )
            set( stable_sources "${sources_dir}" )
            set( stable_version ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH} )
#            message( "BRAINVISA_FIND_PROJECT_SOURCES_BRANCH: set current stable branch for ${project} to version ${stable_version} in ${stable_sources}" ) 
          endif( selected )
        else( ${current_branch_type} STREQUAL "branches" )
#          message( "BRAINVISA_FIND_PROJECT_SOURCES_BRANCH: ignored branch ${branch} of type ${current_branch_type}: version ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH}" )
        endif( ${current_branch_type} STREQUAL "branches" )
      endif( ${branch} STREQUAL "trunk" )
#      message( "BRAINVISA_FIND_PROJECT_SOURCES_BRANCH: found version ${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}.${BRAINVISA_PACKAGE_VERSION_PATCH} in branch ${branch}" )
    endif( BRAINVISA_PACKAGE_NAME STREQUAL "${project}" )
  endforeach( info ${info} )

  if( ${branch_type}_sources )
    message( "BRAINVISA_FIND_PROJECT_SOURCES_BRANCH: Found sources for ${branch_type} branch of ${project} with version ${${branch_type}_version} in \"${${branch_type}_sources}\"" )
    set( output "${${branch_type}_sources}" PARENT_SCOPE )
  else( ${branch_type}_sources )
    message( "BRAINVISA_FIND_PROJECT_SOURCES_BRANCH: Cannot find sources for ${branch_type} branch of ${project}." )
    set( output "" PARENT_SCOPE )
  endif( ${branch_type}_sources )
endfunction( BRAINVISA_FIND_PROJECT_SOURCES_BRANCH )




BRAINVISA_COMPONENTS_SELECTION()
if( STOP_PROCESSING )
  return()
endif()

foreach( component ${BRAINVISA_COMPONENTS} )
  message( "Include component ${component} from \"${BRAINVISA_SOURCES_${component}}\"" )
endforeach()


# 
# function( BRAINVISA_FIND_PROJECT_SOURCE_DIRECTORY result project )
#   if( NOT DEFINED ${_project}_SOURCES )
#     BRAINVISA_FIND_PROJECT_SOURCES( "${_project}" "${_version}" )
#   endif( NOT DEFINED ${_project}_SOURCES )
#   set( BRAINVISA_BUILD_PROJECTS ${BRAINVISA_BUILD_PROJECTS} ${_project} )
#   add_subdirectory( "${${_project}_SOURCES}" "build_files/${_project}" )
# endfunction( BRAINVISA_FIND_PROJECT_SOURCE_DIRECTORY )
# 
# foreach( project 
# BRAINVISA_INCLUDE_PROJECT_SOURCES( soma-base 4.0.0 )
# BRAINVISA_INCLUDE_PROJECT_SOURCES( aims 4.0.0 )
# # BRAINVISA_INCLUDE_PROJECT_SOURCES( aims-gpl 4.0.0 )
# # BRAINVISA_INCLUDE_PROJECT_SOURCES( anatomist 4.0.0 )
# BRAINVISA_INCLUDE_PROJECT_SOURCES( axon 4.0.0 )
# BRAINVISA_INCLUDE_PROJECT_SOURCES( share 4.0.0 )
# 
# BRAINVISA_CREATE_PACKAGING_RULES()

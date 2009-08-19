cmake_minimum_required( VERSION 2.6 )

set( CMAKE_PREFIX_PATH "${CMAKE_BINARY_DIR}" ${CMAKE_PREFIX_PATH} )

find_package( brainvisa-cmake REQUIRED )
BRAINVISA_CREATE_MAIN_COMPONENTS()


function( BRAINVISA_COMPONENTS_SELECTION )
  if( NOT DEFINED BRAINVISA_SOURCES )
    BRAINVISA_SYSTEM_PATH_TO_LIST( BRAINVISA_SOURCES "$ENV{BRAINVISA_SOURCES}" )
    set( BRAINVISA_SOURCES "${BRAINVISA_SOURCES}" CACHE PATH "Directories where to look for sources." )
  endif()
  if( NOT "${BRAINVISA_SOURCES}" STREQUAL "${_BRAINVISA_SOURCES}" )
    message( "BRAINVISA_SOURCES has changed" )
    set( _BRAINVISA_SOURCES "${BRAINVISA_SOURCES}" CACHE INTERNAL STRING )
  endif()

  if( NOT DEFINED BRAINVISA_VERSION_SELECTION )
    set( BRAINVISA_VERSION_SELECTION trunk CACHE STRING "Type of branch that is used for automati sources selection. Possible values are \"trunk\", \"stable\" and \"tag\"." )
  endif()
  if( NOT "${BRAINVISA_VERSION_SELECTION}" STREQUAL "${_BRAINVISA_VERSION_SELECTION}" )
    message( "BRAINVISA_VERSION_SELECTION has changed" )
    set( _BRAINVISA_VERSION_SELECTION "${BRAINVISA_VERSION_SELECTION}" CACHE INTERNAL STRING )
  endif()

  # Look for all project_info.cmake files in source trees
  set( projects_info )
  set( _all_projects )
  foreach( dir ${BRAINVISA_SOURCES} )
    set( projects_info ${projects_info} "${dir}/project_info.cmake" )
  endforeach()
  file( GLOB_RECURSE projects_info ${projects_info} )
  foreach( info ${projects_info} )
    get_filename_component( sources_dir "${info}" PATH )
#     get_filename_component( tmp "${source_dir}" PATH )
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
        message( "File \"${info}\" will be ignored because its branch type \"${branch_type}\" is unknown." )
        set( version_type "unknown" )
      endif()
    endif()
    if( "${BRAINVISA_VERSION_SELECTION}" STREQUAL "${version_type}" )
      include( "${info}" )
      if( NOT BRAINVISA_PACKAGE_MAIN_PROJECT )
        message( SEND_ERROR "No BRAINVISA_PACKAGE_MAIN_PROJECT declared in \"${info}\"" )
      endif()
      list( FIND _all_projects "${BRAINVISA_PACKAGE_MAIN_PROJECT}" result )
      if( result EQUAL -1 )
        set( _all_projects ${_all_projects} "${BRAINVISA_PACKAGE_MAIN_PROJECT}" )
      endif()
    endif()
  endforeach()


  if( NOT DEFINED BRAINVISA_PROJECTS )

    set( BRAINVISA_PROJECTS $ENV{BRAINVISA_PROJECTS} CACHE PATH "List of main BrainVISA projects to build." )
  endif()
  if( NOT "${BRAINVISA_PROJECTS}" STREQUAL "${_BRAINVISA_PROJECTS}" )
    message( "BRAINVISA_PROJECTS has changed" )
    set( _BRAINVISA_PROJECTS "${BRAINVISA_PROJECTS}" CACHE INTERNAL STRING )
  endif()


  message( "All projects: ${_all_projects}" )
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

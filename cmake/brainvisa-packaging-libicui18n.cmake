find_package(Libicui18n)

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "-" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  if(LIBICUI18N_VERSION)
    set( ${package_version} "${LIBICUI18N_VERSION}" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(LIBICUI18N_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${LIBICUI18N_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# # this variable declares the install rule for the dev package
# set( libicui18n-dev-installrule TRUE )
#
# function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
#   if(LIBICUI18N_FOUND)
#     file( GLOB _files "${LIBICUI18N_INCLUDE_DIR}/*.h" )
#     BRAINVISA_INSTALL( FILES ${_files}
#                       DESTINATION "include"
#                       COMPONENT "${component}-dev" )
#     set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
#   else()
#     set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
#   endif()
# endfunction()
#

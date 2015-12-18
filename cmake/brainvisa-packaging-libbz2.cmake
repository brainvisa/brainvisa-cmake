find_package(BZip2)

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "None" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  if(BZIP2_VERSION_STRING)
    set( ${package_version} "${BZIP2_VERSION_STRING}" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(BZIP2_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${BZIP2_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# # this variable declares the install rule for the dev package
# set( libbz2-dev-installrule TRUE )
#
# function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
#   if(BZIP2_FOUND)
#     file( GLOB _files "${BZIPPNG12_INCLUDE_DIR}/bzlib*.h" )
#     BRAINVISA_INSTALL( FILES ${_files}
#                       DESTINATION "include"
#                       COMPONENT "${component}-dev" )
#     set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
#   else()
#     set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
#   endif()
# endfunction()


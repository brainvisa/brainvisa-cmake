find_package(LibGraphite2)

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "None" PARENT_SCOPE )
  # Find version
  set( ${package_version} "1.0.0" PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(LIBGRAPHITE2_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${LIBGRAPHITE2_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# # this variable declares the install rule for the dev package
# set( libdoubleconversion-dev-installrule TRUE )
#
# function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
#   if(LIBDOUBLECONVERSION_FOUND)
#     file( GLOB _files "${LIBDOUBLECONVERSION_INCLUDE_DIR}/*.h" )
#     BRAINVISA_INSTALL( FILES ${_files}
#                       DESTINATION "include"
#                       COMPONENT "${component}-dev" )
#     set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
#   else()
#     set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
#   endif()
# endfunction()


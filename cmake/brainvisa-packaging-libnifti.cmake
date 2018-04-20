find_package( LibNifti )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "Thirdparty" PARENT_SCOPE )
  # Find version
  set( ${package_version} ${LIBNIFTI_VERSION} PARENT_SCOPE )

endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(LIBNIFTI_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${LIBNIFTI_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


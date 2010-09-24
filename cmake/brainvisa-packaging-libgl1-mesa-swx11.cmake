find_package(Mesa)

function( BRAINVISA_PACKAGING_COMPONENT_INFO cmake package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  foreach(lib ${MESA_LIBRARIES})
    get_filename_component( real "${lib}" REALPATH )
    string( REGEX MATCH "^.*libOSMesa${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
    if( match )
      set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
      break()
    endif()
  endforeach()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(MESA_LIBRARIES)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${MESA_LIBRARIES} 
      DESTINATION "lib/mesa")
  endif()
endfunction()


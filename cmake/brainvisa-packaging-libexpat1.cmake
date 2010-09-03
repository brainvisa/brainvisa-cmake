find_package( EXPAT )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  get_filename_component( real "${EXPAT_LIBRARIES}" REALPATH )
  string( REGEX MATCH "^.*libexpat${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
  if( match )
    set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(EXPAT_FOUND)
    BRAINVISA_install_RUNTIME_LIBRARIES( ${component} ${EXPAT_LIBRARIES} )
  else()
    MESSAGE( SEND_ERROR "Impossible to create packaging rules for ${component} : the package was not found." )
  endif()
endfunction()


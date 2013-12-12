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
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${EXPAT_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( libexpat1-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(EXPAT_FOUND)
    set( _files "${EXPAT_INCLUDE_DIR}/expat.h"
      "${EXPAT_INCLUDE_DIR}/expat_external.h" )
    if( EXISTS "${EXPAT_INCLUDE_DIR}/expat_config.h" )
      list( APPEND _files "${EXPAT_INCLUDE_DIR}/expat_config.h" )
    endif()
    BRAINVISA_INSTALL( FILES ${_files}
      DESTINATION include
      COMPONENT ${component}-dev )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


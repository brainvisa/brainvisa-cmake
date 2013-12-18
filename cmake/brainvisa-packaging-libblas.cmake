find_package(BLAS)

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  foreach(lib ${BLAS_LIBRARIES})
    get_filename_component( real "${lib}" REALPATH )
    string( REGEX MATCH "^.*libblas${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
    if( match )
      set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
      break()
    endif()
  endforeach()
  string( REGEX MATCH Ubuntu _systemname "${BRAINVISA_SYSTEM_IDENTIFICATION}" )
  if( _systemname )
    if ( "${BRAINVISA_SYSTEM_VERSION}" VERSION_GREATER "12.0")
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libquadmath RUN )
    endif()
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if( BLAS_FOUND )
    if( NOT APPLE)
      set( _libs ${BLAS_LIBRARIES} )
      find_library( _cblas cblas )
      if( _cblas )
        list( APPEND _libs ${_cblas} )
      endif()
      unset( _cblas CACHE )
      find_library( _cblas blas )
      if( _cblas )
        list( APPEND _libs ${_cblas} )
      endif()
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${_libs} )
    endif()
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()
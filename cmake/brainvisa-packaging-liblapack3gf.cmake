enable_language(Fortran)
find_package(LAPACK)

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  foreach(lib ${LAPACK_LIBRARIES})
    get_filename_component( real "${lib}" REALPATH )
    string( REGEX MATCH "^.*liblapack${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
    if( match )
      set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
      break()
    endif()
  endforeach()
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libgfortran2 RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(LAPACK_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${LAPACK_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

enable_language(Fortran)
find_package(LAPACK)
find_package(BLAS)

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
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libblas RUN )
  string( REGEX MATCH Ubuntu _systemname "${BRAINVISA_SYSTEM_IDENTIFICATION}" )
  if( _systemname )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libquadmath RUN )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(LAPACK_FOUND)
    set( _libs ${LAPACK_LIBRARIES} )
    if( APPLE )
      # remove Blas libs from list
      list( REMOVE_ITEM _libs ${BLAS_LIBRARIES} )
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${_libs} )
    else()
      foreach( lib ${LAPACK_LIBRARIES} )
        get_filename_component( name ${lib} NAME )
        get_filename_component( path ${lib} PATH )
        if( name STREQUAL "liblapack.so.3gf" )
          # on Ubuntu, liblapack.so.3 is pointed indirectly via a symlink,
          # in a different directory, and is also a symlink, so nothing
          # can identify it is really the file used by libs and executables.
          # so we need to add it by hand.
          list( APPEND _libs "${path}/liblapack.so.3" )
        elseif( name STREQUAL "libblas.so.3gf" ) # same for blas
          list( APPEND _libs "${path}/libblas.so.3" )
        endif()
      endforeach()
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${_libs} )
    endif()
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

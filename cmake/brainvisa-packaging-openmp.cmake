find_package( LIBGCC )
find_package( OpenMP )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name
          package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( _version "1.0.0" )
  set( ${package_version} ${_version} PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  # OPENMP_FOUND is never set ! Have to test something else
  if( OpenMP_C_FLAGS )
    get_filename_component( _comp ${CMAKE_CXX_COMPILER} NAME_WE )
    get_filename_component( _gccpath ${LIBGCC_LIBRARIES} PATH )
    if( ${_comp} STREQUAL "clang++" )
      find_library( _libomp omp PATHS ${_gccpath} )
    else()
      find_library( _libomp gomp PATHS ${_gccpath} )
    endif()
    if( _libomp )
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${_libomp} )
    endif()
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
    #MESSAGE( SEND_ERROR "Impossible to create packaging rules for ${component} : the library was not found." )
  endif()
endfunction()

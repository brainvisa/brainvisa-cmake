find_package( MPI )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  # on Ubuntu >= 14 mpi is linked against libnuma, libhwlock, libltdl...
  if( LSB_DISTRIB STREQUAL "ubuntu"
      AND LSB_DISTRIB_RELEASE VERSION_GREATER 14.0 )
#     BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libnuma RUN )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libltdl7 RUN )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if( MPI_C_FOUND )
    set( _libpaths )
    foreach( _lib ${MPI_C_LIBRARIES} )
      get_filename_component( _path ${_lib} DIRECTORY )
      list( APPEND _libpaths ${_path} )
    endforeach()
    find_library( MPI_OPENRTE_LIBRARY open-rte ${_paths} )
    find_library( MPI_OPENPAL_LIBRARY open-pal ${_paths} )
    set( _libs ${MPI_C_LIBRARIES}
        ${MPI_OPENRTE_LIBRARY} ${MPI_OPENPAL_LIBRARY} )
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${_libs} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


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
      get_filename_component( _path ${_lib} PATH )
      list( APPEND _libpaths ${_path} )
    endforeach()
    find_library( MPI_OPENRTE_LIBRARY open-rte ${_paths} )
    find_library( MPI_OPENPAL_LIBRARY open-pal ${_paths} )
    set( _libs ${MPI_C_LIBRARIES}
        ${MPI_OPENRTE_LIBRARY} ${MPI_OPENPAL_LIBRARY} )
    set( _libs_install )
    foreach( _lib ${_libs} )
      string( REGEX MATCH "(mpi)|(open)" _match ${_lib} )
      if( _match )
        list( APPEND _libs_install ${_lib} )
        # on Ubuntu 12.04, libmpi.so is a symlink to libmpi.so.x.y.z
        # but we need libmpi.so.x
        if( LSB_DISTRIB STREQUAL "ubuntu"
            AND LSB_DISTRIB_RELEASE VERSION_EQUAL 12.04 )
          get_filename_component( _name ${_lib} NAME )
          if( _name STREQUAL "libmpi.so" )
            file( GLOB _libmpi_num "${_lib}.?" )
            if( _libmpi_num )
              list( APPEND _libs_install ${_libmpi_num} )
            endif()
          endif()
        endif()
      endif()
    endforeach()
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${_libs_install} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


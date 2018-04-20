find_package( MINC )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  FIND_PACKAGE(NETCDF QUIET)
  FIND_PACKAGE(HDF5   QUIET)
  if( NETCDF_FOUND )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libnetcdf RUN )
  endif()
  if( HDF5_FOUND )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libhdf5 RUN )
  endif()
  # this dependency is only present on ubuntu >= 16.04
  if( LSB_DISTRIB STREQUAL "ubuntu"
      AND LSB_DISTRIB_RELEASE VERSION_GREATER "16.0" )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN
                                      DEPENDS libnifti RUN )
  endif()
  # Find version
  if(MINC_VERSION)
    set( ${package_version} "${MINC_VERSION}" PARENT_SCOPE )
  else()
    set( ${package_version} "0.0.0" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(MINC_FOUND)
    foreach( MINC_LIBRARY ${LIBMINC_LIBRARIES} )
      if( MINC_LIBRARY MATCHES ".*(minc|volume_io).*" )
        BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${MINC_LIBRARY} )
      endif()
    endforeach()
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( libminc-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(MINC_FOUND)
    foreach ( MINC_INCLUDE_DIR ${LIBMINC_INCLUDE_DIRS} )
      file( GLOB _files "${MINC_INCLUDE_DIR}/ParseArgs.h" "${MINC_INCLUDE_DIR}/acr_*.h" "${MINC_INCLUDE_DIR}/minc*.h" "${MINC_INCLUDE_DIR}/nd_loop.h" "${MINC_INCLUDE_DIR}/time_stamp.h" "${MINC_INCLUDE_DIR}/volume_io.h" "${MINC_INCLUDE_DIR}/voxel_loop.h" )
      
      if(_files)
        # Resolve symbolic links to get real files
        set(_real_files)
        foreach(f ${_files})
            get_filename_component(f "${f}" REALPATH)
            list(APPEND _real_files "${f}")
        endforeach()

        BRAINVISA_INSTALL( FILES ${_real_files}
                            DESTINATION "include"
                            COMPONENT "${component}-dev" )

        if( EXISTS "${MINC_INCLUDE_DIR}/volume_io" )
            BRAINVISA_INSTALL_DIRECTORY( "${MINC_INCLUDE_DIR}/volume_io"
            include/volume_io ${component}-dev )
        endif()
      endif()
    endforeach()
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

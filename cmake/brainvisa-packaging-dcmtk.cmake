find_package( DCMTK )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  
  # Find version
  if (DCMTK_VERSION)
    set( ${package_version} "${DCMTK_VERSION}" PARENT_SCOPE )
  else()
    set( ${package_version} "0.0.0" PARENT_SCOPE )
  endif()

  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS zlib RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libssl RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(DCMTK_FOUND)
    # filter out non-dcmtk libs in ${DCMTK_LIBRARIES}
    set( _dcmtk_libs )
    set( _forbidden ${ZLIB_LIBRARIES} ${OPENSSL_LIBRARIES} )
    foreach( _lib ${DCMTK_LIBRARIES} )
      list( FIND _forbidden ${_lib} _i )
      if( _i EQUAL -1 )
        list( APPEND _dcmtk_libs ${_lib} )
      endif()
    endforeach()
    # install DCMTK libs if they are not static
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${_dcmtk_libs} )
    if( EXISTS "${DCMTK_dict}" )
      get_filename_component( dict "${DCMTK_dict}" REALPATH )
      BRAINVISA_INSTALL( FILES "${dict}"
        DESTINATION "lib"
        COMPONENT "${component}" )
    endif()
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( dcmtk-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(DCMTK_FOUND)
    BRAINVISA_INSTALL_DIRECTORY( "${DCMTK_config_INCLUDE_DIR}" include/dcmtk
      ${component}-dev )
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

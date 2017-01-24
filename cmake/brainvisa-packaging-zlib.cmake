find_package( ZLIB )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} ${ZLIB_VERSION_STRING} PARENT_SCOPE )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(WIN32)
    if (ZLIB_FOUND)
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${ZLIB_LIBRARIES} )
      set(${component}_PACKAGED TRUE PARENT_SCOPE)
    else()
      set(${component}_PACKAGED FALSE PARENT_SCOPE)
    endif()
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( zlib-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if (ZLIB_FOUND)
    set( _files "${ZLIB_INCLUDE_DIR}/zlib.h" )
    if( EXISTS "${ZLIB_INCLUDE_DIR}/zconf.h" )
      list( APPEND _files "${ZLIB_INCLUDE_DIR}/zconf.h" )
    else()
      if( EXISTS "/usr/include/x86_64-linux-gnu/zconf.h" )
        list( APPEND _files "/usr/include/x86_64-linux-gnu/zconf.h" )
      endif()
    endif()
    if( EXISTS "${ZLIB_INCLUDE_DIR}/zlibdefs.h" )
      list( APPEND _files "${ZLIB_INCLUDE_DIR}/zlibdefs.h" )
    endif()
    BRAINVISA_INSTALL( FILES ${_files}
      DESTINATION include
      COMPONENT ${component}-dev )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


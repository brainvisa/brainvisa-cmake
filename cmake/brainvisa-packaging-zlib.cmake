find_package( ZLIB )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  if( NOT ZLIB_VERSION_STRING )
    set( ${package_version} "0.0.0" PARENT_SCOPE )
    if( EXISTS "${ZLIB_INCLUDE_DIR}/zlib.h" )
      file( READ "${ZLIB_INCLUDE_DIR}/zlib.h" header )
      string( REGEX MATCH "#define[ \\t]*ZLIB_VERSION[ \\t]*\"([^\"]*)\""
              match "${header}" )
      if( match )
        set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
      endif()
    endif()
  else()
    set( ${package_version} ${ZLIB_VERSION_STRING} PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(WIN32 OR (LSB_DISTRIB STREQUAL "ubuntu"
               AND LSB_DISTRIB_RELEASE VERSION_GREATER "16.0") )
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
    # Resolve symbolic links to get real files
    set(_real_files)
    foreach(f ${_files})
        get_filename_component(f "${f}" REALPATH)
        list(APPEND _real_files "${f}")
    endforeach()
    BRAINVISA_INSTALL( FILES ${_real_files}
      DESTINATION include
      COMPONENT ${component}-dev )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


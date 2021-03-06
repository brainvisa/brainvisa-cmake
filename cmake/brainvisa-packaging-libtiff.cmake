find_package( TIFF )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  get_filename_component( real "${TIFF_LIBRARIES}" REALPATH )
  string( REGEX MATCH "^.*libtiff${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
  if( match )
    set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
  endif()
  # libtiff5 (Ubuntu 14-16) depends on libjbig, liblzma, jpeg8
  find_package( LibJbig QUIET )
  if( LIBJBIG_FOUND )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libjbig RUN )
  endif()
  find_package( LibLZMA QUIET )
  if( LIBLZMA_FOUND )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS liblzma RUN )
  endif()
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libjpeg62 RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(TIFF_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${TIFF_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( libtiff-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(TIFF_FOUND)
    set(_files
        "${TIFF_INCLUDE_DIR}/tiff.h"
        "${TIFF_INCLUDE_DIR}/tiffio.h"
        "${TIFF_INCLUDE_DIR}/tiffconf.h"
        "${TIFF_INCLUDE_DIR}/tiffvers.h"
        "${TIFF_INCLUDE_DIR}/tiffio.hxx")
    # Resolve symbolic links to get real files
    set(_real_files)
    foreach(f ${_files})
        get_filename_component(f "${f}" REALPATH)
        list(APPEND _real_files "${f}")
    endforeach()
    BRAINVISA_INSTALL( FILES ${_real_files}
      DESTINATION include 
      COMPONENT ${component}-dev )
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

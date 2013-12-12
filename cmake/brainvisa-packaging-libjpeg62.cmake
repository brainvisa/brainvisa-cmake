find_package(JPEG)

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  get_filename_component( real "${JPEG_LIBRARIES}" REALPATH )
  string( REGEX MATCH "^.*libjpeg${CMAKE_SHARED_LIBRARY_SUFFIX}[.](.*)$" match "${real}" )
  if( match )
    set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(JPEG_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${JPEG_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
    #MESSAGE( SEND_ERROR "Impossible to create packaging rules for ${component} : the package was not found." )
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( libjpeg62-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(JPEG_FOUND)
    find_file( _jconfig jconfig.h PATHS "${JPEG_INCLUDE_DIR}" NO_DEFAULT_PATH )
    find_file( _jconfig jconfig.h )
    find_file( _jconfig jconfig.h PATHS "/usr/include/x86_64-linux-gnu"
      NO_DEFAULT_PATH )
    set( _files "${JPEG_INCLUDE_DIR}/jpeglib.h"
      "${JPEG_INCLUDE_DIR}/jmorecfg.h"
      "${_jconfig}" )
    if( EXISTS "${JPEG_INCLUDE_DIR}/jerror.h" )
      list( APPEND _files "${JPEG_INCLUDE_DIR}/jerror.h" )
    endif()
    BRAINVISA_INSTALL( FILES ${_files}
      DESTINATION include
      COMPONENT ${component}-dev )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
    #MESSAGE( SEND_ERROR "Impossible to create packaging rules for ${component} : the package was not found." )
  endif()
endfunction()


find_package(PNG12)

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  if(PNG12_VERSION)
    set( ${package_version} "${PNG12_VERSION}" PARENT_SCOPE )
  else(PNG12_VERSION)
    if( EXISTS "${PNG12_INCLUDE_DIR}/png.h" )
      file( READ "${PNG12_INCLUDE_DIR}/png.h" header )
      string( REGEX MATCH "#define[ \\t]*PNG_LIBPNG_VER_STRING[ \\t]*\"([^\"]*)\"" match "${header}" )
      if( match )
        set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
      endif( match )
    endif()
  endif(PNG12_VERSION)
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS zlib RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(PNG12_FOUND)
    if( APPLE )
      # on Mac, remove the libpng.dylib file (symlink) because it conflicts
      # with the system libpng at
      # /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/ImageIO.framework/Versions/A/Resources/libPng.dylib
      set( _libs )
      foreach( _file ${PNG12_LIBRARIES} )
        get_filename_component( _real ${_file} REALPATH )
        list( APPEND _libs ${_real} )
      endforeach()
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${_libs} )
    else()
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${PNG12_LIBRARIES} )
    endif()
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

# this variable declares the install rule for the dev package
set( libpng12-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(PNG12_FOUND)
    file( GLOB _files "${PNG12_INCLUDE_DIR}/png*.h" )
    BRAINVISA_INSTALL( FILES ${_files}
                      DESTINATION "include"
                      COMPONENT "${component}-dev" )
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


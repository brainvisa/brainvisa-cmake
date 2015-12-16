find_package( LibSSL ) 

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  # Find version
  set( version )
  if( LIBSSL_LIBRARIES )
    foreach( lib ${LIBSSL_LIBRARIES} )
      get_filename_component( real "${lib}" REALPATH )
      if( NOT WIN32 )
        string( REGEX MATCH "^.*libssl${CMAKE_SHARED_LIBRARY_SUFFIX}[.]([0-9]([.][0-9]+)*)$" match "${real}" )
      else()
        # First, try to find version using PkgConfig
        find_package( PkgConfig )
        PKG_CHECK_MODULES(PKGCONFIG_LIBSSL libssl)
        
        # Because BrainVISA installer does not support characters in version number,
        # we always remove characters in versions (i.e. version 1.0.1e => 1.0.1)
        if( PKGCONFIG_LIBSSL_LIBRARIES )
          string( REGEX MATCH "^([0-9](.[0-9]+)*).*$" match "${PKGCONFIG_LIBSSL_VERSION}" )
        else()
          # Then, try to find version in install directory name, this
          string( REGEX MATCH "^.*/[^/]*-([0-9](.[0-9]+)*)[^-./]*[^/]*/lib/libssl${CMAKE_SHARED_LIBRARY_SUFFIX}(.*)$" match "${real}" )
        endif()
      endif()
      
      if( match )
        set( version "${CMAKE_MATCH_1}" )
        break()
      endif()    
    endforeach()

  endif()
  
  if( version )
    set( ${package_version} "${version}" PARENT_SCOPE )
    set( ${package_name} "${component}${version}" PARENT_SCOPE )
  else()
    set( ${package_version} "0.0.0" PARENT_SCOPE )
    set( ${package_name} ${component} PARENT_SCOPE )
  endif()
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
endfunction()

function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(NOT APPLE AND NOT WIN32 ) # packaged only on linux
    if( LIBSSL_FOUND)
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${LIBSSL_LIBRARIES} )
      set(${component}_PACKAGED TRUE PARENT_SCOPE)
    else()
      set(${component}_PACKAGED FALSE PARENT_SCOPE)
    endif()
  endif()
endfunction()

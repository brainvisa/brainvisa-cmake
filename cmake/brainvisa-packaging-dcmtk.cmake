find_package( DCMTK )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  foreach( include ${DCMTK_INCLUDE_DIR} )
    if( EXISTS "${include}/dcmtk/dcmdata/dcuid.h" )
      file( READ "${include}/dcmtk/dcmdata/dcuid.h" header )
      string( REGEX MATCH "#define[ \\t]*OFFIS_DCMTK_VERSION_STRING[ \\t]*\"([^\"]*)\"" match "${header}" )
      if( match )
        set( ${package_version} "${CMAKE_MATCH_1}" PARENT_SCOPE )
        break()
      endif()
    endif()
  endforeach()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(DCMTK_FOUND)
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${DCMTK_LIBRARIES} )
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


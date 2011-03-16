find_package( python )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${PYTHON_VERSION}" PARENT_SCOPE )
  IF( NOT WIN32 )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libreadline5 RUN )
  ENDIF()
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libsqlite3-0 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libssl RUN )
  # dependency due to matplotlib: some backends are linked to cairo
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libcairo2 RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(PYTHON_FOUND)
    # Find the usual python executable : without version number in the name
    get_filename_component( REAL_PYTHON_EXECUTABLE "${PYTHON_EXECUTABLE}" REALPATH )
    get_filename_component( PYTHON_BIN_DIR "${REAL_PYTHON_EXECUTABLE}" PATH )
    get_filename_component( name "${PYTHON_EXECUTABLE}" NAME_WE )
    get_filename_component( ext "${PYTHON_EXECUTABLE}" EXT )
    
    if( NOT name STREQUAL "python" )
      if(WIN32)
        set( command "copy_if_different" )
      else()
        set( command "create_symlink" )
      endif()
      add_custom_command( TARGET install-${component} POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E "${command}" "${name}${ext}" "python${ext}"
        WORKING_DIRECTORY "$(BRAINVISA_INSTALL_PREFIX)/bin")
    endif()

    find_program(IPYTHON_EXECUTABLE ipython PATHS ${PYTHON_BIN_DIR} ${PYTHON_BIN_DIR}/Scripts NO_DEFAULT_PATH)
    find_program(PYCOLOR_EXECUTABLE pycolor PATHS ${PYTHON_BIN_DIR} ${PYTHON_BIN_DIR}/Scripts NO_DEFAULT_PATH)
  
    BRAINVISA_INSTALL( FILES "${REAL_PYTHON_EXECUTABLE}" "${IPYTHON_EXECUTABLE}" "${PYCOLOR_EXECUTABLE}"
      DESTINATION "bin"
      COMPONENT "${component}"
      PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )
  
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${PYTHON_LIBRARY} )
  
    # all python modules are copied in install directory but in theory, we should not copy site-packages subdirectory
    # the content of site-packages should be described in different packages.
    #BRAINVISA_INSTALL_DIRECTORY( "${PYTHON_MODULES_PATH}" "lib/python${PYTHON_SHORT_VERSION}" "${component}" )
    BRAINVISA_INSTALL(DIRECTORY "${PYTHON_MODULES_PATH}"
      DESTINATION "lib"
      USE_SOURCE_PERMISSIONS
      COMPONENT "${component}"
    )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()

endfunction()


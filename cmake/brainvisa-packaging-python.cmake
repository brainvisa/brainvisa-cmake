find_package( python )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${PYTHON_VERSION}" PARENT_SCOPE )
  IF( NOT WIN32 )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libreadline5 RUN )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libncurses5 RUN )
  ENDIF()
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libsqlite3-0 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libssl RUN )
  # dependency due to matplotlib: some backends are linked to cairo
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libcairo2 RUN )
  if( WIN32 )
    # dependency due to matplotlib: some backends are linked to freetype
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libfreetype6 RUN )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(PYTHON_FOUND)
    # Find the real path of python executable
    get_filename_component( REAL_PYTHON_EXECUTABLE "${PYTHON_EXECUTABLE}" REALPATH )
    get_filename_component( PYTHON_BIN_DIR "${REAL_PYTHON_EXECUTABLE}" PATH )

    if( APPLE )
      get_filename_component( PYTHON_DIR "${PYTHON_BIN_DIR}" PATH )
      if( EXISTS "${PYTHON_DIR}/Resources/Python.app" )
        set( _python_app TRUE )
      endif()
    endif()

    find_program(IPYTHON_EXECUTABLE ipython PATHS ${PYTHON_BIN_DIR} ${PYTHON_BIN_DIR}/Scripts NO_DEFAULT_PATH)
    find_program(PYCOLOR_EXECUTABLE pycolor PATHS ${PYTHON_BIN_DIR} ${PYTHON_BIN_DIR}/Scripts NO_DEFAULT_PATH)

    set( _instfiles )
    if( IPYTHON_EXECUTABLE )
      list( APPEND _instfiles "${IPYTHON_EXECUTABLE}" )
    endif()
    if( PYCOLOR_EXECUTABLE )
      list( APPEND _instfiles "${PYCOLOR_EXECUTABLE}" )
    endif()

    if( _python_app )
      if( _instfiles )
        BRAINVISA_INSTALL( FILES ${_instfiles}
        DESTINATION "bin"
        COMPONENT "${component}"
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )
      endif()
      BRAINVISA_INSTALL( DIRECTORY "${PYTHON_DIR}/Resources/Python.app"
      DESTINATION "bin"
      COMPONENT "${component}"
      USE_SOURCE_PERMISSIONS )
      add_custom_command( TARGET install-${component} POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "Python.app/Contents/MacOS/Python" "python"
        WORKING_DIRECTORY "$(BRAINVISA_INSTALL_PREFIX)/bin")
    else()
      
      # copy or create a link named python that starts the real python executable (ex. python -> python2.6)
      get_filename_component( name "${PYTHON_EXECUTABLE}" NAME )
      if( NOT name STREQUAL "python" )
        if(WIN32)
          set( command "copy_if_different" )
        else()
          set( command "create_symlink" )
        endif()
        add_custom_command( TARGET install-${component} POST_BUILD
          COMMAND "${CMAKE_COMMAND}" -E "${command}" "${name}" "python${CMAKE_EXECUTABLE_SUFFIX}"
          WORKING_DIRECTORY "$(BRAINVISA_INSTALL_PREFIX)/bin")
      endif()

      BRAINVISA_INSTALL( FILES "${REAL_PYTHON_EXECUTABLE}"
      DESTINATION "bin"
      COMPONENT "${component}"
      PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )

      if( NOT WIN32 )
        BRAINVISA_INSTALL( FILES ${_instfiles}
        DESTINATION "bin"
        COMPONENT "${component}"
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )
      endif()

    endif()

    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${PYTHON_LIBRARY} )
  
    # all python modules are copied in install directory but in theory, we should not copy site-packages subdirectory
    # the content of site-packages should be described in different packages.
    if(WIN32)
      find_program(IPYTHON_SCRIPT ipython-script.py PATHS ${PYTHON_BIN_DIR} ${PYTHON_BIN_DIR}/Scripts NO_DEFAULT_PATH)
      find_program(PYCOLOR_SCRIPT pycolor-script.py PATHS ${PYTHON_BIN_DIR} ${PYTHON_BIN_DIR}/Scripts NO_DEFAULT_PATH)

      set(PYTHON_DLLS "${PYTHON_BIN_DIR}/DLLs")
      set(PYTHON_DOC "${PYTHON_BIN_DIR}/Doc")
      #set(PYTHON_SCRIPTS "${PYTHON_BIN_DIR}/Scripts")
      set(PYTHON_SIP "${PYTHON_BIN_DIR}/sip")
      set(PYTHON_TCL "${PYTHON_BIN_DIR}/tcl")
      set(PYTHON_TOOLS "${PYTHON_BIN_DIR}/tools")
      set(PYTHON_XMLDOC "${PYTHON_BIN_DIR}/xmldoc")
      set(PYTHON_SUBDIRS "${PYTHON_MODULES_PATH}" "${PYTHON_DLLS}" "${PYTHON_DOC}" "${PYTHON_SIP}" "${PYTHON_TCL}" "${PYTHON_TOOLS}" "${PYTHON_XMLDOC}")

      BRAINVISA_INSTALL( DIRECTORY ${PYTHON_SUBDIRS}
                         DESTINATION "lib/python" 
                         USE_SOURCE_PERMISSIONS
                         COMPONENT "${component}" )

      if( IPYTHON_SCRIPT )
        BRAINVISA_INSTALL( FILES "${IPYTHON_SCRIPT}"
                          RENAME ipython.py
                          DESTINATION "bin"
                          COMPONENT "${component}"
                          PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )
      endif()

      if( PYCOLOR_SCRIPT )
        BRAINVISA_INSTALL( FILES "${PYCOLOR_SCRIPT}"
                          RENAME pycolor.py
                          DESTINATION "bin"
                          COMPONENT "${component}"
                          PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )
      endif()
    else()
      BRAINVISA_INSTALL(DIRECTORY "${PYTHON_MODULES_PATH}"
        DESTINATION "lib"
        USE_SOURCE_PERMISSIONS
        COMPONENT "${component}"
      )
    endif()

    # install pyconfig.h file since it may be required by some packages
    # using distutils (like matplotlib)
    find_file( pyconfig "pyconfig.h" PYTHON_INCLUDE_PATH )
    if( pyconfig )
      BRAINVISA_INSTALL( FILES "${pyconfig}"
        DESTINATION "include/python${PYTHON_SHORT_VERSION}"
        COMPONENT "${component}"
        PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ )
    endif()

    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()

endfunction()


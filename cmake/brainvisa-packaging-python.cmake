find_package( python )

function( BRAINVISA_PYTHON_HAS_MODULE module result )
  set( ${result} -1 )
  execute_process( COMMAND "${PYTHON_EXECUTABLE}" "-c" "import ${module}"
    RESULT_VARIABLE ${result} OUTPUT_VARIABLE _out ERROR_VARIABLE _err )
  set( ${result} ${${result}} PARENT_SCOPE )
endfunction()

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
  BRAINVISA_PYTHON_HAS_MODULE( "zmq" _res )
  if( _res EQUAL 0 )
    find_package( LibZmq )
    if( LIBZMQ_FOUND )
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libzmq RUN )
    endif()
    find_package( LibPgm )
    if( LIBPGM_FOUND )
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libpgm RUN )
    endif()
  endif()
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
        COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "Python.app/Contents/MacOS/Python" "$(BRAINVISA_INSTALL_PREFIX)/bin/python")
    else()
      
      # copy or create a link named python that starts the real python executable (ex. python -> python2.6)
      get_filename_component( name "${REAL_PYTHON_EXECUTABLE}" NAME )
      if( NOT name STREQUAL "python" )
        if(WIN32)
          add_custom_command( TARGET install-${component} POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E "copy_if_different" "$(BRAINVISA_INSTALL_PREFIX)/bin/${name}" "$(BRAINVISA_INSTALL_PREFIX)/bin/python" )
        else()
          add_custom_command( TARGET install-${component} POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "${name}" "$(BRAINVISA_INSTALL_PREFIX)/bin/python" )
        endif()
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
        FOREACH(_instfile ${_instfiles})
          get_filename_component( _instname "${_instfile}" NAME )
          add_custom_command( TARGET install-${component} POST_BUILD
          COMMAND "sed" "'1" "s/.*[pP]ython.*/\\#\\!\\/usr\\/bin\\/env" "python/'" "$(BRAINVISA_INSTALL_PREFIX)/bin/${_instname}" ">$(BRAINVISA_INSTALL_PREFIX)/bin/${_instname}_temp"
          COMMAND "${CMAKE_COMMAND}" -E "copy" "$(BRAINVISA_INSTALL_PREFIX)/bin/${_instname}_temp" "$(BRAINVISA_INSTALL_PREFIX)/bin/${_instname}"
          COMMAND "${CMAKE_COMMAND}" -E "remove" "$(BRAINVISA_INSTALL_PREFIX)/bin/${_instname}_temp"
          COMMAND "chmod" "a+rx" "$(BRAINVISA_INSTALL_PREFIX)/bin/${_instname}" )
        endforeach()
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

      if( "${PYTHON_BIN_DIR}" STREQUAL "/usr/bin" )
        # Ubuntu typical system install
        add_custom_command( TARGET install-${component} PRE_BUILD
          COMMAND if [ -n \"$(BRAINVISA_INSTALL_PREFIX)\" ]\;then ${PYTHON_EXECUTABLE} "${CMAKE_BINARY_DIR}/bin/bv_copy_tree" -e "${PYTHON_MODULES_PATH}/dist-packages" "/usr/lib/python${PYTHON_SHORT_VERSION}" "$(BRAINVISA_INSTALL_PREFIX)/lib" \;else ${PYTHON_EXECUTABLE} "${CMAKE_BINARY_DIR}/bin/bv_copy_tree" -e "${PYTHON_MODULES_PATH}" "/usr/lib/python${PYTHON_SHORT_VERSION}" "${CMAKE_INSTALL_PREFIX}/lib" \; fi )

        # fix wrong _get_default_scheme() in sysconfig.py on Ubuntu 12.04
        add_custom_command( TARGET install-${component} POST_BUILD
          COMMAND "sed" "\"s/        return 'posix_local'.*/        return 'posix_prefix'/\"" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/sysconfig.py" ">$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/sysconfig_temp.py"
          COMMAND "${CMAKE_COMMAND}" -E "copy" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/sysconfig_temp.py" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/sysconfig.py"
          COMMAND "${CMAKE_COMMAND}" -E "remove" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/sysconfig_temp.py" )

        set( _toinstall
          "/usr/lib/python${PYTHON_SHORT_VERSION}/dist-packages/*"
          "/usr/lib/pymodules/python${PYTHON_SHORT_VERSION}/*"
          "/usr/lib/pyshared/python${PYTHON_SHORT_VERSION}/*"
          "/usr/share/pyshared/*"
           )

        add_custom_command( TARGET install-${component} PRE_BUILD
          COMMAND if [ -n \"$(BRAINVISA_INSTALL_PREFIX)\" ]\;then ${CMAKE_COMMAND} -E make_directory "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages" \; ${PYTHON_EXECUTABLE} "${CMAKE_BINARY_DIR}/bin/bv_copy_tree" ${_toinstall} "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages" \;else ${CMAKE_COMMAND} -E make_directory "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/dist-packages" \; ${PYTHON_EXECUTABLE} "${CMAKE_BINARY_DIR}/bin/bv_copy_tree" ${_toinstall} "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/dist-packages" \;fi )

        BRAINVISA_PYTHON_HAS_MODULE( "matplotlib" _has_mpl )
        if( _has_mpl )
        # patch matplotlib.__init__ to search for the data path
        # this should not be done in brainvisa-install-python-matplotlib
        # since matplotlib.__init__.py file is installed from here in the
        # python component.
        add_custom_command( TARGET install-${component} POST_BUILD
          COMMAND "${PYTHON_EXECUTABLE}" "${brainvisa-cmake_DIR}/brainvisa-packaging-python-matplotlib-patchinit.py" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/matplotlib/__init__.py" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/matplotlib/__init__.py" )
        endif()
        # TODO: add additional /usr/local or /i2bm/... modules

      else() # "${PYTHON_BIN_DIR}" STREQUAL "/usr/bin"

        BRAINVISA_INSTALL(DIRECTORY "${PYTHON_MODULES_PATH}"
          DESTINATION "lib"
          USE_SOURCE_PERMISSIONS
          COMPONENT "${component}"
        )
      endif() # "${PYTHON_BIN_DIR}" STREQUAL "/usr/bin"
    endif()

    # install pyconfig.h file since it may be required by some packages
    # using distutils (like matplotlib)
    find_file( pyconfig "pyconfig.h" ${PYTHON_INCLUDE_PATH} )
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

# this variable declares the install rule for the dev package
set( python-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(PYTHON_FOUND)
#     BRAINVISA_INSTALL_DIRECTORY( "${PYTHON_INCLUDE_PATH}" include ${component}-dev )
    set( directory "${PYTHON_INCLUDE_PATH}" )
    get_filename_component( destination "${PYTHON_INCLUDE_PATH}" NAME )
    set( destination "include/${destination}" )
    # modified copy of BRAINVISA_INSTALL_DIRECTORY
    file( GLOB_RECURSE allFiles RELATIVE "${directory}" FOLLOW_SYMLINKS "${directory}/*" )
    foreach( file ${allFiles} )
      if( NOT "${file}" STREQUAL "pyconfig.h" )
        get_filename_component( path "${file}" PATH )
        get_filename_component( name "${file}" NAME )
        get_filename_component( file2 "${directory}/${path}/${file}" REALPATH )
        if( EXISTS "${directory}/${path}/${name}" )
          if( IS_DIRECTORY "${file2}" )
            BRAINVISA_INSTALL_DIRECTORY( "${file2}" "${destination}/${path}" "${component}-dev" )
          else()
            BRAINVISA_INSTALL( PROGRAMS "${file2}"
              DESTINATION "${destination}/${path}"
              COMPONENT "${component}-dev" )
          endif()
        else()
          message( "Warning: file \"${directory}/${path}/${name}\" does not exist (probably an invalid link)" )
        endif()
      endif()
    endforeach()
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


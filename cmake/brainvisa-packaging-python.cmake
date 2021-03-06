find_package( python )

function( BRAINVISA_PYTHON_HAS_MODULE module result)
  set( ${result} -1 )
  execute_process( COMMAND "${PYTHON_EXECUTABLE}" "-c" "import ${module}"
    RESULT_VARIABLE ${result} OUTPUT_VARIABLE _out ERROR_VARIABLE _err )
  set( ${result} ${${result}} PARENT_SCOPE )
endfunction()

# function( BRAINVISA_PYTHON_GET_MODULE_FILE module result)
#   set( ${result} )
#   execute_process( COMMAND "${PYTHON_EXECUTABLE}" 
#                            "-c" "from __future__ import print_function;import os,${module};f, e = os.path.splitext(${module}.__file__);print(f + '.py' if e == '.pyc' else f, end='')"
#     RESULT_VARIABLE _result_code OUTPUT_VARIABLE _out ERROR_VARIABLE _err )
#   
#   if( ${_result_code} EQUAL 0 )
#     set(${result} ${${_out}})
#   endif()
#   
#   set( ${result} ${${_result}} PARENT_SCOPE )
# endfunction()

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
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libbz2 RUN )

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
  
  BRAINVISA_PYTHON_HAS_MODULE( "yaml" _res )
  if( _res EQUAL 0 )
    find_package( LibYaml )
    
    if( YAML_FOUND )
      BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN RECOMMENDS libyaml RUN )
    endif()
  endif()
  
  if(WIN32 OR APPLE)
    find_package( Freetype )
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

    set( _find_exe ipython pycolor pip easy_install activate
          activate.csh activate.fish activate_this.py jupyter jupyter-run
          jupyter-bundlerextension jupyter-console jupyter-kernelspec
          jupyter-migrate jupyter-nbconvert jupyter-nbextension
          jupyter-notebook jupyter-qtconsole jupyter-serverextension
          jupyter-troubleshoot jupyter-trust )
    set( _instfiles )
    foreach( _exe ${_find_exe} )
      unset( _exe_path CACHE )
      find_program( _exe_path ${_exe}
        HINTS ${PYTHON_BIN_DIR} ${PYTHON_BIN_DIR}/Scripts)
      if( _exe_path )
        get_filename_component( _real_exe_path "${_exe_path}" REALPATH )
        list( APPEND _instfiles "${_real_exe_path}" )
      endif()
      unset( _exe_path CACHE )
    endforeach()

    if( _python_app )
      # Mac case
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
      # get "python2" or "python3" command or symlink
      string( SUBSTRING ${PYTHON_SHORT_VERSION} 0 1 _python_major )
      set( _pythonv "python${_python_major}" )
      add_custom_command( TARGET install-${component} POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "Python.app/Contents/MacOS/Python" "$(BRAINVISA_INSTALL_PREFIX)/bin/${_pythonv}" )
      add_custom_command( TARGET install-${component} POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "Python.app/Contents/MacOS/Python" "$(BRAINVISA_INSTALL_PREFIX)/bin/python${PYTHON_SHORT_VERSION}" )
        
      # re-create the framework structure in lib/
      add_custom_command( TARGET install-${component} POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E "make_directory" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Versions/${PYTHON_SHORT_VERSION}"
        COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "Versions/Current/Headers" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Headers"
        COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "Versions/Current/Python" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Python"
        COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "Versions/Current/Resources" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Resources"
        COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "${PYTHON_SHORT_VERSION}" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Versions/Current"
        COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "include/python${PYTHON_SHORT_VERSION}" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Versions/${PYTHON_SHORT_VERSION}/Headers"
        COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "../../.." "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Versions/${PYTHON_SHORT_VERSION}/lib"
        COMMAND "${CMAKE_COMMAND}" -E "copy" "${PYTHON_DIR}/Python" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Versions/${PYTHON_SHORT_VERSION}/Python"
        COMMAND "${CMAKE_COMMAND}" -E "copy_directory" "${PYTHON_DIR}/Resources" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Versions/${PYTHON_SHORT_VERSION}/Resources"
        COMMAND "${CMAKE_COMMAND}" -E "copy_directory" "${PYTHON_DIR}/bin" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Versions/${PYTHON_SHORT_VERSION}/bin"
        COMMAND "${CMAKE_COMMAND}" -E "copy_directory" "${PYTHON_DIR}/include" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Versions/${PYTHON_SHORT_VERSION}/include"
        COMMAND "${CMAKE_COMMAND}" -E "copy_directory" "${PYTHON_DIR}/share" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Versions/${PYTHON_SHORT_VERSION}/share"
      )
      file( GLOB _files "${PYTHON_DIR}/lib/*" )
      list( REMOVE_ITEM _files "${PYTHON_DIR}/lib/python${PYTHON_SHORT_VERSION}" )
      foreach( _file ${_files} )
        if( IS_SYMLINK "${file}" )
          file( READ_SYMLINK "${file}" _link )
          get_filename_component( _relfile "${file}" NAME )
          add_custom_command( TARGET install-${component} POST_BUILD 
            COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "${_link}" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Versions/${PYTHON_SHORT_VERSION}/lib/${_relfile}"
          )
        else()
          add_custom_command( TARGET install-${component} POST_BUILD 
            COMMAND "${CMAKE_COMMAND}" -E "copy" "${_file}" "$(BRAINVISA_INSTALL_PREFIX)/lib/Python.framework/Versions/${PYTHON_SHORT_VERSION}/lib/"
          )
        endif()
      endforeach()

    else()

      # Non-Mac case

      # copy or create a link named python that starts the real python executable (ex. python -> python2.7)
      get_filename_component( name "${REAL_PYTHON_EXECUTABLE}" NAME )
      if( NOT name STREQUAL "python" )
        if(WIN32)
          add_custom_command( TARGET install-${component} POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E "copy_if_different" "$(BRAINVISA_INSTALL_PREFIX)/bin/${name}" "$(BRAINVISA_INSTALL_PREFIX)/bin/python${CMAKE_EXECUTABLE_SUFFIX}" )
        else()
          add_custom_command( TARGET install-${component} POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "${name}" "$(BRAINVISA_INSTALL_PREFIX)/bin/python" )
        endif()
      endif()
      # get "python2" or "python3" command or symlink
      string( SUBSTRING ${PYTHON_SHORT_VERSION} 0 1 _python_major )
      set( _pythonv "python${_python_major}" )
      if( NOT name STREQUAL ${_pythonv} )
        if(WIN32)
          add_custom_command( TARGET install-${component} POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E "copy_if_different" "$(BRAINVISA_INSTALL_PREFIX)/bin/${name}" "$(BRAINVISA_INSTALL_PREFIX)/bin/${_pythonv}${CMAKE_EXECUTABLE_SUFFIX}" )
        else()
          add_custom_command( TARGET install-${component} POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E "create_symlink" "${name}" "$(BRAINVISA_INSTALL_PREFIX)/bin/${_pythonv}" )
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
        foreach(_instfile ${_instfiles})
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

    # all python modules are copied in install directory but in theory, we
    # should not copy site-packages subdirectory
    # the content of site-packages should be described in different packages.
    if(WIN32)
      find_program(IPYTHON_SCRIPT ipython-script.py HINTS ${PYTHON_BIN_DIR} ${PYTHON_BIN_DIR}/Scripts)
      find_program(PYCOLOR_SCRIPT pycolor-script.py HINTS ${PYTHON_BIN_DIR} ${PYTHON_BIN_DIR}/Scripts)

      set(PYTHON_DLLS "${PYTHON_BIN_DIR}/DLLs")
      set(PYTHON_DOC "${PYTHON_BIN_DIR}/Doc")
      set(PYTHON_LIB "${PYTHON_BIN_DIR}/Lib")
      set(PYTHON_SCRIPTS "${PYTHON_BIN_DIR}/Scripts")
      set(PYTHON_SIP "${PYTHON_BIN_DIR}/sip")
      set(PYTHON_TCL "${PYTHON_BIN_DIR}/tcl")
      set(PYTHON_TOOLS "${PYTHON_BIN_DIR}/Tools")
      #set(PYTHON_XMLDOC "${PYTHON_BIN_DIR}/xmldoc")
      set(PYTHON_SUBDIRS "${PYTHON_DLLS}" "${PYTHON_LIB}" "${PYTHON_DOC}" 
                         "${PYTHON_SCRIPTS}" "${PYTHON_SIP}" "${PYTHON_TCL}"
                         "${PYTHON_TOOLS}")

      # copy python2 / python3 exe
      BRAINVISA_INSTALL( FILES "${REAL_PYTHON_EXECUTABLE}"
                         DESTINATION "bin"
                         RENAME "${_pythonv}.exe"
                         COMPONENT "${component}"
                         PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )
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
    else() # not WIN32

      if( "${PYTHON_BIN_DIR}" STREQUAL "/usr/bin"
          OR "${PYTHON_BIN_DIR}" STREQUAL "${CMAKE_BINARY_DIR}/bin" )
        set( _inv_pypath ${PYTHON_MODULES_PATH} )
        if( _inv_pypath )
          # if _inv_pypath is empty, list( REVERSE ) fails...
          list( REVERSE _inv_pypath )
        endif()

        # get python main version
        string( REGEX MATCH "([^.]+)" py_version ${PYTHON_SHORT_VERSION} )

        set( _toinstall )
        set( _uicpdir )
        set( _pyside1 )
        set( _pyside2 )
        set( _pyside3 )
        set( _dirs )
        set( _exclude_modules "torch" )
        set( _exclude )

        foreach( _pypath ${_inv_pypath} )
          set( _already_done )
          foreach( _done_path ${_toinstall} )
            string( FIND "${_pypath}" "${_done_path}/" _done )
            if( _done EQUAL 0 )
              set( _already_done TRUE )
              break()
            endif()
          endforeach()
          if( NOT _already_done )
            list( APPEND _toinstall "${_pypath}" )
            list( APPEND _dirs "lib" )
            foreach( _modpath "dist-packages" ) ## "site-packages" )
              if( EXISTS "${_pypath}/${_modpath}" )
                  if( EXISTS "${_pypath}/${_modpath}/PyQt4/uic/widget-plugins" )
                    list( APPEND _uicpdir
                      "${_pypath}/${_modpath}/PyQt4/uic/widget-plugins" )
                  endif()
                  if( EXISTS "${_pypath}/${_modpath}/PySide" )
                    list( APPEND _pyside1 "${_pypath}/${_modpath}/PySide" )
                  endif()
    #             endif()
                  if( "${_pypath}" STREQUAL
                      "/usr/lib/python${PYTHON_SHORT_VERSION}" )
                    # Ubuntu install
                    if( EXISTS "/usr/lib/pymodules/python${PYTHON_SHORT_VERSION}" )
                      list( APPEND _toinstall
                        "/usr/lib/pymodules/python${PYTHON_SHORT_VERSION}/*" )
                      list( APPEND _dirs
                        "lib/python${PYTHON_SHORT_VERSION}/${_modpath}" )
                    endif()
                    if( EXISTS "/usr/lib/pyshared/python${PYTHON_SHORT_VERSION}" )
                      list( APPEND _toinstall
                        "/usr/lib/pyshared/python${PYTHON_SHORT_VERSION}/*" )
                      list( APPEND _dirs
                        "lib/python${PYTHON_SHORT_VERSION}/${_modpath}" )
                    endif()
                    if( EXISTS "/usr/share/pyshared" )
                      list( APPEND _toinstall
                        "/usr/share/pyshared/*" )
                      list( APPEND _dirs
                        "lib/python${PYTHON_SHORT_VERSION}/${_modpath}" )
                    endif()
                    set( _pyside2
                      "/usr/lib/pyshared/python${PYTHON_SHORT_VERSION}/PySide" )
                    set( _pyside3 "/usr/share/pyshared/PySide" )
                  endif()
                  foreach( _exc_mod ${_exclude_modules} )
                    if( EXISTS "${_pypath}/${_modpath}/${_exc_mod}" )
                      list( APPEND _exclude
                            "-e" "${_pypath}/${_modpath}/${_exc_mod}" )
                    endif()
                  endforeach()
              endif()
            endforeach()
          endif()
        endforeach()
#         set( _toinstall ${_toinstall}
#           "/usr/lib/pymodules/python${PYTHON_SHORT_VERSION}/*"
#           "/usr/lib/pyshared/python${PYTHON_SHORT_VERSION}/*"
#           "/usr/share/pyshared/*"
#         )
#         set( _pyside2 "/usr/lib/pyshared/python${PYTHON_SHORT_VERSION}/PySide" )
#         set( _pyside3 "/usr/share/pyshared/PySide" )

        set( _uicpdir_excl "kde4.py" "kde4.pyc" "qaxcontainer.py" "qaxcontainer.pyc" "qscintilla.py" "qscintilla.pyc" )
        foreach( _excl ${_uicpdir} )
          list( APPEND _exclude "-e" "${_excl}" )
          foreach( _file ${_uicpdir_excl} )
            list( APPEND _exclude "-e" "${_excl}/${_file}" )
          endforeach()
        endforeach()
        foreach( _excl ${_pyside1} ${_pyside2} ${_pyside3} )
          if( EXISTS "${_excl}" )
            list( APPEND _exclude "-e" "${_excl}" )
          endif()
        endforeach()
        set( i 0 )
        set( bv_copy_options1 "" )
        set( bv_copy_options2 "" )
        # we must erase any previous numpy installation before installing it
        # again because some C libs may be installed with non-overlapping
        # names and end-up conflicting:
        # numpy/core/*.x86_64-linux-gnu.so are named without the
        # .x86_64-linux-gnu extension in the newer module, but the former
        # ones are loaded.
        # Same for PyQt, sip, zmq, scipy when they are re-installed manually
        #
        # BUT
        #
        # we mustn't do that systematically on Ubuntu 12.04 since there, we
        # actually must install a mixup of /usr/lib/pythonxx,
        # /usr/lib/pyshared and others which overlap (and even symlink each
        # other...)
        # In fact it depends on the modules and the way they were installed
        # (system modules or upgraded using pip)
        #
        if( NOT LSB_DISTRIB STREQUAL "ubuntu"
            OR LSB_DISTRIB_RELEASE VERSION_GREATER "14.0" )
          set( removed_packages "numpy" "PyQt5" "PyQt4" "zmq" "scipy" "torch" )
        else()
          # on our ubuntu 12 we have upgraded numpy, scipy and zmq using pip.
          # this is specific to our own install, I know.
          set( removed_packages "numpy" "scipy" "zmq" "torch" )
        endif()
        set( bv_copy_options1 "" )
        set( bv_copy_options2 "" )
        foreach( p in ${removed_packages} )
          list( APPEND bv_copy_options1
            "-d" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/${p}"
            "-d" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/site-packages/${p}" )
          list( APPEND bv_copy_options2
            "-d" "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/dist-packages/${p}"
            "-d" "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/site-packages/${p}" )
        endforeach()

        # make a symlink lib/python3 -> lib/python3.6 to avoid duplicating modules
        # in ubuntu installs
        add_custom_command( TARGET install-${component} PRE_BUILD
          COMMAND if [ -n \"$(BRAINVISA_INSTALL_PREFIX)\" ]\;then ${CMAKE_COMMAND} -E create_symlink "python${PYTHON_SHORT_VERSION}" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${py_version}" \; else ${CMAKE_COMMAND} -E create_symlink "python${PYTHON_SHORT_VERSION}" "${CMAKE_INSTALL_PREFIX}/lib/python${py_version}" \; fi )

        foreach( _pypath ${_toinstall} )
          list( GET _dirs ${i} _dir )
          add_custom_command( TARGET install-${component} PRE_BUILD
            COMMAND if [ -n \"$(BRAINVISA_INSTALL_PREFIX)\" ]\;then ${CMAKE_COMMAND} -E make_directory "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages" \; ${PYTHON_HOST_EXECUTABLE} "${CMAKE_BINARY_DIR}/bin/bv_copy_tree" ${bv_copy_options1} ${_exclude} ${_pypath} "$(BRAINVISA_INSTALL_PREFIX)/${_dir}" \; if [ -f "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/site-packages/sip.x86_64-linux-gnu.so" -a -f "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/site-packages/sip.so" ] \; then rm "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/site-packages/sip.x86_64-linux-gnu.so" \; fi \; if [ -f "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/sip.x86_64-linux-gnu.so" -a -f "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/sip.so" ] \; then rm "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/sip.x86_64-linux-gnu.so" \; fi \;else ${CMAKE_COMMAND} -E make_directory "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/dist-packages" \; ${PYTHON_HOST_EXECUTABLE} "${CMAKE_BINARY_DIR}/bin/bv_copy_tree" ${bv_copy_options2} ${_exclude} ${_pypath} "${CMAKE_INSTALL_PREFIX}/${_dir}" \; if [ -f "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/site-packages/sip.x86_64-linux-gnu.so" -a -f "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/site-packages/sip.so" ] \; then rm "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/site-packages/sip.x86_64-linux-gnu.so" \; fi \; if [ -f "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/dist-packages/sip.x86_64-linux-gnu.so" -a -f "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/dist-packages/sip.so" ] \; then rm "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/dist-packages/sip.x86_64-linux-gnu.so" \; fi \; fi )
          math( EXPR i "${i} + 1" )
        endforeach()

        # fix wrong _get_default_scheme() in sysconfig.py on Ubuntu 12.04
        # and remove replacement from /usr/local to /usr
        add_custom_command( TARGET install-${component} POST_BUILD
          COMMAND "${CMAKE_COMMAND}" -E touch "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/sysconfig.py"
          COMMAND "sed" "\"s/        return 'posix_local'.*/        return 'posix_prefix'/\"" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/sysconfig.py" ">$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/sysconfig_temp.py"
          COMMAND "sed" "s/\\.replace\\(\\\"\"\\/usr\\/local\\\",\\\"\\/usr\\\",1\"\\)//" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/sysconfig_temp.py" ">$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/sysconfig.py"
          COMMAND "${CMAKE_COMMAND}" -E "remove" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/sysconfig_temp.py" )

        BRAINVISA_PYTHON_HAS_MODULE( "matplotlib" _has_mpl )
        if( _has_mpl EQUAL 0 )
          # BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS python-matplotlib RUN )
          # patch matplotlib.__init__ to search for the data path
          # this should not be done in brainvisa-install-python-matplotlib
          # since matplotlib.__init__.py file is installed from here in the
          # python component.
          add_custom_command( TARGET install-${component} POST_BUILD
              COMMAND "${PYTHON_HOST_EXECUTABLE}" "${brainvisa-cmake_DIR}/brainvisa-packaging-python-matplotlib-patchinit.py" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/matplotlib/__init__.py" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/matplotlib/__init__.py" )
        endif()
        # TODO: add additional /usr/local or /i2bm/... modules

      else() # "${PYTHON_BIN_DIR}" STREQUAL "/usr/bin"

#         BRAINVISA_INSTALL(DIRECTORY "${PYTHON_MODULES_PATH}"
#           DESTINATION "lib"
#           USE_SOURCE_PERMISSIONS
#           COMPONENT "${component}"
#         )
        # the previous cmake-based copy cannot copy a symlink going outside the
        # copied tree, which happens on Mac for python installed using brew

        add_custom_command( TARGET install-${component} PRE_BUILD
          COMMAND if [ -n \"$(BRAINVISA_INSTALL_PREFIX)\" ]\;then ${CMAKE_COMMAND} -E make_directory "$(BRAINVISA_INSTALL_PREFIX)/lib" \;${PYTHON_HOST_EXECUTABLE} "${CMAKE_BINARY_DIR}/bin/bv_copy_tree" ${PYTHON_MODULES_PATH} "$(BRAINVISA_INSTALL_PREFIX)/lib" \;else ${CMAKE_COMMAND} -E make_directory "${CMAKE_INSTALL_PREFIX}/lib" \; ${PYTHON_HOST_EXECUTABLE} "${CMAKE_BINARY_DIR}/bin/bv_copy_tree" ${PYTHON_MODULES_PATH} "${CMAKE_INSTALL_PREFIX}/lib" \;fi )

      endif() # "${PYTHON_BIN_DIR}" STREQUAL "/usr/bin"
      
    
      # Get additional site-packages directories
      execute_process(
        COMMAND ${REAL_PYTHON_EXECUTABLE} "${brainvisa-cmake_DIR}/findpysitepackages.py" "${PYTHON_MODULES_PATH}"
        OUTPUT_VARIABLE _pypath_list )
      if(CMAKE_CROSSCOMPILING AND COMMAND TARGET_TO_HOST_PATH)
        TARGET_TO_HOST_PATH("${_pypath_list}" _pypath_list)
      endif()
    
#       set( _inv_pypath ${_pypath_list} )
#       if( _inv_pypath )
#         # if _inv_pypath is empty, list( REVERSE ) fails...
#         list( REVERSE _inv_pypath )
#       endif()
#       foreach( _pypath ${_inv_pypath} )
#         add_custom_command( TARGET install-${component} PRE_BUILD
#           COMMAND if [ -n \"$(BRAINVISA_INSTALL_PREFIX)\" ]\; then ${PYTHON_HOST_EXECUTABLE} "${CMAKE_BINARY_DIR}/bin/bv_copy_tree" "${_pypath}" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}" \; else ${PYTHON_HOST_EXECUTABLE} "${CMAKE_BINARY_DIR}/bin/bv_copy_tree" "${_pypath}"  "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}" \; fi )
#       endforeach()
    endif() # if WIN32 .. else

    # install pyconfig.h file since it may be required by some packages
    # using distutils (like matplotlib)
    find_file( pyconfig "pyconfig.h" ${PYTHON_INCLUDE_PATH} )
    if( pyconfig )
      BRAINVISA_INSTALL( FILES "${pyconfig}"
        DESTINATION "include/python${PYTHON_SHORT_VERSION}"
        COMPONENT "${component}"
        PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ )
    endif()

    # virtualenv build dir should already be taken into account by
    # the site-packages (findpysitepackages.py) above

#     # Install lib/python${PYTHON_SHORT_VERSION}/site-packages/*
#     # from build dir because it is here that are installed modules
#     # with pip and virtualenv
#     set(site_packages "${CMAKE_BINARY_DIR}/lib/python${PYTHON_SHORT_VERSION}/site-packages")
#     file(GLOB modules RELATIVE "${site_packages}" "${site_packages}/*")
#     foreach(m ${modules})
#         if((NOT m MATCHES ".*\\.egg-info") AND
#            (NOT m MATCHES "distribute.*\\.egg") AND
#            (NOT m MATCHES "pip.*\\.egg") AND
#            (NOT m STREQUAL "easy-install.pth") AND
#            (NOT m STREQUAL "setuptools.pth"))
#             set(fp "${site_packages}/${m}")
#             if(IS_DIRECTORY "${fp}")
#                 BRAINVISA_INSTALL(DIRECTORY "${fp}"
#                     DESTINATION "lib/python${PYTHON_SHORT_VERSION}/site-packages"
#                     USE_SOURCE_PERMISSIONS
#                     COMPONENT "${component}")
#             else()
#                 BRAINVISA_INSTALL(FILES "${fp}"
#                     DESTINATION "lib/python${PYTHON_SHORT_VERSION}/site-packages"
#                     PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ
#                     COMPONENT "${component}")
#             endif()
#         endif()
#     endforeach()

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
        get_filename_component( file2 "${directory}/${path}/${name}" REALPATH )
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


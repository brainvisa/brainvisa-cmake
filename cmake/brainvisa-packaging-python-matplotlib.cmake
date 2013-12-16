find_package( Numpy )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "1.0.0" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS python-numpy RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if( NUMPY_FOUND AND EXISTS "/usr/share/matplotlib" )
    BRAINVISA_INSTALL_DIRECTORY( "/usr/share/matplotlib" "lib/python${PYTHON_SHORT_VERSION}/dist-packages/matplotlib" ${component} )
    # patch matplotlib.__init__ to search for the data path
    add_custom_command( TARGET install-${component} POST_BUILD
        COMMAND "sed" "\"s/ *raise RuntimeError\('Could not find the matplotlib data files'\)/#    raise RuntimeError\('Could not find the matplotlib data files'\)/\"" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/matplotlib/__init__.py" ">$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/matplotlib/__init__temp.py"
        COMMAND "${CMAKE_COMMAND}" -E "copy" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/matplotlib/__init__temp.py" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/matplotlib/__init__.py"
        COMMAND "${CMAKE_COMMAND}" -E "remove" "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages/matplotlib/__init__temp.py" )

    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


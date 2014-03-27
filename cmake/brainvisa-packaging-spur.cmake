find_package( python )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "CATI" PARENT_SCOPE )
  set( ${package_version} "1.0.0" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS python RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  execute_process( COMMAND ${PYTHON_EXECUTABLE} -c "import spur, os; print os.path.dirname(spur.__file__)" OUTPUT_VARIABLE spur_directory OUTPUT_STRIP_TRAILING_WHITESPACE )
  if( spur_directory )
    BRAINVISA_INSTALL_DIRECTORY( "${spur_directory}" "lib/python${PYTHON_SHORT_VERSION}/dist-packages/spur" ${component} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()


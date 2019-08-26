find_package( python )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "NeuroSpin" PARENT_SCOPE )
  set( ${package_version} "1.0.0" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS python-numpy RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )

  if( NOT WIN32)
    # note: for now windows package for python contains everything in a
    # monolythic way so torch will get installed in the python package.
    execute_process( COMMAND ${PYTHON_EXECUTABLE} "-c" "from __future__ import print_function; import torch; print(torch.__file__)"
                    OUTPUT_VARIABLE _torch_mod_file
                    RESULT_VARIABLE _res )
    if( _res EQUAL 0 )
      get_filename_component( _torch_mod_dir "${_torch_mod_file}" DIRECTORY )
      add_custom_command( TARGET install-${component} PRE_BUILD
              COMMAND if [ -n \"$(BRAINVISA_INSTALL_PREFIX)\" ]\;then ${CMAKE_COMMAND} -E make_directory "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages" \; ${PYTHON_HOST_EXECUTABLE} "${CMAKE_BINARY_DIR}/bin/bv_copy_tree" ${_torch_mod_dir} "$(BRAINVISA_INSTALL_PREFIX)/lib/python${PYTHON_SHORT_VERSION}/dist-packages" \;else ${CMAKE_COMMAND} -E make_directory "${CMAKE_INSTALL_PREFIX}/lib/python${PYTHON_SHORT_VERSION}/dist-packages" \; ${PYTHON_HOST_EXECUTABLE} "${CMAKE_BINARY_DIR}/bin/bv_copy_tree" ${_torch_mod_dir} "${CMAKE_INSTALL_PREFIX}/lib/${PYTHON_SHORT_VERSION}/dist-packages" \; fi )
    endif()
  endif()

endfunction()

# this variable declares the install rule for the dev package
set( python-scikit-learn-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
#   if(PYTORCH_FOUND)  # FIXME
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
#   else()
#     set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
#   endif()
endfunction()

find_package( Python )  # FIXME

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "NeuroSpin" PARENT_SCOPE )
  set( ${package_version} "${PYTHON_VERSION}" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS python RUN )
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  # nothing to package, it is already in python package
endfunction()

# this variable declares the install rule for the dev package
set( python-scikit-learn-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
#   if(PANDAS_FOUND)  # FIXME
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
#   else()
#     set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
#   endif()
endfunction()

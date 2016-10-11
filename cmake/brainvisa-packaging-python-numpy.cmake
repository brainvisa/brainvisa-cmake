find_package( Numpy )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "${NUMPY_VERSION}" PARENT_SCOPE )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS python RUN )
  if (NOT (WIN32 AND CMAKE_CROSSCOMPILING) )
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS liblapack3gf RUN )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  # nothing to package, it is already in python package
endfunction()

# this variable declares the install rule for the dev package
set( python-numpy-dev-installrule TRUE )

function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
  if(NUMPY_FOUND)
    set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

find_package( LibPgm )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  # Find version
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  if(PC_LIBXML_VERSION)
    set(${package_version} ${PC_LIBXML_VERSION} PARENT_SCOPE )
  endif()
  if(WIN32)
    BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libiconv RUN )
  endif()
endfunction()


function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  if(NOT APPLE)
    if(LIBPGM_FOUND)
      BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${LIBPGM_LIBRARIES} )
      set(${component}_PACKAGED TRUE PARENT_SCOPE)
    else()
      set(${component}_PACKAGED FALSE PARENT_SCOPE)
    endif()
  endif()
endfunction()

# # this variable declares the install rule for the dev package
# set( libpgm-dev-installrule TRUE )
#
# function( BRAINVISA_PACKAGING_COMPONENT_DEV component )
#   if(LIBPGM_FOUND)
#     BRAINVISA_INSTALL_DIRECTORY( "${LIBPGM_INCLUDE_DIR}" include
#       ${component}-dev )
#     set(${component}-dev_PACKAGED TRUE PARENT_SCOPE)
#   else()
#     set(${component}-dev_PACKAGED FALSE PARENT_SCOPE)
#   endif()
# endfunction()
#

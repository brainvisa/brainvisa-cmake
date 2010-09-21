find_package( vtkINRIA3D )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  if(VTK_MAJOR_VERSION)
    set( ${package_version} "${vtkINRIA3D_MAJOR_VERSION}.${vtkINRIA3D_MINOR_VERSION}" PARENT_SCOPE )
  endif()

  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libvtk5-dev RUN )
endfunction()

function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  # libraries
  set(vtkINRIA3D_LIBRARIES)
  foreach( library "vtkVisuManagement" "vtkDataManagement"
      "vtkHWShading" "vtkRenderingAddOn" "vtkHelpers")
      find_library(vtkINRIA3D_lib "${library}")
      if(vtkINRIA3D_lib)
        set( vtkINRIA3D_LIBRARIES ${vtkINRIA3D_LIBRARIES} "${vtkINRIA3D_lib}" )
      endif()
      unset(vtkINRIA3D_lib)
      unset(vtkINRIA3D_lib CACHE)
  endforeach()
  BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${vtkINRIA3D_LIBRARIES} )
endfunction()

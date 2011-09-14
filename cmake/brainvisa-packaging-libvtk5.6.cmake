find_package( VTK )

function( BRAINVISA_PACKAGING_COMPONENT_INFO component package_name package_maintainer package_version )
  set( ${package_name} ${component} PARENT_SCOPE )
  set( ${package_maintainer} "IFR 49" PARENT_SCOPE )
  set( ${package_version} "0.0.0" PARENT_SCOPE )
  if(VTK_MAJOR_VERSION)
    set( ${package_version} "${VTK_MAJOR_VERSION}.${VTK_MINOR_VERSION}.${VTK_BUILD_VERSION}" PARENT_SCOPE )
  endif()

  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libexpat1 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libjpeg62 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libpng12-0 RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libtiff RUN )
  BRAINVISA_THIRDPARTY_DEPENDENCY( "${component}" RUN DEPENDS libstdc++6 RUN )
endfunction()

function( BRAINVISA_PACKAGING_COMPONENT_RUN component )
  # libraries
  if(VTK_FOUND)
    set(VTK_LIBRARIES)
    foreach( library "vtkverdict" "vtkCommon" "vtkDICOMParser"
        "vtkexoIIc" "vtkexpat" "vtkFiltering" "vtkfreetype" "vtkftgl"
        "vtkGenericFiltering" "vtkGraphics" "vtkHybrid" "vtkImaging"
        "vtkInfovis" "vtkIO" "vtkjpeg" "vtklibxml2" "vtkmetaio"
        "vtkNetCDF" "vtkpng" "vtkRendering" "vtksys" "vtktiff"
        "vtkViews" "vtkVolumeRendering" "vtkWidgets" "vtkzlib" "vtksqlite" "vtkParallel")
        find_library( vtk_lib ${library} ${VTK_LIBRARY_DIRS} NO_DEFAULT_PATH )
        find_library( vtk_lib ${library} ${VTK_LIBRARY_DIRS} )
        if(vtk_lib)
          set( VTK_LIBRARIES ${VTK_LIBRARIES} "${vtk_lib}" )
        endif()
        unset(vtk_lib)
        unset(vtk_lib CACHE)
    endforeach()
    BRAINVISA_INSTALL_RUNTIME_LIBRARIES( ${component} ${VTK_LIBRARIES} )
    set(${component}_PACKAGED TRUE PARENT_SCOPE)
  else()
    set(${component}_PACKAGED FALSE PARENT_SCOPE)
  endif()
endfunction()

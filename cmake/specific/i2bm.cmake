if( IS_DIRECTORY /i2bm )
  message( STATUS "Add specific paths for CEA - I2BM research labs" )
  execute_process( COMMAND "${CMAKE_BINARY_DIR}/bin/bv_system_info" RESULT_VARIABLE result OUTPUT_VARIABLE output OUTPUT_STRIP_TRAILING_WHITESPACE )
  if( result EQUAL 0 )
    list( FIND CMAKE_PREFIX_PATH "/i2bm/brainvisa/${output}" result )
    if( result EQUAL -1 )
      set( CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "/i2bm/brainvisa/${output}" )
      foreach( soft dcmtk gsl vtkinria3d/lib )
        set( CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "/i2bm/brainvisa/${output}/${soft}" )
      endforeach()
      # Force to use VTK version installed in /i2bm/brainvisa by default
      file( GLOB VTK_DIR /i2bm/brainvisa/${output}/vtk/lib/vtk-* )
      if( VTK_DIR )
        set( VTK_DIR "${VTK_DIR}" CACHE PATH "The directory containing VTKConfig.cmake" )
      endif()
      file( GLOB QMAKE "/i2bm/brainvisa/${output}/bin/qmake-qt4" )
      if( QMAKE )
        set( QT_QMAKE_EXECUTABLE ${QMAKE} CACHE STRING "Qt4 qmake executable" )
      endif()
    else()
      list( FIND CMAKE_PREFIX_PATH "/i2bm/research/${output}" result )
      if( result EQUAL -1 )
        set( CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "/i2bm/research/${output}" )
        foreach( soft dcmtk gsl vtkinria3d/lib )
          set( CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "/i2bm/research/${output}/${soft}" )
        endforeach()
        # Force to use VTK version installed in /i2bm/research by default
        file( GLOB VTK_DIR /i2bm/research/${output}/vtk/lib/vtk-* )
        if( VTK_DIR )
          set( VTK_DIR "${VTK_DIR}" CACHE PATH "The directory containing VTKConfig.cmake" )
        endif()
        file( GLOB QMAKE "/i2bm/research/${output}/bin/qmake-qt4" )
        if( QMAKE )
          set( QT_QMAKE_EXECUTABLE ${QMAKE} CACHE STRING "Qt4 qmake executable" )
        endif()
      endif()
    endif()
  endif()
endif()
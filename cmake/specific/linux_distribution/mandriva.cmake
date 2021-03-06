message( STATUS "Add specific paths for Mandriva distribution" )
if( DESIRED_QT_VERSION EQUAL 4 AND NOT DEFINED ENV{QTDIR} AND IS_DIRECTORY /usr/lib/qt4 )
  list( FIND CMAKE_PREFIX_PATH /usr/lib/qt4 _result )
  if( _result EQUAL -1 )
    set( CMAKE_PREFIX_PATH /usr/lib/qt4 ${CMAKE_PREFIX_PATH} )
  endif()
endif()
file( GLOB ITK_PREFIX "/usr/lib*/itk-*" )
if( ITK_PREFIX )
  set( ITK_DIR ${ITK_PREFIX} CACHE PATH "The directory containing ITKConfig.cmake." )
endif()
unset( ITK_PREFIX )

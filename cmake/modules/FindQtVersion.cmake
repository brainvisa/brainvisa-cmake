# Defines QT_VERSION that contains full version of Qt (e.g "4.3.1").
if( NOT DEFINED QT_VERSION )
  if( NOT DESIRED_QT_VERSION )
    find_package( Qt REQUIRED QUIET )
  endif()
  find_package( Qt${DESIRED_QT_VERSION} REQUIRED QUIET )
  if(QT_VERSION_MAJOR)
    set( QT_VERSION "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}")
  else()
    execute_process( COMMAND "${QT_QMAKE_EXECUTABLE}" "-v"
      OUTPUT_VARIABLE output ERROR_VARIABLE output
      RESULT_VARIABLE result )
    if( output AND result EQUAL 0 )
      string( REGEX REPLACE ".*Using Qt version ([^ ]*) in.*" "\\1" QT_VERSION "${output}" )
      set( QT_VERSION "${QT_VERSION}" CACHE STRING "Full version of Qt (e.g \"4.3.1\")." )
    else()
      message( "Cannot find Qt version: ${result} \"${output}\"" )
    endif()
  endif()
endif()

if( QT_VERSION )
  set( QtVersion_FOUND TRUE )
endif()

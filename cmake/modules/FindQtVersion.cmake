# Defines QT_VERSION that contains full version of Qt (e.g "4.3.1").
if( NOT DEFINED QT_VERSION )
  find_package( Qt REQUIRED QUIET )
  execute_process( COMMAND "${QT_QMAKE_EXECUTABLE_FINDQT}" "-v"
    OUTPUT_VARIABLE output ERROR_VARIABLE output
    RESULT_VARIABLE result )
  if( output AND result EQUAL 0 )
    string( REGEX REPLACE ".*Using Qt version ([^ ]*) in.*" "\\1" QT_VERSION "${output}" )
    set( QT_VERSION "${QT_VERSION}" CACHE STRING "Full version of Qt (e.g \"4.3.1\")." )
  endif()
endif()

if( QT_VERSION )
  set( QtVersion_FOUND TRUE )
endif()

# Defines QT_VERSION that contains full version of Qt (e.g "4.3.1").
if( NOT DEFINED QT_VERSION )
  if( NOT DESIRED_QT_VERSION )
    find_package( Qt REQUIRED QUIET )
  endif()
  if( DESIRED_QT_VERSION LESS 5 )
    find_package( Qt${DESIRED_QT_VERSION} REQUIRED QUIET )
  elseif( DESIRED_QT_VERSION EQUAL 5 )
    find_package( Qt5Core )
    if( Qt5Core_FOUND )
      set( QT_VERSION_MAJOR 5 )
#       set( QT_QMAKE_EXECUTABLE ${Qt5Core_QMAKE_EXECUTABLE} )
#       set( QT_MOC_EXECUTABLE ${Qt5Core_MOC_EXECUTABLE} )
      find_package( Qt5LinguistTools )
#       set( QT_LUPDATE_EXECUTABLE ${Qt5_LUPDATE_EXECUTABLE} )
#       set( QT_LRELEASE_EXECUTABLE ${Qt5_LRELEASE_EXECUTABLE} )
      set( QT_VERSION "${Qt5Core_VERSION}" CACHE STRING "Full version of Qt (e.g \"4.3.1\")." )
      get_target_property( QT_MOC_EXECUTABLE Qt5::moc IMPORTED_LOCATION )
      get_target_property( QT_LRELEASE_EXECUTABLE Qt5::lrelease
        IMPORTED_LOCATION )
      get_target_property( QT_LUPDATE_EXECUTABLE Qt5::lupdate
        IMPORTED_LOCATION )
      get_target_property( QT_QMAKE_EXECUTABLE Qt5::qmake IMPORTED_LOCATION )
      set( QT_LUPDATE_EXECUTABLE ${QT_LUPDATE_EXECUTABLE} CACHE FILEPATH
        "lupdate executable path" )
      set( QT_LRELEASE_EXECUTABLE ${QT_LRELEASE_EXECUTABLE} CACHE FILEPATH
        "lrelease executable path" )
      set( QT_MOC_EXECUTABLE ${QT_MOC_EXECUTABLE} CACHE FILEPATH
        "moc executable path" )
      set( QT_QMAKE_EXECUTABLE ${QT_QMAKE_EXECUTABLE} CACHE FILEPATH
        "qmake executable path" )
    endif()
  elseif( DESIRED_QT_VERSION EQUAL 6 )
    find_package( Qt6 QUIET COMPONENTS Core )
    if( Qt6_FOUND )
#       set( QT_VERSION_MAJOR 6 )
      find_program( QT_QMAKE_EXECUTABLE NAMES qmake6 qmake )
    endif()
  endif()

  if(QT_VERSION_MAJOR)
    set( QT_VERSION "${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}.${QT_VERSION_PATCH}")
  else()
    execute_process( COMMAND ${QT_QMAKE_EXECUTABLE} "-v"
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
  set( QT_FOUND TRUE )
endif()

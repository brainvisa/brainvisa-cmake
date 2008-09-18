# This file defines the following variables:
#
# PYQT_FOUND   - true if PyQt had been found
# PYQT_VERSION - The version of PyQt as a human readable string.
# PYQT_SIP_DIR - The directory holding the PyQt .sip files.

if( PYQT_VERSION )
  set( PYQT_FOUND true )
else( PYQT_VERSION )
  if( NOT PYTHON_EXECUTABLE )
    if( PyQt_FIND_REQUIRED )
      find_package( PythonInterp REQUIRED )
    else( PyQt_FIND_REQUIRED )
      find_package( PythonInterp )
    endif( PyQt_FIND_REQUIRED )
  endif( NOT PYTHON_EXECUTABLE )

  set( PYQT_FOUND false )
  if( PYTHON_EXECUTABLE )
    execute_process( COMMAND ${PYTHON_EXECUTABLE}
      -c "import pyqtconfig;cfg=pyqtconfig.Configuration();print cfg.pyqt_version_str+\";\"+cfg.pyqt_sip_dir+\";\""
      OUTPUT_VARIABLE _pyqtConfig
      ERROR_VARIABLE _error
      RESULT_VARIABLE _result )
      if( ${_result} EQUAL 0 )
        list( GET _pyqtConfig 0 PYQT_VERSION )
        list( GET _pyqtConfig 1 PYQT_SIP_DIR )
        set( PYQT_FOUND true )
      else( ${_result} EQUAL 0 )
        if( NOT PyQt_FIND_QUIETLY )
          message( SEND_ERROR "Python code to find PyQt configuration produced an error:\n${_error}" )
        endif( NOT PyQt_FIND_QUIETLY )
      endif( ${_result} EQUAL 0 )
  endif( PYTHON_EXECUTABLE )

  if( PYQT_FOUND )
    if( NOT PyQt_FIND_QUIETLY )
      message( STATUS "Found PyQt ${PYQT_VERSION}" )
    endif( NOT PyQt_FIND_QUIETLY )
  else( PYQT_FOUND )
    if( PyQt_FIND_REQUIRED )
      message( FATAL_ERROR "Could not find PyQt" )
    elseif( NOT PyQt_FIND_QUIETLY )
      message( STATUS "Could not find PyQt" )
    endif( PyQt_FIND_REQUIRED )
  endif( PYQT_FOUND )

  set( PYQT_VERSION "${PYQT_VERSION}" CACHE STRING "PyQt version" )
  mark_as_advanced(PYQT_VERSION)
  set( PYQT_SIP_DIR "${PYQT_SIP_DIR}" CACHE FILEPATH "PyQt sip path" )
  mark_as_advanced(PYQT_SIP_DIR)

endif( PYQT_VERSION )

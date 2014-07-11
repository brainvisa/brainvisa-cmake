# Find PyQt4
# ~~~~~~~~~~
# Copyright (c) 2007-2008, Simon Edwards <simon@simonzone.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# PyQt4 website: http://www.riverbankcomputing.co.uk/pyqt/index.php
#
# Find the installed version of PyQt4. FindPyQt4 should only be called after
# Python has been found.
#
# This file defines the following variables:
#
# PYQT4_VERSION - The version of PyQt4 found expressed as a 6 digit hex number
#     suitable for comparision as a string
#
# PYQT4_VERSION_STR - The version of PyQt4 as a human readable string.
#
# PYQT4_VERSION_TAG - The PyQt version tag using by PyQt's sip files.
#
# PYQT4_SIP_DIR - The directory holding the PyQt4 .sip files.
#
# PYQT4_SIP_FLAGS - The SIP flags used to build PyQt.

if( PYQT4_VERSION )

  # Already in cache, be silent
  set( PYQT4_FOUND TRUE )

else()

  find_file( _find_pyqt_py FindPyQt.py PATHS ${CMAKE_MODULE_PATH} )

  execute_process(COMMAND "${PYTHON_EXECUTABLE}" "${_find_pyqt_py}" OUTPUT_VARIABLE pyqt_config )
  if( pyqt_config )
    string( REGEX REPLACE "^pyqt_version:([^\n]+).*$" "\\1" PYQT4_VERSION ${pyqt_config} )
    set( PYQT4_VERSION "${PYQT4_VERSION}" CACHE STRING "The version of PyQt4 found expressed as a 6 digit hex number suitable for comparision as a string" )
    mark_as_advanced( PYQT4_VERSION )
    string( REGEX REPLACE ".*\npyqt_version_str:([^\n]+).*$" "\\1" PYQT4_VERSION_STR ${pyqt_config} )
    set( PYQT4_VERSION_STR "${PYQT4_VERSION_STR}" CACHE STRING "The version of PyQt4 as a human readable string" )
    mark_as_advanced( PYQT4_VERSION_STR )
    string( REGEX REPLACE ".*\npyqt_version_tag:([^\n]+).*$" "\\1" PYQT4_VERSION_TAG ${pyqt_config} )
    set( PYQT4_VERSION_TAG "${PYQT4_VERSION_TAG}" CACHE STRING "The PyQt version tag using by PyQt's sip files" )
    mark_as_advanced( PYQT4_VERSION_TAG )
    string( REGEX REPLACE ".*\npyqt_sip_dir:([^\n]+).*$" "\\1" PYQT4_SIP_DIR ${pyqt_config} )
    file( TO_CMAKE_PATH "${PYQT4_SIP_DIR}" PYQT4_SIP_DIR )
    set( PYQT4_SIP_DIR "${PYQT4_SIP_DIR}" CACHE STRING "The directory holding the PyQt4 .sip files" )
    mark_as_advanced( PYQT4_SIP_DIR )
    string( REGEX REPLACE ".*\npyqt_sip_flags:([^\n]+).*$" "\\1" PYQT4_SIP_FLAGS ${pyqt_config} )
    set( PYQT4_SIP_FLAGS "${PYQT4_SIP_FLAGS}" CACHE STRING "The SIP flags used to build PyQt" )
    mark_as_advanced( PYQT4_SIP_FLAGS )

	if (WIN32)
		# Windows 7 does not authorize pylupdate and pylupdate4
		# to be run using account that is not administrator.
		# So it was necessary to copy it to pylactualize.
		# No comment ...
		set( WIN_PYLUPDATE pylactualize )
	endif()
    find_program( PYQT4_PYLUPDATE_EXECUTABLE NAMES "${WIN_PYLUPDATE}" pylupdate4 pylupdate
      DOC "pylupdate program path" )
    find_program( PYUIC NAMES pyuic4 pyuic DOC "pyuic program path" )
	set(WIN_PYLUPDATE)
    set(PYQT4_FOUND TRUE)
  endif()

  IF(PYQT4_FOUND)
    IF(NOT PYQT4_FIND_QUIETLY)
      MESSAGE(STATUS "Found PyQt4 version: ${PYQT4_VERSION_STR}")
    ENDIF(NOT PYQT4_FIND_QUIETLY)
  ELSE(PYQT4_FOUND)
    IF(PYQT4_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find Python")
    ENDIF(PYQT4_FIND_REQUIRED)
  ENDIF(PYQT4_FOUND)

endif()

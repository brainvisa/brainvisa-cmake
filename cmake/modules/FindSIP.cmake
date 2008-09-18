# Find SIP
# ~~~~~~~~
# Copyright (c) 2007, Simon Edwards <simon@simonzone.com>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
# SIP website: http://www.riverbankcomputing.co.uk/sip/index.php
#
# Find the installed version of SIP. FindSIP should be called after Python
# has been found.
#
# This file defines the following variables:
#
# SIP_VERSION - The version of SIP found expressed as a 6 digit hex number
#     suitable for comparision as a string.
#
# SIP_VERSION_STR - The version of SIP found as a human readable string.
#
# SIP_EXECUTABLE - Path and filename of the SIP command line executable.
#
# SIP_INCLUDE_DIR - Directory holding the SIP C++ header file.
#
# SIP_DEFAULT_SIP_DIR - Default directory where .sip files should be installed
#     into.

IF(SIP_VERSION)

  # SIP is already found, do nothing
  SET(SIP_FOUND TRUE)

ELSE (SIP_VERSION)

  IF( NOT PYTHON_EXECUTABLE )

      MESSAGE(ERROR "Find Python before SIP.")

  ELSE( NOT PYTHON_EXECUTABLE )

  GET_FILENAME_COMPONENT(_cmake_module_path ${CMAKE_CURRENT_LIST_FILE}  PATH)

  EXECUTE_PROCESS(COMMAND ${PYTHON_EXECUTABLE} ${_cmake_module_path}/FindSIP.py OUTPUT_VARIABLE sip_config)
  IF(sip_config)
    STRING(REGEX REPLACE "^sip_version:([^\n]+).*$" "\\1" SIP_VERSION ${sip_config})
    STRING(REGEX REPLACE ".*\nsip_version_str:([^\n]+).*$" "\\1" SIP_VERSION_STR ${sip_config})
    STRING(REGEX REPLACE ".*\nsip_bin:([^\n]+).*$" "\\1" SIP_EXECUTABLE ${sip_config})
    STRING(REGEX REPLACE ".*\ndefault_sip_dir:([^\n]+).*$" "\\1" SIP_DEFAULT_SIP_DIR ${sip_config})
    STRING(REGEX REPLACE ".*\nsip_inc_dir:([^\n]+).*$" "\\1" SIP_INCLUDE_DIR ${sip_config})
    SET(SIP_FOUND TRUE)
  ENDIF(sip_config)

  IF(SIP_FOUND)
    IF(NOT SIP_FIND_QUIETLY)
      MESSAGE(STATUS "Found SIP version: ${SIP_VERSION_STR}")
    ENDIF(NOT SIP_FIND_QUIETLY)
  ELSE(SIP_FOUND)
    IF(SIP_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "Could not find SIP")
    ENDIF(SIP_FIND_REQUIRED)
  ENDIF(SIP_FOUND)

  SET(SIP_VERSION     ${SIP_VERSION}     CACHE STRING "Sip version")
  SET(SIP_EXECUTABLE  ${SIP_EXECUTABLE}  CACHE FILE "Sip executable")
  SET(SIP_INCLUDE_DIR ${SIP_INCLUDE_DIR} CACHE PATH "Path to sip include files")

  MARK_AS_ADVANCED(SIP_VERSION)
  MARK_AS_ADVANCED(SIP_EXECUTABLE)
  MARK_AS_ADVANCED(SIP_INCLUDE_DIR)

ENDIF( NOT PYTHON_EXECUTABLE )

ENDIF(SIP_VERSION)
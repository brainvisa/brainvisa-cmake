# This is duplicated from cmake FindPythonInterp.cmake, 
# because it is necessary for us to fix python search method.

# - Find python interpreter
# This module finds if Python interpreter is installed and determines where the
# executables are. This code sets the following variables:
#
#  PYTHONINTERP_FOUND - Was the Python executable found
#  PYTHON_EXECUTABLE  - path to the Python interpreter
#

#=============================================================================
# Copyright 2005-2009 Kitware, Inc.
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distributed this file outside of CMake, substitute the full
#  License text for the above reference.)
FIND_PROGRAM(PYTHON_EXECUTABLE
  NAMES python2.7 python2.6 python2 python
  python3 python3.6 python3.5 python3.4 python3.3 python3.2 python3.1 python3.0
  PATHS
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\3.6\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\3.5\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\3.4\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\3.3\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\3.2\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\3.1\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\3.0\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.7\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.6\\InstallPath]
  )

# handle the QUIETLY and REQUIRED arguments and set PYTHONINTERP_FOUND to TRUE if
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(PythonInterp DEFAULT_MSG PYTHON_EXECUTABLE)

MARK_AS_ADVANCED(PYTHON_EXECUTABLE)


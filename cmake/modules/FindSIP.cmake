# This file defines the following variables:
#
# SIP_EXECUTABLE - Path and filename of the SIP command line executable.
#
# SIP_INCLUDE_DIR - Directory holding the SIP C++ header file.
#
# SIP_INCLUDE_DIRS - All include directories necessary to compile sip generated files.
#
# SIP_VERSION - The version of SIP found expressed as a 6 digit hex number
#     suitable for comparision as a string.
#

# message( "SIP_VERSION: ${SIP_VERSION}" )
if( SIP_VERSION )
  # SIP is already found, do nothing
  set( SIP_INCLUDE_DIRS "${PYTHON_INCLUDE_PATH}" "${SIP_INCLUDE_DIR}" )
  set(SIP_FOUND TRUE)
else( SIP_VERSION )
  find_program( SIP_EXECUTABLE
    NAMES sip
    DOC "Path to sip executable" )
  
  if( SIP_EXECUTABLE )
    if( not PYTHONINTERP_FOUND )
      find_package( PythonInterp REQUIRED )
    endif( not PYTHONINTERP_FOUND )
    if( not PYTHONLIBS_FOUND )
      find_package( PythonLibs REQUIRED )
    endif( not PYTHONLIBS_FOUND )
    
    mark_as_advanced( SIP_EXECUTABLE )
    execute_process( COMMAND ${SIP_EXECUTABLE} -V OUTPUT_VARIABLE SIP_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE )
    set( SIP_VERSION "${SIP_VERSION}" CACHE STRING "Version of sip executable" )
    mark_as_advanced( SIP_VERSION )
    execute_process( COMMAND ${PYTHON_EXECUTABLE} -c "import sipconfig; print sipconfig.Configuration().sip_inc_dir"
      OUTPUT_VARIABLE SIP_INCLUDE_DIR OUTPUT_STRIP_TRAILING_WHITESPACE )
    set( SIP_INCLUDE_DIR "${SIP_INCLUDE_DIR}" CACHE PATH "Path to sip include files" )
    mark_as_advanced( SIP_INCLUDE_DIR )
    set( SIP_INCLUDE_DIRS "${PYTHON_INCLUDE_PATH}" "${SIP_INCLUDE_DIR}" )
    set( SIP_FOUND TRUE )
    if( NOT SIP_FIND_QUIETLY )
      message( STATUS "Found SIP version: ${SIP_VERSION}" )
    endif(NOT SIP_FIND_QUIETLY)
  else( SIP_EXECUTABLE )
    set( SIP_FOUND FALSE )
    if( SIP_FIND_REQUIRED )
      message( FATAL_ERROR "SIP not found" )
    endif(SIP_FIND_REQUIRED)
  endif( SIP_EXECUTABLE )
endif( SIP_VERSION )


# - Find numpy
# Find the native numpy includes
# This module defines
#  NUMPY_INCLUDE_DIR, where to find numpy/arrayobject.h, etc.
#  NUMPY_FOUND, If false, do not try to use numpy headers.
#  NUMPY_VERSION

if (NUMPY_INCLUDE_DIR)
  # in cache already
  set (NUMPY_FIND_QUIETLY TRUE)
endif (NUMPY_INCLUDE_DIR)

find_package(python REQUIRED)
EXEC_PROGRAM ("${PYTHON_EXECUTABLE}"
  ARGS "-c" "\"from __future__ import print_function; import numpy; print('>>BEGIN NPY CONFIG<<'); print(numpy.get_include()); print('>>END NPY CONFIG<<')\""
  OUTPUT_VARIABLE NUMPY_INCLUDE_DIR_WRAPPED
  ERROR_QUIET
  RETURN_VALUE NUMPY_NOT_FOUND)

if (NUMPY_NOT_FOUND EQUAL 0)

  string( REGEX MATCH ">>BEGIN NPY CONFIG<<.(.*).>>END NPY CONFIG<<"
    _dummy "${NUMPY_INCLUDE_DIR_WRAPPED}"
  )
  set( NUMPY_INCLUDE_DIR "${CMAKE_MATCH_1}")

  set (NUMPY_FOUND TRUE)
  set (NUMPY_INCLUDE_DIR ${NUMPY_INCLUDE_DIR} CACHE STRING "Numpy include path")
  EXEC_PROGRAM ("${PYTHON_EXECUTABLE}"
    ARGS "-c" "\"from __future__ import print_function; import numpy; print('>>BEGIN NPY CONFIG<<'); print(numpy.version.version); print('>>END NPY CONFIG<<')\""
    OUTPUT_VARIABLE NUMPY_VERSION_WRAPPED)
  string( REGEX MATCH ">>BEGIN NPY CONFIG<<.(.*).>>END NPY CONFIG<<"
    _dummy "${NUMPY_VERSION_WRAPPED}"
  )
  set( NUMPY_VERSION "${CMAKE_MATCH_1}")

else ()
  if( NUMPY_INCLUDE_DIR )
    message( "Numpy detection failed - output message: ${NUMPY_INCLUDE_DIR}" )
  endif()
  set(NUMPY_INCLUDE_DIR)
  set(NUMPY_FOUND FALSE)
endif ()

if (NUMPY_FOUND)
  if (NOT NUMPY_FIND_QUIETLY)
    message (STATUS "Numpy headers found")
  endif (NOT NUMPY_FIND_QUIETLY)
else (NUMPY_FOUND)
  if (NUMPY_FIND_REQUIRED)
    message (FATAL_ERROR "Numpy headers missing")
  endif (NUMPY_FIND_REQUIRED)
endif (NUMPY_FOUND)

MARK_AS_ADVANCED (NUMPY_INCLUDE_DIR)


## find the numpy headers directory. Use python's distutils to do so.
## NUMPYFOUND : numpy has been found
## NUMPY_INCLUDE_DIR
##

#IF(PYTHONINTERP_FOUND)

#MESSAGE("Calling python to query for Numpy location")
#set(_cmd "${PYTHON_EXECUTABLE} -c \"import numpy.distutils.misc_util; print ';'.join(numpy.distutils.misc_util.get_numpy_include_dirs())\"")
#EXEC_PROGRAM("${_cmd}" OUTPUT_VARIABLE NUMPY_INCLUDE_DIR)

#MESSAGE("${NUMPY_INCLUDE_DIR}")
#MARK_AS_ADVANCED(FORCE NUMPY_INCLUDE_DIR)

#SET(NUMPYFOUND ON)

#ELSE(PYTHONINTERP_FOUND)
#  MESSAGE(ERROR "Please set Python variables prior to looking for Numpy.")
#ENDIF(PYTHONINTERP_FOUND)

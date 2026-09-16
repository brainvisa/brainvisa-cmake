
# - Find numpy
# Find the native numpy includes
# This module defines
#  NUMPY_INCLUDE_DIR, where to find numpy/arrayobject.h, etc.
#  NUMPY_FOUND, If false, do not try to use numpy headers.
#  NUMPY_VERSION
if (NUMPY_INCLUDE_DIR AND NUMPY_VERSION)
    set (NUMPY_FOUND TRUE)
else()
    if (NUMPY_INCLUDE_DIR)
    # in cache already
    set (NUMPY_FIND_QUIETLY TRUE)
    endif (NUMPY_INCLUDE_DIR)

    if (NOT CMAKE_CROSSCOMPILING OR CMAKE_CROSSCOMPILING_RUNNABLE)
        find_package(python REQUIRED)
        execute_process( COMMAND "${PYTHON_EXECUTABLE}" "-c" "import numpy; print(numpy.get_include())"
            OUTPUT_VARIABLE NUMPY_INCLUDE_DIR
            OUTPUT_STRIP_TRAILING_WHITESPACE
            RESULT_VARIABLE NUMPY_NOT_FOUND)

        if (NUMPY_NOT_FOUND EQUAL 0)
            # message("==== NUMPY_INCLUDE_DIR: ${NUMPY_INCLUDE_DIR}")
            set (NUMPY_FOUND TRUE)
            set (NUMPY_INCLUDE_DIR "${NUMPY_INCLUDE_DIR}" CACHE STRING "Numpy include path")
            
            execute_process(COMMAND "${PYTHON_EXECUTABLE}" "-c" "import numpy; print(numpy.version.version)"
                OUTPUT_VARIABLE NUMPY_VERSION
                OUTPUT_STRIP_TRAILING_WHITESPACE)
            set( NUMPY_VERSION "${NUMPY_VERSION}" CACHE STRING "Numpy version")
            # message("==== NUMPY_VERSION: ${NUMPY_VERSION}")
        else ()
            if( NUMPY_INCLUDE_DIR )
                message( "Numpy detection failed - output message: ${NUMPY_INCLUDE_DIR}" )
            endif()
            set(NUMPY_INCLUDE_DIR)
            set(NUMPY_VERSION)
            set(NUMPY_FOUND FALSE)
        endif ()
    endif()

    if (NUMPY_FOUND)
        if (NOT NUMPY_FIND_QUIETLY)
            message (STATUS "Found Numpy (found version: \"${NUMPY_VERSION}\")")
        endif (NOT NUMPY_FIND_QUIETLY)
    else (NUMPY_FOUND)
        if (NUMPY_FIND_REQUIRED)
            message (FATAL_ERROR "Numpy headers missing")
        endif (NUMPY_FIND_REQUIRED)
    endif (NUMPY_FOUND)

    MARK_AS_ADVANCED (NUMPY_INCLUDE_DIR)
endif()
#message("===== FindNumpy =====")
#message("NUMPY_INCLUDE_DIR: ${NUMPY_INCLUDE_DIR}")


## find the numpy headers directory. Use python's distutils to do so.
## NUMPYFOUND : numpy has been found
## NUMPY_INCLUDE_DIR
##

#IF(PYTHONINTERP_FOUND)

#MESSAGE("Calling python to query for Numpy location")
#set(_cmd "${PYTHON_HOST_EXECUTABLE} -c \"from __future__ import print_function; import numpy.distutils.misc_util; print(';'.join(numpy.distutils.misc_util.get_numpy_include_dirs()))\"")
#EXEC_PROGRAM("${_cmd}" OUTPUT_VARIABLE NUMPY_INCLUDE_DIR)

#MESSAGE("${NUMPY_INCLUDE_DIR}")
#MARK_AS_ADVANCED(FORCE NUMPY_INCLUDE_DIR)

#SET(NUMPYFOUND ON)

#ELSE(PYTHONINTERP_FOUND)
#  MESSAGE(ERROR "Please set Python variables prior to looking for Numpy.")
#ENDIF(PYTHONINTERP_FOUND)

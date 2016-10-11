#message("===== MINGW cache initialization =====")
if( NOT BRAINVISA_CROSSCOMPILATION_DIR )
  message( FATAL_ERROR "BRAINVISA_CROSSCOMPILATION_DIR is not set" )
endif( NOT BRAINVISA_CROSSCOMPILATION_DIR )

if (NOT COMPILER_PREFIX)
    set(COMPILER_PREFIX "i686-w64-mingw32")
endif()

set( CMAKE_FIND_ROOT_PATH
     ${BRAINVISA_CROSSCOMPILATION_DIR} 
     ${CMAKE_FIND_ROOT_PATH} )
set( PYTHON_EXECUTABLE "/usr/bin/python2.7" 
     CACHE FILEPATH "Python executable" )
set( CROSSCOMPILING_PYTHON_EXECUTABLE
     "${BRAINVISA_CROSSCOMPILATION_DIR}/bin/python.exe"
     CACHE FILEPATH "Runnable target python executable" )
set( CROSSCOMPILING_PYTHON_HOME
     "${BRAINVISA_CROSSCOMPILATION_DIR}/python"
     CACHE FILEPATH "Runnable target python home directory" )
set( PYTHON_LIBRARY "${BRAINVISA_CROSSCOMPILATION_DIR}/python/DLLs/python27.dll"
     CACHE FILEPATH "Python library" )
set( PYTHON_INCLUDE_PATH "${BRAINVISA_CROSSCOMPILATION_DIR}/python/include"
     CACHE PATH "Python include" )
set( SIP_EXECUTABLE "${BRAINVISA_CROSSCOMPILATION_DIR}/bin/sip.exe"
     CACHE FILEPATH "SIP executable" )
set( SIP_INCLUDE_DIR "${BRAINVISA_CROSSCOMPILATION_DIR}/include"
     CACHE PATH "SIP include" )
execute_process( COMMAND ${SIP_EXECUTABLE} 
                 -V OUTPUT_VARIABLE SIP_VERSION 
                 OUTPUT_STRIP_TRAILING_WHITESPACE )
set( SIP_VERSION "${SIP_VERSION}"
     CACHE STRING "Version of sip executable" )
set( NUMPY_INCLUDE_DIR "${BRAINVISA_CROSSCOMPILATION_DIR}/python/Lib/site-packages/numpy/core/include"
     CACHE PATH "Numpy include" )
    
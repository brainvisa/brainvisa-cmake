#message("===== i686-w64-mingw32 cache initialization =====")
if(NOT BRAINVISA_CROSSCOMPILATION_DIR)
  message(FATAL_ERROR "BRAINVISA_CROSSCOMPILATION_DIR is not set")
endif(NOT BRAINVISA_CROSSCOMPILATION_DIR)

if (NOT COMPILER_PREFIX)
    set(COMPILER_PREFIX "i686-w64-mingw32")
endif()

# Add brainvisa root directory
set(CMAKE_FIND_ROOT_PATH
    ${BRAINVISA_CROSSCOMPILATION_DIR} 
    ${CMAKE_FIND_ROOT_PATH})

# Python settings
# set(PYTHON_HOST_EXECUTABLE "/usr/bin/python2.7" 
#     CACHE FILEPATH "Python executable")
set(CROSSCOMPILING_PYTHON_EXECUTABLE
    "${BRAINVISA_CROSSCOMPILATION_DIR}/bin/python.exe"
    CACHE FILEPATH "Runnable target python executable")
set(CROSSCOMPILING_PYTHON_HOME
    "${BRAINVISA_CROSSCOMPILATION_DIR}/python"
    CACHE FILEPATH "Runnable target python home directory")
# set(PYTHON_LIBRARY "${BRAINVISA_CROSSCOMPILATION_DIR}/python/DLLs/python27.dll"
#     CACHE FILEPATH "Python library")
# set(PYTHON_INCLUDE_PATH "${BRAINVISA_CROSSCOMPILATION_DIR}/python/include"
#     CACHE PATH "Python include")
    
# Sphinx settings
set(CROSSCOMPILING_SPHINXBUILD_EXECUTABLE 
    "${BRAINVISA_CROSSCOMPILATION_DIR}/bin/sphinx-build.exe"
    CACHE FILEPATH "Sphinx executable")

# QT settings
execute_process(COMMAND qmake -query QT_INSTALL_BINS
                OUTPUT_VARIABLE __qt_binary_dir
                OUTPUT_STRIP_TRAILING_WHITESPACE)
set(QT_BINARY_DIR "${__qt_binary_dir}"
    CACHE FILEPATH "QT binary directory")
    
set(QT_QMAKE_EXECUTABLE "${BRAINVISA_CROSSCOMPILATION_DIR}/qt/bin/qmake"
    CACHE FILEPATH "QT qmake executable")
    
# SIP settings
set(SIP_EXECUTABLE "${BRAINVISA_CROSSCOMPILATION_DIR}/bin/sip.exe"
    CACHE FILEPATH "SIP executable")
set(SIP_INCLUDE_DIR "${BRAINVISA_CROSSCOMPILATION_DIR}/include"
    CACHE PATH "SIP include")
execute_process(COMMAND ${SIP_EXECUTABLE} 
                -V OUTPUT_VARIABLE SIP_VERSION 
                OUTPUT_STRIP_TRAILING_WHITESPACE)
set(SIP_VERSION "${SIP_VERSION}"
    CACHE STRING "Version of sip executable")
    
# # Numpy settings
# set(NUMPY_INCLUDE_DIR 
#     "${BRAINVISA_CROSSCOMPILATION_DIR}/python/Lib/site-packages/numpy/core/include"
#     CACHE PATH "Numpy include")
     
# Set specific options for debug symbols when wine is used
# at the runtime
set(CMAKE_C_FLAGS_DEBUG "-gstabs" 
    CACHE STRING "Flags used by the compiler during debug builds.")
set(CMAKE_CXX_FLAGS_DEBUG "-gstabs"
    CACHE STRING "Flags used by the compiler during debug builds.")
set(CMAKE_Fortran_FLAGS_DEBUG "-gstabs" 
    CACHE STRING "Flags used by the compiler during debug builds.")
    
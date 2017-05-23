#message("===== i686-w64-mingw32 toolchain setup =====")
# the name of the target operating system
set(CMAKE_SYSTEM_NAME Windows)

if (NOT COMPILER_PREFIX)
    set(COMPILER_PREFIX "i686-w64-mingw32")
endif()

#message("===== MINGW toolchain ${COMPILER_PREFIX} =====")
# which compilers to use for C and C++
find_program(CMAKE_RC_COMPILER NAMES ${COMPILER_PREFIX}-windres)
find_program(CMAKE_C_COMPILER NAMES ${COMPILER_PREFIX}-gcc)
find_program(CMAKE_CXX_COMPILER NAMES ${COMPILER_PREFIX}-g++)
find_program(CMAKE_Fortran_COMPILER NAMES ${COMPILER_PREFIX}-gfortran)
find_program(CMAKE_LIBTOOL NAMES ${COMPILER_PREFIX}-dlltool)

# Try to find wine
find_program(WINE_RUNTIME NAMES wine)
find_program(WINE_PATH NAMES winepath)
if(WINE_RUNTIME AND WINE_PATH)
    message(STATUS "Wine runtime found ${WINE_RUNTIME}")
    option(CMAKE_CROSSCOMPILING_RUNNABLE "Specify wether it possible or not to run cross compiled binaries on host environment" ON)
endif()

if(WINE_PATH AND NOT COMMAND TARGET_TO_HOST_PATH)
    message(STATUS "Defining TARGET_TO_HOST_PATH function (Windows => Linux)")
    function(TARGET_TO_HOST_PATH __path __output_var)
        #message("==== TARGET_TO_HOST_PATH (Windows => Linux), path: ${__path}")
        set(__tmp_path)
        foreach(__p ${__path})
            execute_process(COMMAND "${WINE_PATH}" "-u" "-0" "${__p}"
                            OUTPUT_VARIABLE __p)
            # This is the simplest way to resolve issues dued to ':' characters
            # in wine drives
            get_filename_component(__p "${__p}" REALPATH)
            list(APPEND __tmp_path "${__p}")
        endforeach()
        #message("==== TARGET_TO_HOST_PATH (Windows => Linux), translated path: ${__tmp_path}")
        set("${__output_var}" ${__tmp_path} PARENT_SCOPE)
    endfunction()
endif()

if(WINE_PATH AND NOT COMMAND HOST_TO_TARGET_PATH)
    message(STATUS "Defining HOST_TO_TARGET_PATH function (Linux => Windows)")
    function(HOST_TO_TARGET_PATH __path __output_var)
        #message("===== HOST_TO_TARGET_PATH (Linux => Windows), path: ${__path}")
        set(__tmp_path)
        foreach(__p ${__path})
            execute_process(COMMAND "${WINE_PATH}" "-w" "-0" "${__p}"
                            OUTPUT_VARIABLE __p)
            list(APPEND __tmp_path "${__p}")
        endforeach()
        #message("===== HOST_TO_TARGET_PATH (Linux => Windows), translated path: ${__tmp_path}")
        set("${__output_var}" ${__tmp_path} PARENT_SCOPE)    
    endfunction()
endif()

# here is the target environment located
set(CMAKE_FIND_ROOT_PATH /usr/${COMPILER_PREFIX})
set(CMAKE_LIBRARY_PATH /usr/${COMPILER_PREFIX}/lib /usr/lib/gcc/${COMPILER_PREFIX}/4.8 ${CMAKE_FIND_ROOT_PATH})

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search 
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

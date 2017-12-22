# A CMake find module for libiconv.
#
# Once done, this module will define
# LIBICONV_FOUND - system has libiconv
# LIBICONV_INCLUDE_DIRS - the libiconv include directory
# LIBICONV_LIBRARIES - link to these to use libiconv
# LIBICONV_VERSION - version of libiconv used

if(NOT LIBICONV_FOUND)
    # Find specific windows iconv package
    FIND_PATH(LIBICONV_INCLUDE_DIR NAMES iconv.h)
    FIND_LIBRARY(LIBICONV_LIBRARIES NAMES iconv)

    # Try to find libiconv version
    if( EXISTS "${LIBICONV_INCLUDE_DIR}/iconv.h" )
        file( READ "${LIBICONV_INCLUDE_DIR}/iconv.h" header )
        string( REGEX MATCH "#define[ \\t]+_LIBICONV_VERSION[ \\t]+(0x[0-9a-fA-F]+)" match "${header}" )

        if( match )
            # Convert hexadecimal values
            include(UseVersionConvert)
            version_convert(__version ${CMAKE_MATCH_1} STR)
            set(LIBICONV_VERSION "${__version}" 
                CACHE STRING "Iconv library version")
            unset(__version)
        endif()
    endif()
    
    # handle the QUIETLY and REQUIRED arguments and set LIBICONV_FOUND to TRUE if 
    # all listed variables are TRUE
    INCLUDE(FindPackageHandleStandardArgs)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(LibIconv DEFAULT_MSG LIBICONV_LIBRARIES LIBICONV_INCLUDE_DIR)
endif()

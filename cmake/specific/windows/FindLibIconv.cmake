# A CMake find module for gdk-pixbuf.
#
# Once done, this module will define
# LIBICONV_FOUND - system has gdk-pixbuf
# LIBICONV_INCLUDE_DIRS - the gdk-pixbuf include directory
# LIBICONV_LIBRARIES - link to these to use gdk-pixbuf
# LIBICONV_VERSION - version of gdk-pixbuf used

if(NOT LIBICONV_FOUND)
    # Find specific windows iconv package
    FIND_PATH(LIBICONV_INCLUDE_DIR NAMES iconv.h)
    FIND_LIBRARY(LIBICONV_LIBRARIES NAMES iconv)

    # handle the QUIETLY and REQUIRED arguments and set LIBICONV_FOUND to TRUE if 
    # all listed variables are TRUE
    INCLUDE(FindPackageHandleStandardArgs)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(LibIconv DEFAULT_MSG LIBICONV_LIBRARIES LIBICONV_INCLUDE_DIR)
endif()

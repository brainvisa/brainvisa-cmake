# Find specific windows regex package
FIND_PATH(LIBREGEX_INCLUDE_DIR NAMES regex.h)
FIND_LIBRARY(LIBREGEX_LIBRARIES NAMES regex)

# handle the QUIETLY and REQUIRED arguments and set LIBREGEX_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LibRegex DEFAULT_MSG LIBREGEX_LIBRARIES LIBREGEX_INCLUDE_DIR)

MARK_AS_ADVANCED(LIBREGEX_INCLUDE_DIR LIBREGEX_LIBRARIES)

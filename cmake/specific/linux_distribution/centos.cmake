message( STATUS "Add specific paths for CentOS distribution" )

# something has changed somewhere, the ELF format is not recognized by default
# any longer and makes install fail because of a rpath/relink step missing.
# The solution is to force ELF format
# see https://cmake.org/Bug/view.php?id=13934#c37157
set(CMAKE_EXECUTABLE_FORMAT "ELF")

file( READ /etc/redhat-release _x )
string( REGEX MATCH "release ([0-9.]+)" _x "${_x}" )
if( CMAKE_MATCH_1 VERSION_EQUAL "7"
    OR CMAKE_MATCH_1 VERSION_GREATER "7" )
    string( FIND "${CMAKE_CXX_FLAGS}" "-std=c++11" _result )
    if( _result EQUAL -1 )
        set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11" CACHE STRING 
            "Flags used by the compiler during all build types." FORCE )
    endif()
endif()

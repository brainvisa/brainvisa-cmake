message( STATUS "Add specific paths for Ubuntu distribution" )

# something has changed somewhere, the ELF format is not recognized by default
# any longer and makes install fail because of a rpath/relink step missing.
# The solution is to force ELF format
# see https://cmake.org/Bug/view.php?id=13934#c37157
set(CMAKE_EXECUTABLE_FORMAT "ELF")

file( READ /etc/lsb-release _x )
string( REGEX MATCH "DISTRIB_RELEASE=([0-9.]+)" _x "${_x}" )
if( CMAKE_MATCH_1 VERSION_EQUAL "16.04"
    OR CMAKE_MATCH_1 VERSION_GREATER "16.04" )
    string( FIND "${CMAKE_CXX_FLAGS}" "-std=c++11" _result )
    if( _result EQUAL -1 )
        set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11" CACHE STRING 
            "Flags used by the compiler during all build types." FORCE )
    endif()
endif()
if( CMAKE_MATCH_1 STREQUAL "16.04" )
    if( EXISTS /usr/bin/g++-4.9 )
        message( "Ubuntu 16.04, forcing g++ 4.9" )
        set( CMAKE_CXX_COMPILER /usr/bin/g++-4.9 CACHE FILEPATH 
             "CXX compiler" )
    else()
        message( "Warning, g++-4.9 not found, expect runtime problems with g++-5.3 on Ubuntu 16.04" )
    endif()
endif()

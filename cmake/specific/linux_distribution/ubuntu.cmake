message( STATUS "Add specific paths for Ubuntu distribution" )

file( READ /etc/lsb-release _x )
string( REGEX MATCH "DISTRIB_RELEASE=([0-9.]+)" _x "${_x}" )
if( CMAKE_MATCH_1 STREQUAL "16.04" )
    string( FIND "${CMAKE_CXX_FLAGS}" "-std=c++11" _result )
    if( _result EQUAL -1 )
        set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11" CACHE STRING 
            "Flags used by the compiler during all build types." FORCE )
    endif()
    if( EXISTS /usr/bin/g++-4.9 )
        message( "Ubuntu 16.04, forcing g++ 4.9" )
        set( CMAKE_CXX_COMPILER /usr/bin/g++-4.9 CACHE FILEPATH 
             "CXX compiler" )
    else()
        message( "Warning, g++-4.9 not found, expect runtime problems with g++-5.3 on Ubuntu 16.04" )
    endif()
endif()

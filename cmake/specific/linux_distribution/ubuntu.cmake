message( STATUS "Add specific paths for Ubuntu distribution" )

# something has changed somewhere, the ELF format is not recognized by default
# any longer and makes install fail because of a rpath/relink step missing.
# The solution is to force ELF format
# see https://cmake.org/Bug/view.php?id=13934#c37157
set(CMAKE_EXECUTABLE_FORMAT "ELF")

file( READ /etc/lsb-release _x )
string( REGEX MATCH "DISTRIB_RELEASE=([0-9.]+)" _x "${_x}" )
if( CMAKE_MATCH_1 VERSION_EQUAL "22.04"
    OR CMAKE_MATCH_1 VERSION_GREATER "22.04" )
    string( FIND "${CMAKE_CXX_FLAGS}" "-std" _result )
    if( _result EQUAL -1 )
        set( CMAKE_CXX_FLAGS "-std=c++17 ${CMAKE_CXX_FLAGS}" CACHE STRING
            "Flags used by the compiler during all build types (flags forced by brainvisa-cmake)." FORCE )
    endif()
else()
    if( CMAKE_MATCH_1 VERSION_EQUAL "16.04"
        OR CMAKE_MATCH_1 VERSION_GREATER "16.04" )
        string( FIND "${CMAKE_CXX_FLAGS}" "-std" _result )
        if( _result EQUAL -1 )
            set( CMAKE_CXX_FLAGS "-std=gnu++11 ${CMAKE_CXX_FLAGS}" CACHE STRING
                "Flags used by the compiler during all build types (flags forced by brainvisa-cmake)." FORCE )
        endif()
    endif()
    if( CMAKE_MATCH_1 STREQUAL "16.04" )
        find_program(GCC_4_9 g++-4.9)
        if( BRAINVISA_IGNORE_BUG_GCC_5 )
            if( EXISTS ${GCC_4_9} )
                message("Ubuntu 16.04, trying not too hard to use g++-4.9 (${GCC_4_9})")
                set( CMAKE_CXX_COMPILER ${GCC_4_9} CACHE FILEPATH
                    "CXX compiler (gcc-4.9 set by brainvisa-cmake)" )
            endif()
        else()
            if( EXISTS ${GCC_4_9} )
                message( "Ubuntu 16.04, forcing use of g++ 4.9 (${GCC_4_9}). If you need to use another compiler, please set CMake variable BRAINVISA_IGNORE_BUG_GCC_5=YES" )
                set( CMAKE_CXX_COMPILER ${GCC_4_9} CACHE FILEPATH
                    "CXX compiler (g++-4.9 forced by brainvisa-cmake)" FORCE )
            else()
                message(FATAL_ERROR "g++-4.9 not found, expect runtime problems with g++-5.3 on Ubuntu 16.04. Please install g++-4.9 package or set CMake variable BRAINVISA_IGNORE_BUG_GCC_5=YES" )
            endif()
        endif()
    endif()
endif()

if( CMAKE_MATCH_1 VERSION_GREATER "18.0" )
    # on Ubuntu >= 18, Qt4 does not contain QtWebKit, so it's time to switch
    # to Qt5
    set( DESIRED_QT_VERSION 5 CACHE STRING
        "Pick a version of QT to use: 3, 4, 5...")
endif()

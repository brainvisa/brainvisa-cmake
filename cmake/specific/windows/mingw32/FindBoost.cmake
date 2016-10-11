# Remove specific pathes to find boost windows module
# This allow to find system package for boost
set(CMAKE_MODULE_PATH_PREV ${CMAKE_MODULE_PATH} )
set(CMAKE_MODULE_PATH "")
foreach( _item ${CMAKE_MODULE_PATH_PREV} )
  string(REGEX MATCH ".*/cmake/specific/windows$" _result "${_item}")
  if( NOT _result )
    if ( NOT CMAKE_MODULE_PATH )
      set( CMAKE_MODULE_PATH "${_item}" )
    else()
      set( CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH} ${_item}" )
    endif()
  endif()
endforeach()

# Search boost directory using path
set(Boost_ADDITIONAL_VERSIONS 1.51.0 1.51)

# Find system boost package
find_package( Boost NO_POLICY_SCOPE )

# Reset module path to previous one
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH_PREV}")

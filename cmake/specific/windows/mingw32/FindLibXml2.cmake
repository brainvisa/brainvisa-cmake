# Find specific iconv package
find_package( LibIconv NO_POLICY_SCOPE )


# Remove specific pathes to find LibXml2 windows module
# This allow to find system package for LibXml2
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

# Find system LibXml2 package
find_package( LibXml2 NO_POLICY_SCOPE )
  
# Reset module path to previous one
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH_PREV}")

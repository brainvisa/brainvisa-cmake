# Remove specific pathes to find dcmtk windows module
# This allow to find system package for dcmtk
set(CMAKE_MODULE_PATH_PREV ${CMAKE_MODULE_PATH} )
set(CMAKE_MODULE_PATH)
foreach( _item ${CMAKE_MODULE_PATH_PREV} )
  string(REGEX MATCH ".*/cmake/specific/windows$" _result "${_item}")
  if( NOT _result )
    if ( NOT CMAKE_MODULE_PATH )
      set( CMAKE_MODULE_PATH "${_item}" )
    else()
      set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${_item}" )
    endif()
  endif()
endforeach()

# Ugly hack to force finding openssl libraries
if(MINGW)
  set(CYGWIN 1)
endif()

# Find system dcmtk package
file( GLOB DCMTK_DIR "C:/msys/1.0/local/dcmtk-*" )
set( DCMTK_DIR "${DCMTK_DIR}" CACHE PATH "Root of DCMTK source tree (optional)." )
find_package( DCMTK NO_POLICY_SCOPE )

if(MINGW)
  set(CYGWIN "")
endif()
  
# Reset module path to previous one
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH_PREV})

if( WIN32 )
  message( STATUS "Add specific paths for windows" )
  
  # Add path to find specific modules for windows
  set( CMAKE_MODULE_PATH "${brainvisa-cmake_DIR}/specific/windows" ${CMAKE_MODULE_PATH} )
  
  # Add additional standard libraries
  set( _additional_libraries "-lregex" "-lm" "-lz")
  foreach( _item ${_additional_libraries} )
    string( REGEX MATCH "(^|[ \t]+)${_item}([ \t]+|$)" _result "${CMAKE_CXX_STANDARD_LIBRARIES}" )
    if( NOT _result )
        set( CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} ${_item}" CACHE STRING "Libraries linked by defalut with all C++ applications." FORCE )
    endif()
    
    string( REGEX MATCH "(^|[ \t]+)${_item}([ \t]+|$)" _result "${CMAKE_C_STANDARD_LIBRARIES}" )
    if( NOT _result )
        set( CMAKE_C_STANDARD_LIBRARIES "${CMAKE_C_STANDARD_LIBRARIES} ${_item}" CACHE STRING "Libraries linked by defalut with all C applications." FORCE )
    endif()
  endforeach()
  
  # Add msys/mingw default pathes to find binaries, libraries and includes
  set( MSYS_DEFAULT_ROOT "c:/msys/1.0" )
  if( EXISTS "${MSYS_DEFAULT_ROOT}" )
    set( MINGW_DEFAULT_ROOT "${MSYS_DEFAULT_ROOT}/MinGW" )
  else()
    set( MINGW_DEFAULT_ROOT "c:/MinGW" )
  endif()
  
  if( EXISTS "${MINGW_DEFAULT_ROOT}" )
    set(CMAKE_PREFIX_PATH "${MINGW_DEFAULT_ROOT}" ${CMAKE_PREFIX_PATH} )
  endif()
    
  if( EXISTS "${MSYS_DEFAULT_ROOT}" )
    file( GLOB _directories "${MSYS_DEFAULT_ROOT}/local/*" )
    if( _directories )
      foreach( _item ${_directories})
        string( REGEX MATCH ".*/(svn|cmake)[^/]*$" _result "${_item}" )
        if( NOT _result )
          if( NOT _additionalPrefixPath )
            set( _additionalPrefixPath "${_item}" )
          else()
            set( _additionalPrefixPath ${_additionalPrefixPath} "${_item}" )
          endif()
        endif()
      endforeach()
      if( _additionalPrefixPath )
        set( CMAKE_PREFIX_PATH ${_additionalPrefixPath} "${CMAKE_PREFIX_PATH}" )
      endif()
    endif()
  endif()
  
endif()

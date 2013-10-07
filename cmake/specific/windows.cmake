if( WIN32 )
  message( STATUS "Add specific paths for windows" )
  
  # Add path to find specific modules for windows
  set( CMAKE_MODULE_PATH "${brainvisa-cmake_DIR}/specific/windows" ${CMAKE_MODULE_PATH} )
  
  # Add msys/mingw default pathes to find binaries, libraries and includes
  set( MSYS_ROOT "c:/msys/1.0" CACHE STRING "Msys install root" )
  if( EXISTS "${MSYS_ROOT}" )
    set( MINGW_ROOT "${MSYS_ROOT}/MinGW" CACHE STRING "MinGW install root" )
  else()
    set( MINGW_ROOT "c:/MinGW" CACHE STRING "MinGW install root" )
  endif()
  
  if( EXISTS "${MINGW_ROOT}" )
    set(CMAKE_PREFIX_PATH "${MINGW_ROOT}" ${CMAKE_PREFIX_PATH} )
  endif()
    
  if( EXISTS "${MSYS_ROOT}" )
    file( GLOB _directories "${MSYS_ROOT}/local/*" )
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
  
  # Set default prefixes to find libraries in right order
  set(CMAKE_FIND_LIBRARY_PREFIXES "" ${CMAKE_FIND_LIBRARY_PREFIXES} "bin")
  
  # Add additional standard libraries
  find_package("LibRegex" REQUIRED)

  set( _additional_libraries "${LIBREGEX_LIBRARIES}" "-lm" "-lz" "-lws2_32" )
  foreach( _item ${_additional_libraries} )
    string( REGEX MATCH "(^|[ \t]+)${_item}([ \t]+|$)" _result "${CMAKE_CXX_STANDARD_LIBRARIES}" )
    if( NOT _result )
        set( CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} ${_item}" CACHE STRING "Libraries linked by default with all C++ applications." FORCE )
    endif()
    
    string( REGEX MATCH "(^|[ \t]+)${_item}([ \t]+|$)" _result "${CMAKE_C_STANDARD_LIBRARIES}" )
    if( NOT _result )
        set( CMAKE_C_STANDARD_LIBRARIES "${CMAKE_C_STANDARD_LIBRARIES} ${_item}" CACHE STRING "Libraries linked by default with all C applications." FORCE )
    endif()
  endforeach()
  
  set( _result )
  set( _additional_headers "-I${LIBREGEX_INCLUDE_DIR}")
  foreach( _item ${_additional_headers} )
    string( REGEX MATCH "(^|[ \t]+)${_item}([ \t]+|$)" _result "${CMAKE_CXX_FLAGS}" )
    if( NOT _result )
        set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${_item}" CACHE STRING "Flags used by all C++ applications." FORCE )
    endif()
    
    string( REGEX MATCH "(^|[ \t]+)${_item}([ \t]+|$)" _result "${CMAKE_C_FLAGS}" )
    if( NOT _result )
        set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${_item}" CACHE STRING "Flags used by all C applications." FORCE )
    endif()
  endforeach()

endif()

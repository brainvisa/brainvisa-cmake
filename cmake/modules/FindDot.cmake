# Find dot executable and libraries
# The following variables are set:
#
#  DOT_FOUND - Was dot found
#  DOT_EXECUTABLE  - path to the dot executable
#  DOT_LIBRARIES - path to graphviz dynamic libraries needed to run dot
#  DOT_VERSION - dot version

if( DOT_EXECUTABLE )

  set( Dot_FOUND true )

else( DOT_EXECUTABLE )
  
  find_program( DOT_EXECUTABLE
    NAMES dot
    PATHS "$ENV{ProgramFiles}/ATT/Graphviz/bin"
    "C:/Program Files/ATT/Graphviz/bin"
    [HKEY_LOCAL_MACHINE\\SOFTWARE\\ATT\\Graphviz;InstallPath]/bin
    /Applications/Graphviz.app/Contents/MacOS
    /Applications/Doxygen.app/Contents/Resources
    /Applications/Doxygen.app/Contents/MacOS
    DOC "Graphviz Dot tool"
  )
  
  if( DOT_EXECUTABLE )
    set( DOT_FOUND true )
    execute_process( COMMAND "${DOT_EXECUTABLE}" "-V"
                     OUTPUT_VARIABLE _output  ERROR_VARIABLE _output OUTPUT_STRIP_TRAILING_WHITESPACE
		     RESULT_VARIABLE _result)
    # VERSION
    if( _output AND _result EQUAL 0 )
      set( _versionRegex ".*version ([0-9]*)\\.([0-9]*)\\.([0-9]*).*" )
      string( REGEX REPLACE "${_versionRegex}" "\\1" DOT_VERSION_MAJOR "${_output}" )
      string( REGEX REPLACE "${_versionRegex}" "\\2" DOT_VERSION_MINOR "${_output}" )
      string( REGEX REPLACE "${_versionRegex}" "\\3" DOT_VERSION_PATCH "${_output}" )
      set( DOT_VERSION "${DOT_VERSION_MAJOR}.${DOT_VERSION_MINOR}.${DOT_VERSION_PATCH}")
      set( DOT_VERSION "${DOT_VERSION}" CACHE STRING "Dot full version")
    else()
      message( STATUS "Dot version not found" )
    endif()

    # LIBRARIES
    set( DOT_LIBRARIES )
    find_library( DOT_CDT_LIB cdt )
    if( NOT DOT_CDT_LIB )
      file( GLOB DOT_CDT_LIB /usr/lib/libcdt.so.? )
    endif()
    if(DOT_CDT_LIB)
      set( DOT_LIBRARIES ${DOT_LIBRARIES} "${DOT_CDT_LIB}")
    else()
      message( STATUS "Graphviz Cdt library not found" )
    endif()
    unset(DOT_CDT_LIB CACHE)

    find_library( DOT_GVC_LIB gvc )
    if( NOT DOT_GVC_LIB )
      file( GLOB DOT_GVC_LIB /usr/lib/libgvc.so.? )
    endif()
    if( DOT_GVC_LIB )
      set( DOT_LIBRARIES ${DOT_LIBRARIES} "${DOT_GVC_LIB}")
    else()
      message( STATUS "Graphviz gvc library not found" )
    endif()
    unset(DOT_GVC_LIB CACHE)

    find_library( DOT_PATHPLAN_LIB pathplan )
    if( NOT DOT_PATHPLAN_LIB )
      file( GLOB DOT_PATHPLAN_LIB /usr/lib/libpathplan.so.? )
    endif()
    if( DOT_PATHPLAN_LIB )
      set( DOT_LIBRARIES ${DOT_LIBRARIES} "${DOT_PATHPLAN_LIB}")
    else()
      message( STATUS "Graphviz pathplan library not found" )
    endif()
    unset(DOT_PATHPLAN_LIB CACHE)

    find_library( DOT_GRAPH_LIB graph NO_CMAKE_PATH )
    message("graph_lib : ${DOT_GRAPH_LIB}")
    if( NOT DOT_GRAPH_LIB )
      file( GLOB DOT_GRAPH_LIB /usr/lib/libgraph.so.? )
    endif()
    if( DOT_GRAPH_LIB )
      set( DOT_LIBRARIES ${DOT_LIBRARIES} "${DOT_GRAPH_LIB}")
    else()
      message( STATUS "Graphviz graph library not found" )
    endif()
    unset(DOT_GRAPH_LIB CACHE)

    if( DOT_LIBRARIES )
      set( DOT_LIBRARIES ${DOT_LIBRARIES} CACHE PATH "Graphviz dynamic libraries needed to run dot")
    endif()

    if( NOT Dot_FIND_QUIETLY )
      message( STATUS "Found dot: \"${DOT_EXECUTABLE}\" ${DOT_VERSION}" )
    endif( NOT Dot_FIND_QUIETLY )
  else( DOT_EXECUTABLE )
    set( Dot_FOUND false )
    if( NOT Dot_FIND_QUIETLY )
      if( NOT Dot_FIND_REQUIRED )
        message( FATAL_ERROR "Dot not found" )
      else( NOT Dot_FIND_REQUIRED )
        message( STATUS "Dot not found" )
      endif( NOT Dot_FIND_REQUIRED )
    endif( NOT Dot_FIND_QUIETLY )
  endif( DOT_EXECUTABLE )

endif( DOT_EXECUTABLE )

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
    execute_process( COMMAND ${EPYDOC_EXECUTABLE} --version
                     OUTPUT_VARIABLE _output
                     RESULT_VARIABLE _result )
    if( NOT Dot_FIND_QUIETLY )
      message( STATUS "Found dot: \"${DOT_EXECUTABLE}\"" )
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

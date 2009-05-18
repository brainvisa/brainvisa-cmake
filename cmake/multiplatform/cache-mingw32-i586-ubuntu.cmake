if( NOT BRAINVISA_CROSSCOMPILATION_DIR )
  message( FATAL_ERROR "BRAINVISA_CROSSCOMPILATION_DIR is not set" )
endif( NOT BRAINVISA_CROSSCOMPILATION_DIR )

set( PYTHON_EXECUTABLE /usr/bin/python2.5 CACHE FILEPATH "Python executable" )

set( PYTHON_LIBRARY "${BRAINVISA_CROSSCOMPILATION_DIR}/windows/lib/python25.dll" CACHE FILEPATH "Python library" )
set( PYTHON_INCLUDE_PATH "${BRAINVISA_CROSSCOMPILATION_DIR}/windows/include" CACHE PATH "Python include" )

set( SIP_EXECUTABLE "${BRAINVISA_CROSSCOMPILATION_DIR}/linux/bin/sip" CACHE FILEPATH "SIP executable" )
set( SIP_INCLUDE_DIR "${BRAINVISA_CROSSCOMPILATION_DIR}/windows/include" CACHE PATH "SIP include" )
execute_process( COMMAND ${SIP_EXECUTABLE} -V OUTPUT_VARIABLE SIP_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE )
set( SIP_VERSION "${SIP_VERSION}" CACHE STRING "Version of sip executable" )

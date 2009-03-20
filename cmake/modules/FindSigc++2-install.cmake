find_package( Sigc++2 REQUIRED )

set( _librariesToInstall )
foreach( _lib ${Sigc++2_LIBRARIES} )
  get_filename_component( _lib "${_lib}" ABSOLUTE )
  file( GLOB _libraries "${_lib}*" )
  set( _librariesToInstall ${_librariesToInstall} ${_libraries} )
endforeach( _lib ${Sigc++2_LIBRARIES} )
SOMA_INSTALL( FILES ${_librariesToInstall}
              DESTINATION lib
              COMPONENT system-runtime )

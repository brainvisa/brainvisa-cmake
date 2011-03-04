#if 0
  # Define environment variables modifications
  unset_variables = [ 'SIGRAPH_PATH', 'ANATOMIST_PATH', 'AIMS_PATH' ]
  set_variables = {
  'LC_NUMERIC': 'C',
  'BRAINVISA_SHARE': install_directory + '/share',
  }
  path_prepend = {
    'DCMDICTPATH': [ install_directory + '/lib/dicom.dic' ],
    'PYTHONPATH': [ install_directory + '/python' ],
    'PATH': [ install_directory + '/bin/real-bin', install_directory + '/bin' ],
    'LD_LIBRARY_PATH': [ install_directory + '/lib' ],
  }
  
  # Look for Python in install_directory
  python_dirs = glob( os.path.join( install_directory, 'lib', 'python*' ) )
  if python_dirs:
    python_version = python_dirs[ 0 ][ -3: ]
    set_variables[ 'PYTHONHOME' ] = install_directory
    path_prepend[ 'PYTHONPATH' ].append( install_directory + '/lib/python' + python_version + '/site-packages' )
  
  
  backup_variables = {}
  for n in unset_variables:
    if n in os.environ:
      backup_variables[ n ] = os.environ[ n ]
      del os.environ[ n ]
  for n, v in set_variables.iteritems():
    v = v.replace( '${INSTALL_DIRECTORY}', install_directory )
    if n in os.environ and os.environ[ n ] != v:
      backup_variables[ n ] = os.environ[ n ]
    os.environ[ n ] = v
  for n, l in path_prepend.iteritems():
    if n in os.environ:
      backup_variables[ n ] = os.environ[ n ]
      content = os.environ[ n ].split( os.pathsep )
    else:
      content = []
    
    for v in reversed( l ):
      v = v.replace( '${INSTALL_DIRECTORY}', install_directory )
      content.insert( 0, v )
    os.environ[ n ] = os.pathsep.join( ( i for i in content if os.path.exists( i ) ) )
  
  if len( sys.argv ) > 1:
    for n, v in backup_variables.iteritems():
      os.environ[ 'BRAINVISA_UNENV_' + n ] = v
    os.execvpe( sys.argv[1], sys.argv[ 1: ], os.environ )
  else:
    for n, v in backup_variables.iteritems():
      print 'export BRAINVISA_UNENV_' + n + "='" + v + "'"
    for n in unset_variables:
      print 'unset', n
    for n in set_variables:
      print 'export', n + "='" + os.environ[ n ] + "'"
    for n in path_prepend:
      v = os.environ[ n ]
      if v:
        print 'export', n + "='" + v + "'"
#endif

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cstdlib>
#include <sys/stat.h>
#include <dirent.h>

using namespace std;

#ifdef WIN32
  #define PATH_SEP "\\"
  #define ENV_SEP ";"
#else
  #define PATH_SEP "/"
  #define ENV_SEP ":"
#endif



string replace( const string &match, const string &value )
{
  return value;
}

vector <string> split_path( const string &str,
                            const string &delimiters = "/\\" )
{
  vector <string> result;
  // Skip delimiters at beginning.
  string::size_type lastPos = str.find_first_not_of( delimiters, 0 );
  // Find first "non-delimiter".
  string::size_type pos = str.find_first_of( delimiters, lastPos );

  if ( lastPos ) result.push_back( PATH_SEP );
  while ( string::npos != pos || string::npos != lastPos )
  {
    // Found a token, add it to the vector
    result.push_back( str.substr( lastPos, pos - lastPos ) );
    // Skip delimiters.  Note the "not_of"
    lastPos = str.find_first_not_of( delimiters, pos );
    // Find next "non-delimiter"
    pos = str.find_first_of(delimiters, lastPos);
  }
  return result;
}


string join_path( const vector< string > &splitted, const string &sep = PATH_SEP )
{
  string result;
  bool add_sep = false;
  
  for( vector< string >::const_iterator it = splitted.begin(); it != splitted.end(); ++it ) {
    if ( add_sep ) result += sep;
    result += *it;
    if ( *it != sep ) add_sep = true;
  }
  return result;
}


string getenv( const string &variable )
{
  char *env = std::getenv( variable.c_str() );
  if ( env ) return env;
  return string();
}

void set_env( const string &variable, const string &value )
{
#if WIN32
  string envp = variable + "=" + value;
  putenv( envp.c_str() );
#else
  setenv( variable.c_str(), value.c_str(), 1 );
#endif
}


void unsetenv( const string &variable )
{
#if WIN32
  string envp = variable + "=";
  putenv( envp.c_str() );
#else
  setenv( variable.c_str(), NULL, 1 );
#endif
}


string current_directory()
{
  return getcwd( NULL, 0 );
}



string find_python_site_packages( const string &install_directory )
{
  string result;
  DIR *dir = opendir( (install_directory + PATH_SEP "lib").c_str() );
  if ( dir ) {
    for( struct dirent *entry = readdir( dir ); entry; entry = readdir( dir ) ) {
      const string entry_name = entry->d_name;
      if ( entry_name.compare( 0, 6, "python" ) ) {
        result = install_directory + PATH_SEP "lib" + entry_name + "site-packages";
        break;
      }
    }
    closedir( dir );
  }
  return result;
}


bool file_exists( string file_name ) 
{
  struct stat stFileInfo;
  bool blnReturn;
  int intStat;

  // Attempt to get the file attributes
  intStat = stat( file_name.c_str(),&stFileInfo );
  if(intStat == 0) {
    // We were able to get the file attributes
    // so the file obviously exists.
    blnReturn = true;
  } else {
    // We were not able to get the file attributes.
    // This may mean that we don't have permission to
    // access the folder which contains this file. If you
    // need to do that level of checking, lookup the
    // return values of stat which will give you
    // more details on why stat failed.
    blnReturn = false;
  }
  return(blnReturn);
}


int main( int argc, const char *argv[], const char *envp[] )
{
/*  if os.path.exists( sys.argv[0] ):
    this_script = sys.argv[0]
  else:
    this_script = None
    for p in os.environ.get( 'PATH', '' ).split( os.pathsep ) + [ os.curdir ]:
      s = os.path.join( p, sys.argv[0] )
      if os.path.exists( s ):
        this_script = s
        break
  if this_script:
    install_directory = os.path.dirname( os.path.dirname( this_script ) )*/
  string install_directory;
  vector< string > argv0 = split_path( argv[0] );
  if ( argv0.size() > 1 ) {
    if ( argv0[ 0 ] != PATH_SEP ) {
      // relative directory
      vector< string > curdir = split_path( current_directory() );
      argv0.insert( argv0.begin(), curdir.begin(), curdir.end() );
    }
    argv0.pop_back();
    argv0.pop_back();
    install_directory = join_path( argv0 );
  } else {
    vector< string > path = split_path( getenv( "PATH" ), ENV_SEP );
    path.push_back( current_directory() );
    for( vector< string >::const_iterator it = path.begin(); it != path.end(); ++it ) {
      vector <string> l = split_path( *it );
      l.push_back( argv[0] );
      if ( file_exists( join_path( l ) ) ) {
        l.pop_back();
        l.pop_back();
        install_directory = join_path( l );
      }
    }
  }
/*  string install_directory( argv[ 0 ] );
  size_t last_separator = install_directory.rfind( "/" );
  if ( ! last_separator ) last_separator = install_directory.rfind( "\\" );
  if ( last_separator ) {
    install_directory = install_directory.substr( 0, last_separator );
  } else {
    install_directory = "";
  }*/
  
  vector< string > unset_variables = split_path( "SIGRAPH_PATH:ANATOMIST_PATH:AIMS_PATH", ":" );
  
  map< string, string > set_variables;
  set_variables[ "LC_NUMERIC" ] = "C";
  set_variables[ "BRAINVISA_SHARE" ] = install_directory + PATH_SEP "share";
  
  map< string, vector< string > > path_prepend;
  path_prepend[ "DCMDICTPATH" ] = split_path( install_directory + PATH_SEP "lib" PATH_SEP "dicom.dic", ":" );
  path_prepend[ "PYTHONPATH" ] = split_path( install_directory + PATH_SEP "python", ":" );
  path_prepend[ "PATH" ] = split_path( install_directory + PATH_SEP "real-bin" + ":" + install_directory + PATH_SEP "bin", ":" );
  path_prepend[ "LD_LIBRARY_PATH" ] = split_path( install_directory + PATH_SEP "lib", ":" );

  string site_packages = find_python_site_packages( install_directory );
  if ( ! site_packages.empty() ) {
    set_variables[ "PYTHONHOME" ] = install_directory;
    path_prepend[ "PYTHONPATH" ].push_back( site_packages );
  }
  
  
//   cout << "install_directory=" << install_directory << endl;
//   map< string, string > backup_variables;
//   for( vector< string >::const_iterator it = unset_variables.begin(); it != unset_variables.end(); ++it ) {
//     string env = getenv( *it );
//     if ( ! env.empty ) {
//       backup_variables[ *it ] = env;
//       unsetenv( *it );
//     }
//   }
//   for( map< string, string>::const_iterator it = set_variables.begin(); it != set_variables.end(); ++it ) {
//     string v = replace( it->second, "${INSTALL_DIRECTORY}", install_directory );
//     string env = getenv( it->first );
//     if ( ! env.empty() and env != v ) {
//       backup_variables[ it->first ] = env;
//       set_env( it->first, v );
//     }
//   }


// for n, l in path_prepend.iteritems():
//   if n in os.environ:
//     backup_variables[ n ] = os.environ[ n ]
//     content = os.environ[ n ].split( os.pathsep )
//   else:
//     content = []
//   
//   for v in reversed( l ):
//     v = v.replace( '${INSTALL_DIRECTORY}', install_directory )
//     content.insert( 0, v )
//   os.environ[ n ] = os.pathsep.join( ( i for i in content if os.path.exists( i ) ) )

  return 0;
}

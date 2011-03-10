#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cstdlib>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h> // for execvp()
using namespace std;

#ifdef WIN32
  #define PATH_SEP "\\"
  #define ENV_SEP ";"
#else
  #define PATH_SEP "/"
  #define ENV_SEP ":"
#endif



vector <string> split_path( const string &str, const string & sep = PATH_SEP  )
{
  vector <string> result;
  if ( ! str.empty() ) {
    string::size_type pos = 0;
    if ( str[ 0 ] == PATH_SEP[0] ) {
      result.push_back( "" );
      pos = 1;
    }
    while ( pos < str.size() ) {
      string::size_type pos2 = str.find( sep, pos );
      if ( pos2 == string::npos ) {
        result.push_back( str.substr( pos ) );
        break;
      } else {
        result.push_back( str.substr( pos, pos2 - pos ) );
        pos = pos2 + 1;
      }
    }
  }
  return result;
}


vector <string> split_env( const string &str, const string & sep = ENV_SEP )
{
  vector <string> result;
  if ( ! str.empty() ) {
    string::size_type pos = 0;
    while ( pos < str.size() ) {
      string::size_type pos2 = str.find( sep, pos );
      if ( pos2 == string::npos ) {
        result.push_back( str.substr( pos ) );
        break;
      } else {
        result.push_back( str.substr( pos, pos2 - pos ) );
        pos = pos2 + 1;
      }
    }
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
      if ( entry_name.compare( 0, 6, "python" ) == 0 ) {
        string site_packages = install_directory + PATH_SEP "lib" PATH_SEP + entry_name + PATH_SEP "site-packages";
        DIR *dir2 = opendir( site_packages.c_str() );
        if ( dir2 ) {
          closedir( dir2 );
          result = site_packages;
          break;
        }
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


int main( int argc, char *argv[] )
{
  string install_directory;
  vector< string > argv0 = split_path( argv[0] );
  if ( argv0.size() > 1 ) {
    if ( ! argv0[ 0 ].empty() ) {
      // relative directory
      vector< string > curdir = split_path( current_directory() );
      argv0.insert( argv0.begin(), curdir.begin(), curdir.end() );
    }
    argv0.pop_back();
    argv0.pop_back();
    install_directory = join_path( argv0 );
  } else {
    vector< string > path = split_env( getenv( "PATH" ) );
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
  
  vector< string > unset_variables = split_path( "SIGRAPH_PATH/ANATOMIST_PATH/AIMS_PATH", "/" );
  
  map< string, string > set_variables;
  set_variables[ "LC_NUMERIC" ] = "C";
  set_variables[ "BRAINVISA_SHARE" ] = install_directory + PATH_SEP "share";
  
  map< string, vector< string > > path_prepend;
  path_prepend[ "DCMDICTPATH" ] = split_env( install_directory + PATH_SEP "lib" PATH_SEP "dicom.dic" );
  path_prepend[ "PYTHONPATH" ] = split_env( install_directory + PATH_SEP "python" );
  path_prepend[ "PATH" ] = split_env( install_directory + PATH_SEP "real-bin" + ":" + install_directory + PATH_SEP "bin" );
  path_prepend[ "LD_LIBRARY_PATH" ] = split_env( install_directory + PATH_SEP "lib" );

  string site_packages = find_python_site_packages( install_directory );
  if ( ! site_packages.empty() ) {
    set_variables[ "PYTHONHOME" ] = install_directory;
    path_prepend[ "PYTHONPATH" ].push_back( site_packages );
  }
  
  
  map< string, string > backup_variables;
  for( vector< string >::const_iterator it = unset_variables.begin(); it != unset_variables.end(); ++it ) {
    string env = getenv( *it );
    if ( ! env.empty() ) {
      backup_variables[ *it ] = env;
      unsetenv( *it );
    }
  }
  for( map< string, string>::const_iterator it = set_variables.begin(); it != set_variables.end(); ++it ) {
    string env = getenv( it->first );
    if ( ! env.empty() and env != it->second ) {
      backup_variables[ it->first ] = env;
    }
    set_env( it->first, it->second );
  }

  for( map< string, vector<string> >::const_iterator it = path_prepend.begin(); it != path_prepend.end(); ++it ) {
    vector< string > content;
    string env = getenv( it->first );
    if ( ! env.empty() ) {
      backup_variables[ it->first ] = env;
      content = split_env( env );
    }
    
    for( vector< string >::const_reverse_iterator it2 = it->second.rbegin(); it2 != it->second.rend(); ++it2 ) {
      if ( file_exists( *it2 ) ) {
        content.insert( content.begin(), *it2 );
      }
    }
    set_env( it->first, join_path( content, ":" ) );
  }

  const string unenv_prefix( "BRAINVISA_UNENV_" );
  if ( argc > 1 ) {
    for( map< string, string>::const_iterator it = backup_variables.begin(); it != backup_variables.end(); ++it ) {
      set_env(  unenv_prefix + it->first, it->second );
    }
    execvp( argv[1], argv + 1 );
  } else {
    for( map< string, string>::const_iterator it = backup_variables.begin(); it != backup_variables.end(); ++it ) {
      cout <<  unenv_prefix << it->first << "='" << it->second << "'" << endl;
    }
    for( vector< string >::const_iterator it = unset_variables.begin(); it != unset_variables.end(); ++it ) {
      cout << "unset " << *it << endl;
    }
    for( map< string, string>::const_iterator it = set_variables.begin(); it != set_variables.end(); ++it ) {
      cout << "export " << it->first << "='" << getenv( it->first ) << "'" << endl;
    }
    for( map< string, vector<string> >::const_iterator it = path_prepend.begin(); it != path_prepend.end(); ++it ) {
      string v = getenv( it->first );
      if ( ! v.empty() ) {
        cout << "export " << it->first << "='" << v << "'" << endl;
      }
    }
  }
  return 0;
}

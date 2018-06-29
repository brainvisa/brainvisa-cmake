#include <iostream>
#include <sstream>
#include <vector>
#include <map>
#include <fstream>
#include <algorithm>
#include <cstdlib>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h> // for execvp()
#include <string.h> // for strcpy()
#include <stdio.h> // for perror()
using namespace std;

// It is necessary to first redefine getenv function
string getenv( const string &variable, 
               const string &defaultval = string() )
{
  char *env = std::getenv( variable.c_str() );
  if ( env ) return env;
  return defaultval;
}

enum system_conversion {
  WindowsToMsys,
  WineToUnix,
  UnixToWine,
  MsysToWindows
};

#define UNIX_PATH_SEP "/"
#define UNIX_ALTERNATE_PATH_SEP ""
#define UNIX_ENV_SEP ":"
#define UNIX_LD_LIBRARY_PATH "LD_LIBRARY_PATH"

#define WIN_PATH_SEP "\\"
#define WIN_ALTERNATE_PATH_SEP UNIX_PATH_SEP
#define WIN_ENV_SEP ";"
#define WIN_LD_LIBRARY_PATH "PATH"

#define APPLE_LD_LIBRARY_PATH "DYLD_LIBRARY_PATH"
  
#ifdef WIN32
 
  #define PATH_SEP WIN_PATH_SEP
  #define ALTERNATE_PATH_SEP WIN_ALTERNATE_PATH_SEP
  #define ENV_SEP WIN_ENV_SEP
    
  #define LD_LIBRARY_PATH \
    ( is_msys_term() ? UNIX_LD_LIBRARY_PATH : WIN_LD_LIBRARY_PATH )

string get_term()
{
  static string ostermkey = "TERM";
  static string osterm = getenv( ostermkey );
  return osterm;
}

bool is_dos_term()
{
  return (get_term() == "");
}

bool is_msys_term()
{
  return ((get_term() == "msys") || 
          (get_term() == "cygwin"));
}

bool is_wine_term()
{
  return ((get_term() != "") 
        && !is_msys_term());
}

#else
  #define PATH_SEP UNIX_PATH_SEP
  #define ALTERNATE_PATH_SEP UNIX_ALTERNATE_PATH_SEP
  #define ENV_SEP UNIX_ENV_SEP
  
  #ifdef __APPLE__
    #define LD_LIBRARY_PATH APPLE_LD_LIBRARY_PATH
  #else
    #define LD_LIBRARY_PATH UNIX_LD_LIBRARY_PATH
  #endif
#endif

bool is_sep(const char c, const string & sep = PATH_SEP) {
 
  bool res = false;
  
  // Test if string is one of PATH_SEP¨characters
  for (string::size_type i = 0; i < sep.size(); i++) {
    if (c == sep[i]) {
      res = true;
      break;
    }
  }
  
  return res;
}

vector <string> split_path( const string &str, const string & sep = string(PATH_SEP) + string(ALTERNATE_PATH_SEP) )
{
  vector <string> result;
  if ( ! str.empty() ) {
    string::size_type pos = 0;

    if ( (str.size() == 1) && is_sep(str[0], sep) ) {
      result.push_back( "" );
      pos = 1;
    }
    while ( pos < str.size() ) {
      // Search the next character of PATH_SEP in the string
      string::size_type pos2 = string::npos;
      for (string::size_type i = 0; i < sep.size(); i++){
        string::size_type pos3 = str.find( sep[i], pos );
        if ((pos3 != string::npos) && (pos3 < pos2)) {
          pos2 = pos3;
        }
      }
      
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

string get_wineprefix()
{
  static string wineprefixkey = "WINEPREFIX";
  static string wineprefix = getenv(wineprefixkey, "~/.wine");
  return wineprefix;
}

string convert_path( const string &str, const system_conversion mode = WindowsToMsys )
{
  vector <string> v;
  string r = str;
  
  switch(mode) {
    case WineToUnix:
    case WindowsToMsys:
      v = split_path( str, string(WIN_PATH_SEP) + string(WIN_ALTERNATE_PATH_SEP) );
      if ((v.size() > 0) && (v[0].size() == 2) && (v[0][1] == ':')) {
        if(mode == WindowsToMsys) {
          // Drive letter found
          // Remove ":" from drive letter
          v[0] = UNIX_PATH_SEP + v[0].replace( 1, 1, "" );

        }
        else {
            // Convert from wine path to unix, especially replaces
            // drives with maching 
            v[0][0] = std::tolower(v[0][0]);
            vector<string> w = split_path(get_wineprefix());
            w.push_back("dosdevices");
            v.insert(v.begin(), w.begin(), w.end());
        }
      }
      r = join_path( v, UNIX_PATH_SEP );
      break;

    case UnixToWine:
    case MsysToWindows:
      v = split_path( str, UNIX_PATH_SEP );
      if ((mode == MsysToWindows) && ((v.size() > 1) && (v[0].size() == 0) && (v[1].size() == 1))) {
        // Drive letter probably found
        // Add ":" to drive letter
        v[1] += ":";
        r = join_path( v, WIN_PATH_SEP ).substr(1); // Join removing root path separator
      }
      else if (mode == UnixToWine) {
        // Check that path does not already begin with wine
        // dosdevices path (linux path to the drive letters) 
        // before prepending it. This should avoid to prepend
        // wine dosdevices path many times.
        vector<string> w = split_path(get_wineprefix());
        w.push_back("dosdevices");
        vector<string> s(w.size());
        copy(v.begin(), v.begin() + w.size(), s.begin());
        
        if (w != s) {
          // Found a path that does not begin with wine dosdevices path  
          if ((v.size() > 0) && (v[0].size() == 0)) {
            // Found absolute path add "z:" drive letter
            v[0] = "z:";
          }
          else {
            // Insert wine dosdevices path at the begin of path
            v.insert(v.begin(), w.begin(), w.end());
          }
        }
      }
      r = join_path( v, WIN_PATH_SEP );
      break;
  }
  return r;
}

string convert_env( const string &str, const system_conversion mode = WindowsToMsys )
{
  vector <string> v;
  string sep1 = WIN_ENV_SEP, sep2 = UNIX_ENV_SEP;
  
  switch(mode) {
    case UnixToWine:
    case MsysToWindows:
      sep1 = UNIX_ENV_SEP;
      sep2 = WIN_ENV_SEP;
      break;
    default:
      break;
  }
  
  v = split_env( str, sep1 );
  for( vector< string >::iterator it = v.begin(); it != v.end(); ++it ) {
    (*it) = convert_path( *it, mode );
  }
  return join_path( v, sep2 );
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
  unsetenv( variable.c_str() );
#endif
}


string current_directory()
{
  return getcwd( NULL, 0 );
}



string find_python_site_packages( const string &install_directory )
{
  string result;
  DIR *dir = opendir( (install_directory + PATH_SEP + "lib").c_str() );
  if ( dir ) {
    for( struct dirent *entry = readdir( dir ); entry; entry = readdir( dir ) ) {
      const string entry_name = entry->d_name;
      if ( entry_name.compare( 0, 6, "python" ) == 0 ) {
#if WIN32
        string site_packages = install_directory + PATH_SEP + "lib" + PATH_SEP + entry_name + PATH_SEP + "lib" + PATH_SEP + "site-packages";
#else
        string site_packages = install_directory + PATH_SEP + "lib" + PATH_SEP + entry_name + PATH_SEP + "site-packages";
#endif
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


bool filesystem_exists( string file_name ) 
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


string find_python_osmodule( const string &install_directory )
{
  string result;
  DIR *dir = opendir( (install_directory + PATH_SEP + "lib").c_str() );
  if ( dir ) {
    for( struct dirent *entry = readdir( dir ); entry; entry = readdir( dir ) ) {
      const string entry_name = entry->d_name;
      if ( entry_name.compare( 0, 6, "python" ) == 0 ) {
#if WIN32
        string site_os = install_directory + PATH_SEP + "lib" + PATH_SEP + entry_name + PATH_SEP + "lib" + PATH_SEP + "os.py";
#else
        string site_os = install_directory + PATH_SEP + "lib" + PATH_SEP + entry_name + PATH_SEP + "os.py";
#endif
        if( filesystem_exists( site_os ) )
        {
          result = site_os;
          break;
        }
      }
    }
    closedir( dir );
  }
  return result;
}


bool is_full_path( const string & exe_name )
{
  if( exe_name.empty() )
    return false;
  if( exe_name[0] == PATH_SEP[0] )
    return true;
  if( exe_name.find( PATH_SEP ) != string::npos )
    return true;
  return false;
}


string find_in_path( const string & exe_name )
{
  if( is_full_path( exe_name ) )
    return exe_name;

  vector< string > path = split_env( getenv( "PATH" ) );
  vector< string >::const_iterator i, e = path.end();
  for( i=path.begin(); i!=e; ++i )
  {
    string full_path = *i + PATH_SEP + exe_name;
    if( filesystem_exists( full_path ) )
      return full_path;
  }

  return "";
}


bool is_python_script( const string & arg )
{
  if( arg.length() >= 3
      && arg.substr( arg.length() - 3, 3 ) == ".py" )
    return true;

  string full_path = find_in_path( arg );
  if( full_path.empty() )
    return false;

  ifstream f( full_path.c_str() );
  if( !f )
    return false;

  string start, ref = "#!/usr/bin/env python";
  int c = 0, i, n = ref.length();

  for( i=0; i<n; )
  {
    c = f.get();
    if( c == 0 || c == '\n' || c == '\r' || !f )
    {
      return false;
    }
    if( !( c == ' ' && ( start.empty()
        || start[start.length() - 1] == ' ' ) ) )
    {
      start += c;
      if( c != ref[i] )
      {
        if( i == 2 && c == ' ' )
        {
          // optional space: #! /usr/bin/env python
          continue;
        }
        return false;
      }
      ++i;
    }
  }

  return true;
}

vector<const char *> win_escape_command_args(vector<const char *> args) {
    string arg;
    vector<const char *> escaped;
    vector<const char *>::const_iterator it, ie = args.end();
    for(it = args.begin(); it != ie; ++it) {
        if (*it) {
            string arg = string(*it);
            
            // Fixes special " windows character in cases were argument is not
            // an option argument (i.e. begining with /), otherwise the option
            // will not be interpreted
            string::size_type pos = arg.find("/");
            if (pos != 0) {
                pos = arg.find( "\"" );
                while(pos != string::npos) {
                    arg.replace(pos, 1, "\\\"");
                    pos = arg.find( "\"", pos + 2  );
                }

                arg = "\"" + arg + "\"";
            }
            escaped.push_back(strdup(arg.c_str()));
        }
        else {
            escaped.push_back( *it );
        }
    }

    return escaped;
}

template <typename T>
void vector_free_ptr_values(vector<T*> & v) 
{
    typename vector<T*>::iterator it, ie = v.end();
    for(it = v.begin(); it != ie; ++it)
        if (*it)
            free((void*)*it);
}

int main( int argc, char *argv[] )
{
  string install_directory;
  vector< string > argv0 = split_path( argv[0] );

  if( argc >= 2 &&
      ( string( argv[1] ) == "-h" || string( argv[1] ) == "--help" ) )
  {
    cout << "bv_env [command [command_arg [...]]]\n\n";
    cout << "run a command in brainvisa-cmake paths environment.\n\n";
    cout << "Without arguments, print the runtime environment to be used "
            "on the standard output\n",
    cout << "With arguments, set the runtime environment, and run the "
            "command passed in arguments in this environment.\n";
    exit(0);
  }

  if ( argv0.size() > 1 )
  {
    if ( ( ! argv0[ 0 ].empty() )
#if WIN32
        // Windows has a letter for drives, so we must add conditions to know if path is relative
        && ( argv0[0][1] != ':' )
#endif
    ) {
      // relative directory
      while( argv0.size() && argv0[ 0 ] == string( "." ) ) argv0.erase( argv0.begin() );
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
      if ( filesystem_exists( join_path( l ) ) ) {
        l.pop_back();
        l.pop_back();
        install_directory = join_path( l );
        break;
      }
    }
  }
    
  vector< string > unset_variables = split_path( "SIGRAPH_PATH/ANATOMIST_PATH/AIMS_PATH", "/" );
  
  map< string, string > set_variables;
  set_variables[ "LC_NUMERIC" ] = "C";
  set_variables[ "BRAINVISA_HOME" ] = install_directory;
  set_variables[ "BRAINVISA_SHARE" ] = install_directory + PATH_SEP + "share";
#ifdef __APPLE__
  set_variables[ "QT_PLUGIN_PATH" ] = install_directory + PATH_SEP + "lib" + PATH_SEP + "qt-plugins";
#else
  if( filesystem_exists( install_directory + PATH_SEP + "lib" + PATH_SEP
    + "qt-plugins" ) )
  {
    // binary install: remove any QT_PLUGIN_PATH naming system libs
    unset_variables.push_back( "QT_PLUGIN_PATH" );
  }
#endif
  map< string, vector< string > > path_prepend;
  
  path_prepend[ "DCMDICTPATH" ] = split_env( install_directory + PATH_SEP + "lib" + PATH_SEP + "dicom.dic" );

  path_prepend[ "PYTHONPATH" ] = split_env( install_directory + PATH_SEP + "python" );
#ifndef WIN32
  std::string osmodule = find_python_osmodule( install_directory );
  std::string moddir = osmodule.size() > 6 
                     ? osmodule.substr(0, osmodule.size() - 6)
                     : "";
  std::string pythondir = install_directory + PATH_SEP + "python";
  if(!moddir.empty() && moddir != pythondir) {
    // CentOS fixes
    path_prepend[ "PYTHONPATH" ].push_back(moddir);
    std::string dynloaddir = moddir + PATH_SEP + "lib-dynload";
    if (filesystem_exists(dynloaddir))
      path_prepend[ "PYTHONPATH" ].push_back(dynloaddir);
        
  }
#endif
  
  path_prepend[ "PATH" ] = split_env( install_directory + PATH_SEP + "bin" + PATH_SEP + "real-bin" + ENV_SEP + install_directory + PATH_SEP + "bin" );

#ifdef WIN32
  vector< string > libpath = split_env( install_directory + PATH_SEP + "lib" + ENV_SEP
                                        + install_directory + PATH_SEP + "lib"+ PATH_SEP + "python" + ENV_SEP
                                        + install_directory + PATH_SEP + "lib"+ PATH_SEP + "python"+ PATH_SEP + "DLLs" );
#else
  vector< string > libpath = split_env( install_directory + PATH_SEP + "lib" );
#endif  

  string site_packages = find_python_site_packages( install_directory );
  if ( ! site_packages.empty() )
  {
    path_prepend[ "PYTHONPATH" ].push_back( site_packages );
#ifdef WIN32
    libpath.push_back( site_packages + PATH_SEP + "pywin32_system32" );
    libpath.push_back( site_packages + PATH_SEP + "pythonwin" );
    //libpath.push_back( site_packages + PATH_SEP + "OpenGL" + PATH_SEP + "DLLs" );
    //libpath.push_back( site_packages + PATH_SEP + "isapi" );
    path_prepend[ "PYTHONPATH" ].push_back( site_packages + PATH_SEP + "win32" );
    path_prepend[ "PYTHONPATH" ].push_back( site_packages + PATH_SEP + "win32"+ PATH_SEP + "lib" );
#endif
  }
  
  map< string, vector< string > >::iterator pit = path_prepend.find( LD_LIBRARY_PATH );
  if ( pit != path_prepend.end())
     pit->second.insert( pit->second.begin(), libpath.begin(), libpath.end() );
  else
    path_prepend[ LD_LIBRARY_PATH ] = libpath;

#ifdef __APPLE__
  // Apple also uses a DYLD_FRAMEWORK_PATH (for Qt...)
  vector<string> frameworks;
  frameworks.push_back( install_directory + PATH_SEP + "lib" );
  path_prepend[ "DYLD_FRAMEWORK_PATH" ] = frameworks;
#endif

#ifdef WIN32
  if( !find_python_osmodule( install_directory ).empty() )
    set_variables[ "PYTHONHOME" ] = install_directory + PATH_SEP + "lib" + PATH_SEP + "python";
#else
  if( !find_python_osmodule( install_directory ).empty() )
    set_variables[ "PYTHONHOME" ] = install_directory;
#endif

  // use PyQt rather than Pyside if not already specified in QT_API envar
  // because if PySide is used while not installed on the binary package python
  // it can cause crashes.
#ifdef DESIRED_QT_VERSION
  // may be specified by the build system configuration
  // if this is given this way, we force QT_ENV variable to force it match
  // the build.
#if DESIRED_QT_VERSION == 5
  set_variables[ "QT_API" ] = "pyqt5";
#else
  set_variables[ "QT_API" ] = "pyqt";
#endif
#else
  // DESIRED_QT_VERSION is not specified: the env variable has priority.
  char *qtapi = getenv( "QT_API" );
  if( !qtapi )
    set_variables[ "QT_API" ] = "pyqt";
#endif

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
    else{
      backup_variables[ it->first ] = "";
    }
    
    for( vector< string >::const_reverse_iterator it2 = it->second.rbegin(); it2 != it->second.rend(); ++it2 ) {
      if ( filesystem_exists( *it2 ) ) {
        content.insert( content.begin(), *it2 );
      }
    }
    set_env( it->first, join_path( content, ENV_SEP ) );
  }

#ifdef __APPLE__
  /* On MacOS >= 10.10, DYLD_LIBRARY_PATH variables are erased when in a
     script (shell/bash script, or python or other script run via a shebang).
     We set different variables to copy their values, so that scripts knowing
     this can retreive them if needed.
  */
  if( getenv( "DYLD_LIBRARY_PATH" ) )
  {
    set_env( "BV_MAC_LIB_PATH", getenv( "DYLD_LIBRARY_PATH" ) );
    set_variables[ "BV_MAC_LIB_PATH" ] = getenv( "DYLD_LIBRARY_PATH" );
  }
  if( getenv( "DYLD_FRAMEWORK_PATH" ) )
  {
    set_env( "BV_MAC_FWK_PATH", getenv( "DYLD_FRAMEWORK_PATH" ) );
    set_variables[ "BV_MAC_FWK_PATH" ] = getenv( "DYLD_FRAMEWORK_PATH" );
  }
  if( getenv( "DYLD_FALLBACK_LIBRARY_PATH" ) )
  {
    set_env( "BV_MAC_FBL_PATH", getenv( "DYLD_FALLBACK_LIBRARY_PATH" ) );
    set_variables[ "BV_MAC_FBL_PATH" ] = getenv( "DYLD_FALLBACK_LIBRARY_PATH" );
  }
#endif

  const string unenv_prefix( "BRAINVISA_UNENV_" );
  if ( argc > 1 )
  {
    vector<const char*> args;

    // check if the command is a python script, to avoid running a useless
    // shell, which would also cause problems on MacOS 10.11 and possibly
    // on Windows
    //std::cout << argv[1] << " is python script:" << is_python_script( argv[1] ) << std::endl;
    bool add_full_path = false;
    if( is_python_script( argv[1] ) )
    {
      args.push_back( strdup( "python" ) );
      add_full_path = true;
    }

    for( map< string, string>::const_iterator it = backup_variables.begin(); it != backup_variables.end(); ++it ) {
      set_env(  unenv_prefix + it->first, it->second );
    }
#ifndef _WIN32
    for(int i = 0; i < (argc - 1); i++) {
      args.push_back( strdup( argv[i + 1] ) );
    }
    args.push_back( (const char *)NULL );

    if( add_full_path )
      args[1] = strdup( find_in_path( args[1] ).c_str() );

    execvp( args[0], (char * const *)&args[0] );

    // Free allocated memory
    vector_free_ptr_values(args);

    // execvp returns only when the command cannot be executed
    ostringstream error_string;
    error_string << argv[0] << ": cannot execute " << argv[1];

    cerr.flush(); // perror writes to standard error
    perror(error_string.str().c_str());

    return 1;
#else
    for(int i = 0; i < (argc - 1); i++) {
      args.push_back( strdup( argv[i + 1] ) );
    }
    args.push_back( (const char *)NULL );

    if( add_full_path )
      args[1] = strdup( find_in_path( args[1] ).c_str() );

    // Double-quoted arguments is required on windows before spawnvp call
    // otherwise contained spaces are used as argument separator
    vector<const char *> escaped_args = win_escape_command_args(args);

//     cout << "Executing command : " << args[0] << endl << flush;
//     cout << "Using arguments : " << endl << flush;
//     vector<const char *>::const_iterator eait, eaie = escaped_args.end();
//     for(eait = escaped_args.begin(); eait != eaie; ++eait) {
//       cout << (*eait) << endl << flush;
//     }
    
    // Command call: program name must not be enclosed by ""
    int res = _spawnvp( P_WAIT, args[0], (char * const *)&escaped_args[0] );
    
    // Free allocated memory
    vector_free_ptr_values(args);
    vector_free_ptr_values(escaped_args);

    if( res < 0 ) 
    {
      // Error that indicates that the command was unable to execute 
      // -2 File not found 
      // -3 Path not found 
      // -11 Invalid .exe file (for Windows) 
      // -13 DOS 4. 0 application 
      // -14 Unknown .exe type (may be DOS extended) 
      ostringstream error_string;
      error_string << argv[0] << ": cannot execute " << argv[1] << " (error: " << res << ")";

      cerr.flush(); // perror writes to standard error
      perror(error_string.str().c_str());
      return EXIT_FAILURE;
    }
    return res;

#endif
  } else {
  
  //bool dos_term = false;
  bool msys_term = false;
  bool wine_term = false;
  
#ifdef WIN32
  // We only use windows format in dos shell
  msys_term = is_msys_term();
  //dos_term = is_dos_term();
  wine_term = is_wine_term();
#endif

#define CONVERT_ENV(env) \
( msys_term \
  ? convert_env(env, WindowsToMsys) \
  : ( wine_term \
      ? convert_env(env, WineToUnix) \
      : env ) )
  
    string value;
    for( map< string, string>::const_iterator it = backup_variables.begin(); it != backup_variables.end(); ++it ) {
#ifdef WIN32
      if( !msys_term )
      {
        cout <<  "set " << unenv_prefix << it->first << "=" << it->second << endl;
      }
      else
      {    
#endif
        cout <<  "export " << unenv_prefix << it->first << "='" << CONVERT_ENV(it->second) << "'" << endl;
#ifdef WIN32
      }
#endif
    }
    for( vector< string >::const_iterator it = unset_variables.begin(); it != unset_variables.end(); ++it ) {
#ifdef WIN32
      if( !msys_term )
      {
        cout <<  "set " << *it << "=" << endl;
      }
      else
      {
#endif
        cout << "unset " << *it << endl;
#ifdef WIN32
      }
#endif
    }
    for( map< string, string>::const_iterator it = set_variables.begin(); it != set_variables.end(); ++it ) {
#ifdef WIN32
      if( !msys_term )
      {
        cout <<  "set " << it->first << "=" << getenv( it->first ) << endl;
      }
      else
      {
#endif
        cout << "export " << it->first << "='" << CONVERT_ENV(getenv( it->first )) << "'" << endl;
#ifdef WIN32
      }
#endif
    }
    for( map< string, vector<string> >::const_iterator it = path_prepend.begin(); it != path_prepend.end(); ++it ) {
      string v = getenv( it->first );
      if ( ! v.empty() ) {
#ifdef WIN32
        if( !msys_term )
        {
          cout <<  "set " << it->first << "=" << v << endl;
        }
        else
        {
#endif
          cout << "export " << it->first << "='" << CONVERT_ENV(v) << "'" << endl;
#ifdef WIN32
        }
#endif
      }
    }
  }
  return 0;
}

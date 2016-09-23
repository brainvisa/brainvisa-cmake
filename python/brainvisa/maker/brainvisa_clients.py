# -*- coding: utf-8 -*-

#  This software and supporting documentation are distributed by
#      Institut Federatif de Recherche 49
#      CEA/NeuroSpin, Batiment 145,
#      91191 Gif-sur-Yvette cedex
#      France
#
# This software is governed by the CeCILL-B license under
# French law and abiding by the rules of distribution of free software.
# You can  use, modify and/or redistribute the software under the 
# terms of the CeCILL-B license as circulated by CEA, CNRS
# and INRIA at the following URL "http://www.cecill.info". 
#
# As a counterpart to the access to the source code and  rights to copy,
# modify and redistribute granted by the license, users are provided only
# with a limited warranty  and the software's author,  the holder of the
# economic rights,  and the successive licensors  have only  limited
# liability.
#
# In this respect, the user's attention is drawn to the risks associated
# with loading,  using,  modifying and/or developing or reproducing the
# software by the user in light of its specific status of free software,
# that may mean  that it is complicated to manipulate,  and  that  also
# therefore means  that it is reserved for developers  and  experienced
# professionals having in-depth computer knowledge. Users are therefore
# encouraged to load and test the software's suitability as regards their
# requirements in conditions enabling the security of their systems and/or 
# data to be ensured and,  more generally, to use and operate it in the 
# same conditions as regards security.
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL-B license and that you accept its terms.
from __future__ import print_function
import sys
import posixpath
from subprocess                         import Popen, PIPE, STDOUT
try:
    from urlparse                           import urlparse, urlunparse
except ImportError:
    from urllib import parse as urlparse

from brainvisa.maker.version_number     import VersionNumber, \
                                               VersionFormat, \
                                               version_format_unconstrained

def system( command,
            simulate = False,
            verbose = False ):
    """Execute a system command.
        If the code returned by the executed command is not 0, 
        a SystemError is raised.
    
    @type command: list
    @param command: The list that contains a command and its parameters.
    
    @type verbose: bool
    @param verbose: Specify that the command must be printed to standard output.
                    [Default: False].
                    
    @type simulate: bool
    @param simulate: Specify that the command must not be executed
                    [Default: False].
    
    @rtype: string
    @return: The standard output of the command.
    """
  
    if verbose:
        print(' '.join( ('"' + i + '"' for i in command) ))
      
    if simulate :
        return command
        
    else :
        cmd = Popen( command,
                     stdout = PIPE,
                     stderr = STDOUT )
        output = cmd.stdout.read()
        cmd.wait()
        if cmd.returncode != 0:
            if verbose:
                print(output)
                sys.stdout.flush()
            raise SystemError( 'System command exited with error code '
                                + repr( cmd.returncode ) + ': ' 
                                + ' '.join( ('"' + i + '"' for i in command) ) )
    
        return output
  
def normurl( url ):
    """Normalizes URL in order that URLs that point 
        to the same resource will return the same string.
    
    @type url: string
    @param url: The URL to normalize
    
    @return: A normalized URL, i.e. without '..' or '.' elements.
    """

    parsed = urlparse(url)
    return urlunparse(
                ( parsed.scheme,
                  parsed.netloc,
                  posixpath.normpath(parsed.path),
                  parsed.params,
                  parsed.query,
                  parsed.fragment ) )
  
def find_remote_project_info( client,
                              url ):
    """Find a project_info.cmake or the info.py file
        in subdirectories of the specified url.
        Files are searched using the patterns :
        1) <url>/project_info.cmake
        2) <url>/python/*/info.py
        3) <url>/*/info.py
    
    @type client: Client
    @param client: The Client instance to get access to files.
    
    @type url: string
    @param url: The url to search project_info.cmake or info.py
    
    @rtype: string
    @return: The url of the found file containing project information
    """
    project_info_cmake_url = posixpath.join( url,
                                            'project_info.cmake' )
    project_info_python_url_pattern = posixpath.join( url,
                                                        'python',
                                                        '*',
                                                        'info.py' )
    project_info_python_fallback_url_pattern = posixpath.join( url,
                                                                '*',
                                                             'info.py' )
  
    # Searches for project_info.cmake and info.py file
    for pattern in ( project_info_cmake_url,
                    project_info_python_url_pattern,
                    project_info_python_fallback_url_pattern ):
            project_info_python_url = client.glob( pattern )
            
            if project_info_python_url:
                return project_info_python_url[0]
  
    return None
  
def read_remote_project_info( client,
                              url,
                              version_format = version_format_unconstrained ):
    """Search a project_info.cmake or a info.py file
        in subdirectories of the specified url and parses its content.
        Files are searched using the patterns :
        1) <url>/project_info.cmake
        2) <url>/python/*/info.py
        3) <url>/*/info.py
    
    @type client: Client
    @param client: The Client instance to get access to files.
    
    @type url: string
    @param url: The url to search project_info.cmake or info.py
    
    @type version_format: VersionFormat
    @param version_format: The format to use to return version.
    
    @rtype: list
    @return: a list that contains project name, component name and version
    """
    import os, tempfile
    from brainvisa.maker.brainvisa_projects import parse_project_info_cmake, \
                                                   parse_project_info_python
    project_info_url = find_remote_project_info( client, url )

    if project_info_url is not None:
    
        fd, path = tempfile.mkstemp()
        os.close(fd)
        os.unlink(path)
        project_info = None
    
        if project_info_url.endswith( '.cmake' ):
            # Read the content of project_info.cmake file
            client.export( project_info_url, path )
            project_info = parse_project_info_cmake(
                                path,
                                version_format
                           )
            os.unlink( path )
        
        elif project_info_url.endswith( '.py' ):
            # Read the content of info.py file
            client.export( project_info_url, path )
            project_info = parse_project_info_python(
                                path,
                                version_format
                           )
            os.unlink( path )
        
        else:
            raise RuntimeError( 'Url ' + project_info_url + ' has unknown '
                                + 'extension for project info file.'  )
        return project_info
    
    else:
        return None

def get_client( client_key ):
    """ Get a client instance from client plugins using a key.
    
        @type client_key: string
        @param client_key: The key associated to the plugin..
       
        @rtype: Client
        @return: an instance of the Client corresponding to the key.
    """
    import brainvisa.maker.plugins
    from brainvisa.maker.brainvisa_plugins_registry import plugins

    client_class = None
    # Try to find in clients plugins the matching key
    for c in plugins().get( 'clients', [] ):
        if c.key() == client_key:
            client_class = c
            
    if client_class is not None :
        return client_class()
        
    else:
        raise RuntimeError( '%s client key is not available.'
                            % client_key )

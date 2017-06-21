#!/usr/bin/env python
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
import os, string, re, types, urlparse, fnmatch, posixpath, lxml.objectify

from brainvisa.maker.brainvisa_clients      import system, normurl
from brainvisa.maker.brainvisa_decorators   import plugin_info
from brainvisa.maker.brainvisa_projects     import parse_project_info_cmake, \
                                                   parse_project_info_python
                                               
svn_revision_regexp = re.compile(r'<\s*logentry\s+revision\s*=\s*"(\d+)"\s*>')
def get_latest_revision(svn_url):
    """Get the latest revision done in a Subversion directory given its URL
    
    @type url: string
    @param url: The url of the Subversion directory

    @rtype: string or None
    @return: the revision number (as a string) or None if it cannot be retrieved.
    """
    
    xml = system(['svn', 'log', '--limit', '1', '--xml', svn_url])
    match = svn_revision_regexp.search(xml)
    if match:
        return match.group(1)

@plugin_info(
    groups = ( 'version_control_clients', )
)
class SvnClient(object):
  """SvnClient based upon command line.
  """
  
  def __init__( self ):
    """SvnClient constructor.
    """
    self.__glob_special_chars = '[\[\]\*\?]'
    self.__glob_regex = re.compile( self.__glob_special_chars )
  
  @classmethod
  def key( cls ):
    return 'svn'
  
  def cat( self,
           url,
           simulate = False,
           verbose = False ):
    """Get text content of the specified url.
    
    @type url: string
    @param url: The url to check
    
    @rtype: string
    @return: The content of the specified url
    """
    try:
      cmd = [ 'svn', 'cat', url ]
      
      return system( cmd, 
                     simulate = simulate,
                     verbose = verbose )
      
    except SystemError, e:
      raise RuntimeError( 'SVN error: Unable to cat from ' + url )

  def checkout( self,
                url,
                path,
                depth = None,
                ignore_externals = False,
                simulate = False,
                verbose = False ):
    """Checkout the content of the specified url to a path.
    
    @type url: string
    @param url: The url of the directory to check out
    
    @type path: string
    @param path: The destination path
    
    @type depth: string
    @param depth: Optional depth to limit checkout. 
                  Valid values are empty/files/immediates/infinity.
                  [Default: None].
    
    @type depth: bool
    @param depth: Specify that externals svn references must be ignored. 
                  [Default: False].
                  
    @rtype: string
    @return: The standard output of the 'svn checkout' command
    """
    try:
      
      cmd = [ 'svn', 'checkout', url, path ]
      
      if depth is not None:
        if depth not in ( 'empty',
                          'files',
                          'immediates',
                          'infinity' ):
          raise RuntimeError( 'SVN error: Depth ' + depth
                            + ' is not a valid value for checkout' )
        
        cmd += [ '--depth', depth ]
      
      if ignore_externals:
          cmd += [ '--ignore-externals' ]
      
      return system( cmd,
                     simulate = simulate,
                     verbose = verbose )
      
    except SystemError, e:
      raise RuntimeError( 'SVN error: Unable to export from '
                        + url + ' to ' + path )

  def commit( self,
              path,
              message = '',
              simulate = False,
              verbose = False ):
    """Commit the changes of the specified local path
       to the repository.
    
    @type path: string
    @param path: The path to commit
    
    @type message: string
    @param message: The message to commit

    @rtype: string
    @return: The standard output of the 'svn commit' command
    """
    try:
      cmd = [ 'svn', 'commit', path, '-m', message ]
      
      return system( cmd,
                     simulate = simulate,
                     verbose = verbose )
      
    except SystemError, e:
      raise RuntimeError( 'SVN error: Unable to commit changes from ' + path )

  def copy( self,
            source,
            dest,
            parents = False,
            message = '',
            simulate = False,
            verbose = False ):
    """Copy the source url to the destination url keeping the history.
    
    @type source: string
    @param source: The source url to copy from
    
    @type dest: string
    @param dest: The destination url to copy to
    
    @type parents: bool
    @param parents: Specify that intermediates directory should be created
                    if they do not exists [Default: False]
    
    @type message: string
    @param message: The message to log changes in history

    @rtype: string
    @return: The standard output of the 'svn copy' command
    """
    cmd = [ 'svn', 'copy', source, dest, '-m', message ]
    if parents:
      cmd.append( '--parents' )
    
    #print 'SvnClient.copy:', cmd
    #print 'SvnClient.simulate:', simulate
    #print 'SvnClient.verbose:', verbose
    return system( cmd,
                   simulate = simulate,
                   verbose = verbose )
    
  def exists( self,
              url ):
    """Check that the url exists
    
    @type url: string
    @param url: The url to check
    
    @rtype: bool
    @return: True if the url exists, False otherwise
    """
    try:
      self.info( url )
      return True
      
    except RuntimeError, e:
      return False
    
  def export( self,
              url,
              path,
              simulate = False,
              verbose = False ):
    """Export the content of the specified url to a path.
    
    @type url: string
    @param url: The url to check out
    
    @type path: string
    @param path: The destination path
    
    @rtype: string
    @return: The standard output of the 'svn export' command
    """
    try:
      
      cmd = [ 'svn', 'export', url, path ]
      
      return system( cmd,
                     simulate = simulate,
                     verbose = verbose )
      
    except SystemError, e:
      raise RuntimeError( 'SVN error: Unable to export from '
                        + url + ' to ' + path )

  def info( self,
            url,
            xml = True,
            simulate = False,
            verbose = False ):
    """Retrieve information for the url
    
    @type url: string
    @param url: The url to get info for
    
    @type xml: bool
    @param xml: specify that the command must return xml message.
                [Default: True].
    
    @rtype: string
    @return: The standard output of the 'svn info' command
    """
    try:
      cmd = [ 'svn', 'info', url ]
      
      if xml:
        cmd.append( '--xml' )
        
      return system( cmd,
                     simulate = simulate,
                     verbose = verbose )
      
    except SystemError, e:
      raise RuntimeError( 'SVN error: Unable to get info for ' + url )
    
  def list( self,
            url,
            xml = True,
            simulate = False,
            verbose = False ):
    """List content of a specified url if it is a directory
    
    @type url: string
    @param url: The url to get list from
    
    @type xml: bool
    @param xml: specify that the command must return xml message.
                [Default: True].
    
    @rtype: string
    @return: The standard output of the 'svn list' command
    """
    try:
      cmd = [ 'svn', 'list', url ]
      
      if xml:
        cmd.append( '--xml' )
        
      return system( cmd,
                     simulate = simulate,
                     verbose = verbose )
      
    except SystemError, e:
      raise RuntimeError( 'SVN error: Unable to list content of ' + url )
    
  def merge( self,
             source,
             dest,
             revision_range = None,
             accept = None,
             record_only = False,
             simulate = False,
             verbose = False ):
    """List content of a specified url if it is a directory
    
    @type source: string
    @param source: The source to merge history from
    
    @type dest: string
    @param dest: The destination to merge history to
    
    @type revision_range: tuple
    @param revision_range: specify the revision range to merge. When value is
                           None, revision range is set to 0:HEAD.
                           [Default = None]
    
    @type accept: string
    @param accept: specify the revision range to merge. [Default = None]
    
    @rtype: string
    @return: The standard output of the 'svn list' command
    """
    try:
      cmd = [ 'svn', 'merge', source, dest ]
      
      if revision_range is not None:
        if len(revision_range) != 2:
          raise RuntimeError( 'SVN error: Revision range list must contains 2 '
                            + 'revisions, not ' + len(revision_range) )
      else:
        revision_range = ( 0, 'HEAD' )
        
      cmd += [ '-r', string.join(
                        [ str(r) for r in revision_range ],
                        ':'
                     ) ]
        
      if accept is not None:
        accept_values = ( 'postpone',
                          'base',
                          'mine-conflict',
                          'theirs-conflict',
                          'mine-full',
                          'theirs-full',
                          'edit',
                          'launch' )
                           
        if accept not in accept_values:
          raise RuntimeError( 'SVN error: Action for automatic conflict '
                            + 'resolution of merge command is not valid.'
                            + 'It must be one of the following:'
                            + string.join( accept_values,
                                           os.linesep + '- ' ) )
        cmd += [ '--accept', accept ]
      
      if record_only:
        cmd.append( '--record-only' )
        
      return system( cmd,
                     simulate = simulate,
                     verbose = verbose )
      
    except SystemError, e:
      raise RuntimeError( 'SVN error: Unable to merge ' + source
                        + ' and ' + dest )
    
  
  def mkdir( self,
             url,
             parents = False,
             simulate = False,
             verbose = False ):
    """Make a svn directory at the specified url.
    
    @type url: string
    @param url: The url of the directory to create
    
    @type parents: bool
    @param parents: Specify that intermediates directory should be created
                    if they do not exists [Default: False]
                    
    @rtype: string
    @return: The standard output of the 'svn mkdir' command
    """
    try:
      cmd = [ 'svn', 'mkdir', url ]
      if parents:
        cmd.append( '--parents' )
      
      return system( cmd,
                     simulate = simulate,
                     verbose = verbose )
      
    except SystemError, e:
      raise RuntimeError( 'SVN error: Unable to mkdir at ' + url )

  def move( self,
            source,
            dest,
            parents = False,
            message = '',
            simulate = False,
            verbose = False ):
    """Move the source url to the destination url keeping the history.
    
    @type source: string
    @param source: The source url to move from
    
    @type dest: string
    @param dest: The destination url to move to
    
    @type parents: bool
    @param parents: Specify that intermediates directory should be created
                    if they do not exists [Default: False]
    
    @type message: string
    @param message: The message to log changes in history

    @rtype: string
    @return: The standard output of the 'svn move' command
    """
    cmd = [ 'svn', 'move', source, dest, '-m', message ]
    if parents:
      cmd.append( '--parents' )

    return system( cmd,
                   simulate = simulate,
                   verbose = verbose )
    
  def propset( self,
               path,
               name,
               value,
               simulate = False,
               verbose = False  ):
    """ Set a property value of a file or directory
    
        @type path: string
        @param path: The path of the file or directory to set property for.

        @type name: string
        @param name: The name of the property to set.

        @type value: string
        @param value: The value of the property to set.
        
        @rtype: string
        @return: The standard output of the 'svn propset' command
    """
    try:
      cmd = [ 'svn', 'propset', name, value, path ]
        
      return system( cmd,
                     simulate = simulate,
                     verbose = verbose )
                     
    except SystemError, e:
      raise RuntimeError( 'SVN error: Unable to set property ' + name
                        + ' value: ' + value + ' for path: ' + path )

  def propget( self,
               path,
               name,
               verbose = False  ):
    """ Get a property value of a file or directory
    
        @type path: string
        @param path: The path of the file or directory to get property for.

        @type name: string
        @param name: The name of the property to get.
        
        @rtype: string
        @return: The standard output of the 'svn propget' command
    """
    try:
      cmd = [ 'svn', 'propget', name, path ]
        
      return system( cmd,
                     verbose = verbose )
                     
    except SystemError, e:
      raise RuntimeError( 'SVN error: Unable to get property ' + name
                        + ' value for path: ' + path )
                        
  def update( self,
              path,
              simulate = False,
              verbose = False  ):
    """ Update a working copy file or directory
    
        @type path: string
        @param path: The path of the file or directory to update.
        
        @rtype: string
        @return: The standard output of the 'svn update' command
    """
    try:
      cmd = [ 'svn', 'up', path ]
        
      return system( cmd,
                     simulate = simulate,
                     verbose = verbose )
                     
    except SystemError, e:
      raise RuntimeError( 'SVN error: Unable to update ' + path )
    
  def glob( self,
            *urlpatterns ):
    """ Process a search of matching svn entries using url patterns.
    
        @type urlpatterns: list of string
        @param urlpatterns: The list of url pattern to search entries for
        
        @rtype: list of string
        @return: The list of matching urls
    """
    # Create list to store matches
    url_matches = list()
    url_checked = set() # Contains url that have been checked for existance
                        # Used for optimization purpose
    
    #if type(urlpatterns) not in ( types.ListType, types.TupleType ):
      #urlpatterns = ( str(urlpatterns), )
    
    for url_pattern in urlpatterns:
      # Split url pattern
      url_pattern_splitted = urlparse.urlsplit( normurl( url_pattern ) )
      
      # Create stack to solve pattern
      url_path_pattern_stack = list()
      url_path_pattern_stack.append(
                                tuple(
                                  string.split(
                                    url_pattern_splitted.path,
                                    posixpath.sep ) ) )
      
      while( len(url_path_pattern_stack) ):
        url_path_pattern_splitted = url_path_pattern_stack.pop()

        for i in xrange(len(url_path_pattern_splitted)):
          # Find first path component that contains special characters
          if ( len(self.__glob_regex.findall(
                                  url_path_pattern_splitted[i])) > 0 ):
            # Search matching entries from server
            url = urlparse.urlunsplit(
                        url_pattern_splitted[ 0:2 ]
                        + ( string.join( url_path_pattern_splitted[ 0:i ],
                                         posixpath.sep ), )
                        + url_pattern_splitted[ 3: ]
                  )
                  
            # Check that url exists
            url_exists = False
            if ( url not in url_checked ) :
              if self.exists( url ):
                url_exists = url_checked.add( url )
                url_exists = True
            
            # If the url does not exists, it is not possible to find
            # matching subdirectories
            if not url_exists:
                continue

            # Check that url is a directory
            # to avoid listings
            url_info = self.info( url, xml = True )
            
            # Parses xml result
            l = lxml.objectify.fromstring( url_info )
            
            if l.xpath( 'entry/@kind' )[ 0 ] != 'dir' :
                continue
            
            url_list = self.list( url, xml = True )
          
            # Parses xml result
            l = lxml.objectify.fromstring( url_list )
          
            # Get found entries
            for e in l.xpath( '*/entry' ):
              #print 'Entry', url_path_pattern_splitted[ 0:i ] \
                          #+ ( str(e.name), ) \
                          #+ url_path_pattern_splitted[ i + 1: ],
              if fnmatch.fnmatch( str(e.name), url_path_pattern_splitted[i]):
                # Stacking the found entry matching pattern
                url_path_pattern_stack.append(
                                        url_path_pattern_splitted[ 0:i ]
                                      + ( str(e.name), )
                                      + url_path_pattern_splitted[ i + 1: ] )
                url_checked.add(
                  urlparse.urlunsplit( 
                    url_pattern_splitted[ 0:2 ]
                    + ( string.join( url_path_pattern_splitted[ 0:i ]
                                   + ( str(e.name), ),
                                      posixpath.sep ), )
                    + url_pattern_splitted[ 3: ] ) )
                #print 'matches'
                  
              #else:
                #print 'not matches'
            break
            
          elif( i == (len(url_path_pattern_splitted) - 1) ):
            url = urlparse.urlunsplit(
                        url_pattern_splitted[ 0:2 ]
                        + ( string.join( url_path_pattern_splitted, 
                                         posixpath.sep ), )
                        + url_pattern_splitted[ 3: ]
                  )

            if ( url not in url_checked ) :
              # Check that the element exists
              if self.exists( url ):
                url_matches.append( url )
                url_checked.add( url )
                
            else:
              url_matches.append( url )
          
    return url_matches

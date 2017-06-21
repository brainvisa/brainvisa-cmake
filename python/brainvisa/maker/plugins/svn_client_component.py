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
import os, posixpath, re, string, tempfile, urlparse
from brainvisa.maker.brainvisa_client_components import BranchType, \
                                                        VersionControlComponent
from brainvisa.maker.brainvisa_decorators        import plugin_info
                                                        
@plugin_info(
    groups = ( 'version_control_components', )
)
class SvnComponent( VersionControlComponent ):

    KEY                     = 'svn'
    
    TRUNK_DIR               = 'trunk'
    BUG_FIX_DIR             = 'branches'
    RELEASES_DIR            = 'tags'
    VIEWS_DIR               = 'views'
    
    LATEST_RELEASE_ALIAS    = 'latest_release'
    LATEST_BUG_FIX_ALIAS    = 'bug_fix'
    
    def __init__( self,
                  project,
                  name,
                  path,
                  url,
                  params = None ):
        """ SvnComponent constructor.
            Be aware that SvnComponent uses a version cache to avoid svn 
            overhead accesses. This cache
        
            @type project: string
            @param project: The project name of the component
            
            @type name: string
            @param name: The name of the component
            
            @type path: string
            @param path: The relative path of the component
            
            @type url: string
            @param url: The client url to build the component

            @type params: string
            @param params: The versioning client parameters to use
        """
        super( SvnComponent, self ).__init__( project,
                                              name,
                                              path,
                                              url,
                                              params )
        
        parsed_url = urlparse.urlparse( self.url() )
        
        # Find tags, branches, trunk in url to get a base url
        client_url_branch_type, client_url_base_path = self.branch_path_parse(
                                                            parsed_url.path
                                                       )
              
        client_local_branch_type, client_local_base_path = \
                                                       self.branch_path_parse(
                                                            self.path()
                                                       )
        
        if not client_url_branch_type :
            raise RuntimeError( 'Url ' + self.url() + ' has not a valid '
                              + 'subversion structure for BrainVISA '
                              + 'components. It must contain a directory '
                              + 'among : trunk, branches, tags)' )
                                
        #if client_url_branch_type != client_local_branch_type:
            #raise RuntimeWarning( 'Url ' + self.url() + ' refers to a branch '
                                #+ 'type ' + client_url_branch_type + ' whereas '
                                #+ 'the local directory ' + self.path()
                                #+ ' refers to a different branch type '
                                #+ client_local_branch_type )
        
        self._url_branch_type = client_url_branch_type
        self._url_base = urlparse.urlunparse( parsed_url[ 0:2 ]
                                            + ( client_url_base_path, )
                                            + parsed_url[ 3: ] )
                                            
        self._local_base = client_local_base_path
                                            
        # This is used to do local temporary operations
        # and to not retrieve files multiple times
        self._local_branches = dict()
        
        # This is used to cache versions
        self._branch_versions = dict()

    @classmethod
    def branch_path_parse( cls,
                           path,
                           sep = posixpath.sep ):
        """ Class method to parse a path and get the associated
            branch type and branch base path. The type can normally
            be infered from the given path. i.e. a path that contains a
            trunk directory is normally associated to a trunk version, etc.
        
            @type path: string
            @param path: The path to parse and find branch type and base path
                         from.
        
            @type sep: string
            @param sep: The path separator used to split the path.
                         
            @rtype: tuple
            @return: A tuple that contains the branch type and the base path
                     (i.e. the path without the branch type and directories
                           after)
        """
        
        # Find tags, branches, trunk in url to get a base url
        base_path = list()
        branch_type = None
        for d in string.split(path, sep):
            if d in ( SvnComponent.TRUNK_DIR,
                      SvnComponent.BUG_FIX_DIR,
                      SvnComponent.RELEASES_DIR,
                      SvnComponent.VIEWS_DIR ):
                branch_type = d
                break
                
            else:
                base_path.append(d)
                
        return ( branch_type,
                 posixpath.join( *base_path ), )
                 
    @classmethod
    def client_type( cls ) :
        """ Class method to get the Client class associated to the current
            VersionControlComponent class
        
            @rtype: Client
            @return: The Client class associated to the current
                     VersionControlComponent class
        """
        from brainvisa.maker.plugins.svn import SvnClient
        
        return SvnClient

    def __str__( self ) :
        """ SvnComponent string conversion
        
            @rtype: string
            @return: The string to display for the instance of SvnComponent
        """
        return string.join(
                    [ 'component: ' + self.project() + ':' + self.name(),
                      '- client_type: ' + self.client_type().__name__,
                      '- url: ' +  self.url(),
                      '- params: ' + str(self.params()),
                      '- url_branch_type: ' + self._url_branch_type,
                      '- url_base: ' + self._url_base ],
                    os.linesep )
        
    def branch_url( self,
                    branch_type = BranchType.TRUNK,
                    branch_name = None ):
        """ Get the svn url for a BranchType and a name
        
            @type: string
            @param branch_type: The svn BranchType to get url for
        
            @type: string
            @param branch_name: The name of the branch to get url for
            
            @rtype: string
            @return: The svn url of the branch for the specified name
        """
        if ( branch_type == BranchType.TRUNK ) :
            dirname = SvnComponent.TRUNK_DIR
        
        elif ( branch_type == BranchType.BUG_FIX ) :
            dirname = SvnComponent.BUG_FIX_DIR
        
        elif ( branch_type == BranchType.RELEASE ) :
            dirname = SvnComponent.RELEASES_DIR
        
        if (branch_name is None) or (branch_type == BranchType.TRUNK) :
            return posixpath.join( self._url_base,
                                   dirname )
        else:
            return posixpath.join( self._url_base,
                                   dirname,
                                   branch_name )
        
    def branch_path( self,
                      branch_type = BranchType.TRUNK,
                      branch_name = None ):
        """ Get the svn local path for a BranchType and a name
        
            @type: string
            @param branch_type: The svn BranchType to get local path for
        
            @type: string
            @param branch_name: The name of the branch to get local path for
            
            @rtype: string
            @return: The svn local path of the branch for the specified name.
        """
        if ( branch_type == BranchType.TRUNK ) :
            dirname = SvnComponent.TRUNK_DIR
        
        elif ( branch_type == BranchType.BUG_FIX ) :
            dirname = SvnComponent.BUG_FIX_DIR
        
        elif ( branch_type == BranchType.RELEASE ) :
            dirname = SvnComponent.RELEASES_DIR
        
        if (branch_name is None) or (branch_type == BranchType.TRUNK) :
            return os.path.join( self._local_base,
                                 dirname )
        else:
            return os.path.join( self._local_base,
                                 dirname,
                                 branch_name )
                 
    def branch_list( self,
                     branch_type = BranchType.TRUNK,
                     patterns = [ '*' ] ) :
        """ Lists branch children that matches one of the given patterns.
        
            @type: string
            @param branch_type: The svn BranchType to get children for.
            
            @type: string
            @param patterns: The list of patterns to match
                                     [Default: *].
            
            @rtype: list
            @return: A list that contains matching branch entries.
        """
        import fnmatch, lxml.objectify, types

        if not isinstance(patterns, (types.ListType, types.TupleType)):
            patterns = ( str( patterns ), )
        
        entries = list()
        branch_url = self.branch_url( branch_type )
        
        # Parses xml result
        l = lxml.objectify.fromstring(
                self.client().list( branch_url )
            )
        
        for e in l.xpath( '*/entry' ):
            for p in patterns:
                if fnmatch.fnmatch( str(e.name), p ):
                    if e.xpath( '@kind' )[ 0 ] == 'dir':
                        t = 'dir'
                    else:
                        t = 'file'
                        
                    entries.append( ( t, str(e.name) ) )
                    break
                
        return entries
        
    def branch_versions( self,
                         branch_type = BranchType.TRUNK,
                         version_patterns = [ '*' ] ) :
        """ Returns a dictionary of branch versions for a BranchType and a list
            of version patterns. To build this version dictionary, version
            are processed from branch name when it is possible, otherwise the
            project info file of the branch is parsed. When the version matches
            one of the version patterns, it is added to the result dictionary.
        
            @type: string
            @param branch_type: The svn BranchType to get versions for.
            
            @type: string
            @param version_patterns: The list of version patterns to match
                                     [Default: *].
            
            @rtype: dict
            @return: A dictionary that contains matching versions as keys
                     and their associated branch name
        """
        import fnmatch, lxml.objectify, types
        
        from brainvisa.maker.version_number import VersionNumber
        
        if type(version_patterns) not in (types.ListType, types.TupleType):
            version_patterns = ( str( version_patterns ), )
        
        versions = dict()
        if ( branch_type == BranchType.TRUNK ) :
            v = self.branch_version( branch_type )
            versions[ VersionNumber( v, format = self._version_format ) ] = None
        
        else :
            branch_url = self.branch_url( branch_type )
            # Parses xml result
            l = lxml.objectify.fromstring(
                    self.client().list( branch_url )
                )
            
            for e in l.xpath( '*/entry' ):
                if e.xpath( '@kind' )[ 0 ] == 'dir' :
                    # Read the version for the branch
                    v = self.branch_version(
                            branch_type,
                            str(e.name)
                        )
                              
                    for p in version_patterns:
                        if fnmatch.fnmatch( str(v), p ):
                            versions[ v ] = str(e.name)
                            break
                
        return versions
    
    def branch_version( self,
                        branch_type = BranchType.TRUNK,
                        branch_name = None ):
        """ Get the version for a BranchType and a name.
            
            @type branch_type: string
            @param branch_type: The BranchType to get version list for.
                                [Default: BranchType.TRUNK ]
            
            @type branch_name: string
            @param branch_name: The name of branch to get version for
                                [Default: None ].

            @rtype: string
            @return: The version for the branch if was possible to get it,
                     None otherwise.
        """
        from brainvisa.maker.version_number import VersionNumber
        
        branch_version_key = ( branch_type, branch_name )
        if self._branch_versions.get( branch_version_key ) is None :
            if ( branch_type == BranchType.TRUNK ) \
                or ( branch_type == BranchType.BUG_FIX ) \
                or ( branch_type == BranchType.RELEASE \
                    and branch_name == self.LATEST_RELEASE_ALIAS ):
                # Read version from project info file
                p, c, v = self.branch_project_info(
                            branch_type,
                            branch_name
                        )
                
                branch_version = VersionNumber(
                                    v,
                                    format = self._version_format
                                )
            
            else:
                # Uses the branch name as the version. Be aware that, in this case
                branch_version = VersionNumber(
                                    branch_name,
                                    format = self._version_format
                                )
                                
            # Insert version in cache
            self._branch_versions[ branch_version_key ] = branch_version
            
            return branch_version
            
        else :
            return self._branch_versions[ branch_version_key ]
            
    def branch_name( self,
                     branch_type = BranchType.TRUNK,
                     version = None,
                     use_alias = True ):
        """ Get the name of a branch for a BranchType and a version.
            For BranchType.TRUNK the name returned is always None,
            for BranchType.BUG_FIX the name returned is the bug_fix version or
            'bug_fix' if the version is >= to the latest bug_fix version and
            use_alias is set to True, for BranchType.RELEASE the name returned
            is the release version or 'latest_release' if the version is >= to 
            the latest release version and use_alias is set to True.
            
            @type branch_type: string
            @param branch_type: The BranchType to get branch name for.
                                [Default: BranchType.TRUNK ]
            
            @type version: string
            @param version: The version of the branch to get name for
                            [Default: None ].
            
            @type use_alias: bool
            @param use_alias: Specify that the branch alias must be used
                              when needed
                              [Default: True ].
                            
            @rtype: string
            @return: The name of the branch if it was possible to get it,
                     None otherwise.
        """
        from brainvisa.maker.version_number import VersionNumber
        
        if ( branch_type == BranchType.TRUNK ):
            return None
            
        else:
            version = VersionNumber( version, format = self._version_format )
            
            if ( branch_type == BranchType.BUG_FIX ):
                # bug_fix branches are named using 2 digits
                name = str(version[:2])
            else:
                # release branches are named using 3 digits
                name = str(version[:3])

            if use_alias:
                # When a branch named using the given version already exists
                # we do not use the alias
                if not self.client().exists(
                    self.branch_url(
                            branch_type,
                            name
                    )
                ):
                    branch_version_max, branch_name_max = self.branch_version_max(
                                                            branch_type
                                                        )
                                                        
                    if version >= branch_version_max:
                        # The given version is the latest for the branch
                        if ( branch_type == BranchType.BUG_FIX ):
                            return self.LATEST_BUG_FIX_ALIAS
                        else:
                            return self.LATEST_RELEASE_ALIAS
                    
            # Uses the version as the branch name
            return name
            
    def branch_project_info( self,
                             branch_type = BranchType.TRUNK,
                             branch_name = None ) :
        """ Reads project info file for a BranchType and a version.
        
            @type: string
            @param branch_type: The svn BranchType to get the project info for
                                [Default: BranchType.TRUNK].
            
            @type: string
            @param branch_name: The name of the branch to get project info for
                                [Default: None].
            
            @rtype: tuple
            @return: A tuple containing project name, component name and version
                     read from the project info file.
        """
        from brainvisa.maker.brainvisa_clients import read_remote_project_info
        
        info = read_remote_project_info(
                    self.client(),
                    self.branch_url( branch_type,
                                     branch_name ),
                    version_format = self._version_format
               )
               
        if info is None:
            return (self.project(), self.name(), None)
            
        else:
            return (self.project(), self.name(), info[2])
    
    def branch_exists( self,
                       branch_type = BranchType.TRUNK,
                       branch_name = None ):
        """ Checks that a BranchType version exists.
        
            @type: string
            @param branch_type: The svn BranchType to check
                                [Default: BranchType.TRUNK].
            
            @type: string
            @param branch_name: The name of the branch to check
                                [Default: None].
            
            @rtype: bool
            @return: True if the branch exists for the specified name,
                     False otherwise.
        """
        return self.client().exists(
                    self.branch_url( branch_type,
                                     branch_name ) )
    
    def branch_create( self,
                       src_branch_type = BranchType.TRUNK,
                       src_branch_name = None,
                       dest_branch_type = BranchType.BUG_FIX,
                       dest_branch_name = None,
                       message = '',
                       simulate = False,
                       verbose = False ):
        """ Creates a new branch from a source branch.
        
            @type: string
            @param src_branch_type: The source BranchType to create from
                                    [Default: BranchType.TRUNK].
            
            @type: string
            @param src_branch_name: The name of the source branch to create from
                                    [Default: None].
            @type: string
            @param dest_branch_type: The destination BranchType to create
                                     [Default: BranchType.BUG_FIX].
            
            @type: string
            @param dest_branch_name: The name of the destination branch to
                                     create
                                     [Default: None].
                                
            @type: string
            @param message: The message to log to create the branch
                            [Default: ''].
        """
        src_branch_url = self.branch_url( src_branch_type,
                                          src_branch_name )
        dest_branch_url = self.branch_url( dest_branch_type,
                                           dest_branch_name )
                                           
        if ( ( dest_branch_type == BranchType.BUG_FIX ) \
               and ( dest_branch_name == self.LATEST_BUG_FIX_ALIAS ) ) \
           or \
           ( ( dest_branch_type == BranchType.RELEASE ) \
               and ( dest_branch_name == self.LATEST_RELEASE_ALIAS ) ):
            if self.client().exists( dest_branch_url ):
                # It is necessary to first move the latest branch to its version
                # branch
                dest_version = self.branch_version(
                                   dest_branch_type,
                                   dest_branch_name
                               )
                
                # Get the branch_name without aliases to rename:
                # bug_fix => X.Y
                # latest_release => X.Y.Z
                dest_version_branch_name = self.branch_name(
                                                dest_branch_type,
                                                dest_version,
                                                use_alias = False
                                           )
                dest_version_branch_url = self.branch_url(
                                              dest_branch_type,
                                              dest_version_branch_name
                                          )
                self.client().move(
                    dest_branch_url,
                    dest_version_branch_url,
                    parents = True,
                    message = message,
                    simulate = simulate,
                    verbose = verbose
                )
                
                # Update version in cache
                self._branch_versions[
                    ( dest_branch_type,
                      dest_version_branch_name )
                ] = dest_version
        
        self.client().copy(
            src_branch_url,
            dest_branch_url,
            parents = True,
            message = message,
            simulate = simulate,
            verbose = verbose
        )
        
    def branch_local_temporary( self,
                                branch_type = BranchType.TRUNK,
                                branch_name = None,
                                dir = None ):
        """ Get a local temporary directory associated to the client
            component branch name.
        
            @type: string
            @param branch_type: The BranchType to get local temporary directory
                                for
                                [Default: BranchType.TRUNK].
            
            @type: string
            @param branch_name: The name to get local temporary directory for
                                [Default: None].
            
            @rtype: string
            @return: local temporary directory associated to the client
                     component branch version.
        """
        if (branch_type, branch_name) not in self._local_branches:
            self._local_branches[ (branch_type, branch_name) ] = \
                tempfile.mkdtemp( prefix = string.join( ( self.project(),
                                                          self.name() ),
                                                          '_' ),
                                  dir = dir
                )

        return self._local_branches[ (branch_type, branch_name) ]
    
    def branch_update_version_info( self,
                                    branch_type = BranchType.TRUNK,
                                    branch_name = None,
                                    version = None,
                                    message = '',
                                    simulate = False,
                                    verbose = False ):
        """ Update the project info file for component branch version.
        
            @type: string
            @param branch_type: The BranchType to update project info file for
                                [Default: BranchType.TRUNK].
            
            @type: string
            @param branch_name: The name of the branch to update project info
                                file for
                                [Default: None].
            
            @type: string
            @param version: The version to set in the project info file
                            [Default: None].
                                
            @type: string
            @param message: The message used to log the version info update in
                            svn. [Default: ''].
                            
            @rtype: bool
            @return: True if the project info version was updated, False 
                     otherwise.
        """
        import os, posixpath
        
        from brainvisa.maker.version_number import VersionNumber
        from brainvisa.maker.brainvisa_clients import find_remote_project_info
        
        version = VersionNumber(
                      version,
                      format = self._version_format
                  )
        
        # Checkout the branch files to a local directory
        branch_local = self.branch_local_temporary( branch_type,
                                                    branch_name )
        branch_url = self.branch_url( branch_type,
                                      branch_name )
                                    
        project_info_url = find_remote_project_info(
            self.client(),
            branch_url
        )
        
        if project_info_url is None:
            return False
            
        project_info_url_rel = project_info_url[ len(branch_url) + 1: ]
        
        project_info_url_dir = posixpath.dirname(
                                   project_info_url
                               )
        
        project_info_local_dir = os.path.dirname(
                                    os.path.join(
                                        branch_local,
                                        project_info_url_rel
                                    )
                                 )
                                
        self.client().checkout(
            project_info_url_dir,
            project_info_local_dir,
            depth = 'files',
            verbose = verbose
        )
        
        project_info_path = os.path.join( branch_local,
                                          project_info_url_rel )
        if not os.path.exists( project_info_path ):
            return False
        
        project_info_content = open( project_info_path ).read()
        
        # Set version in project info file
        # It needs to have a version with at least 3
        # numbers
        if len(version) < 3:
            version.resize(3)
        
        if project_info_path.endswith( '.cmake' ):
            pattern = re.compile(
                'BRAINVISA_PACKAGE_VERSION_MAJOR.+'
              + 'BRAINVISA_PACKAGE_VERSION_PATCH \d+',
                re.DOTALL
            )
            
            project_info_content_new = pattern.sub(
                'BRAINVISA_PACKAGE_VERSION_MAJOR '
              + str(version[0]) + ' )\n'
              + 'set( BRAINVISA_PACKAGE_VERSION_MINOR '
              + str(version[1]) + ' )\n'
              + 'set( BRAINVISA_PACKAGE_VERSION_PATCH '
              + str(version[2]),
                project_info_content
            )
                                      
        elif project_info_path.endswith( '.py' ):
            pattern = re.compile(
                'version_major.+\nversion_micro\s*=\s*\d+',
                re.DOTALL
            )
      
            project_info_content_new = pattern.sub(
                'version_major = ' + str(version[0]) + '\n'
              + 'version_minor = ' + str(version[1]) + '\n'
              + 'version_micro = ' + str(version[2]),
                project_info_content
            )
    
        if project_info_content != project_info_content_new:
            # Write new project info content to file
            # and commit local changes to the branch
            f = open( project_info_path, "w" )
            f.write( project_info_content_new )
            f.close()
            
            self.client().commit(
                project_info_path,
                message = message,
                simulate = simulate,
                verbose = verbose
            )

            self.client().update(
                project_info_local_dir,
                verbose = verbose
            )
            
        else:
            return False

        # Update version in cache
        self._branch_versions[ ( branch_type, branch_name ) ] = version
        
        return True
    
    def branch_merge_version_info( self,
                                   src_branch_type = BranchType.BUG_FIX,
                                   src_branch_name = None,
                                   dest_branch_type = BranchType.TRUNK,
                                   dest_branch_name = None,
                                   message = '',
                                   simulate = False,
                                   verbose = False ):
        """ Merge the project info file for component branch version.
        
            @type: string
            @param src_branch_type: The source BranchType to merge project info
                                    file for
                                    [Default: BranchType.TRUNK].
            
            @type: string
            @param src_branch_name: The source branch to merge project info file
                                    for
                                    [Default: None].

            
            @type: string
            @param dest_branch_type: The destination BranchType to merge project
                                     info file for
                                     [Default: BranchType.TRUNK].
            
            @type: string
            @param dest_branch_name: The destination branch to merge project
                                     info file for
                                     [Default: None].
            
            @type: string
            @param message: The message used to log the merge of version info in
                            svn.
                            [Default: ''].
                            
            @rtype: bool
            @return: True if the project info version was merged, False 
                     otherwise.
        """
        import time, os, posixpath
        from brainvisa.maker.brainvisa_clients import find_remote_project_info
        
        # Checkout the branch files to a local directory
        src_branch_local = self.branch_local_temporary( src_branch_type,
                                                        src_branch_name )
        dest_branch_local = self.branch_local_temporary( dest_branch_type,
                                                         dest_branch_name )        
        src_branch_url = self.branch_url( src_branch_type,
                                          src_branch_name )
        dest_branch_url = self.branch_url( dest_branch_type,
                                           dest_branch_name )
                                        
        src_project_info_url = find_remote_project_info(
                                   self.client(),
                                   src_branch_url
                               )
                                        
        dest_project_info_url = find_remote_project_info(
                                   self.client(),
                                   dest_branch_url
                                )
                               
        if src_project_info_url is None or dest_project_info_url is None:
            return False
            
        src_project_info_url_rel = src_project_info_url[ len(src_branch_url) + 1: ]
        dest_project_info_url_rel = dest_project_info_url[ len(dest_branch_url) + 1: ]
        
        src_project_info_url_dir = posixpath.dirname(
                                       src_project_info_url
                                   )
        
        dest_project_info_url_dir = posixpath.dirname(
                                        dest_project_info_url
                                    )
        
        src_project_info_local_dir = os.path.dirname(
                                         os.path.join(
                                             src_branch_local,
                                             src_project_info_url_rel
                                         )
                                     )
        
        dest_project_info_local_dir = os.path.dirname(
                                         os.path.join(
                                             dest_branch_local,
                                             dest_project_info_url_rel
                                         )
                                     )
                                         
        # Checkout directory of project info file
        self.client().checkout(
            src_project_info_url_dir,
            src_project_info_local_dir,
            depth = 'files',
            verbose = verbose
        )

        self.client().checkout(
            dest_project_info_url_dir,
            dest_project_info_local_dir,
            depth = 'files',
            verbose = verbose
        )
        
        time.sleep(1)
        
        self.client().merge(
            src_project_info_local_dir,
            dest_project_info_local_dir,
            accept = 'mine-full',
            record_only = True,
            verbose = verbose
        )
    
        self.client().commit(
            dest_project_info_local_dir,
            message = message,
            simulate = simulate,
            verbose = verbose
        )
        
        return True
        
    #def branch_set_alias( self,
                          #alias,
                          #branch_type,
                          #version,
                          #message = '',
                          #simulate = False,
                          #verbose = False ):
        #""" Set an alias to a component branch version. The alias is set using
            #externals in the 'views' directory of the project/component. For
            #instance : a propset is done on the 'project/component/views/alias'
            #directory that refer to the 'project/component/branch_type/version'
            #directory.
            
            #@type: string
            #@param branch_type: The BranchType to set alias for.
            
            #@type: string
            #@param version: The version to set alias for.

            #@type: string
            #@param message: The message used to log the alias set.
                            #[Default: ''].
            
            #@rtype: bool
            #@return: True if the alias was set, False otherwise.
        #"""
        #branch_url = self.branch_url( branch_type,
                                      #version )
        #branch_path = self.branch_path( branch_type,
                                        #version )
                                        
        #parsed_url = urlparse.urlparse( branch_url )
        #branch_alias_url = urlparse.urlunparse(
                                #parsed_url[ 0:2 ]
                                #+ ( posixpath.join(
                                          #parsed_url.path,
                                          #VIEWS_DIR,
                                    #), )
                                #+ parsed_url[ 3: ]
                           #)
                           
        #branch_alias_local = posixpath.join(
                                #self._local_base,
                                #VIEWS_DIR,
                                #alias
                             #)
                             
        #branch_alias_local_temporary = tempfile.mkdtemp(
                                            #prefix = string.join(
                                                        #( self.project(),
                                                          #self.name(),
                                                          #VIEWS_DIR,
                                                          #alias ),
                                                        #'_'
                                                     #),
                                       #)
        
        ## Create the alias directory in views
        #if not self.client().exists( branch_alias_url ):
            #self.client().mkdir(
                #branch_alias_url,
                #parents = True,
                #simulate = simulate,
                #verbose = verbose
            #)
            
        ## Checkout the alias directory
        #self.client().checkout(
            #branch_alias_url,
            #branch_alias_local_temporary,
            #ignore_externals = True,
            #simulate = simulate,
            #verbose = verbose
        #)
        
        ## Set externals property on the alias directory
        #self.client().propset(
            #branch_alias_local_temporary,
            #'svn:externals',
            #branch_path + ' ' + branch_url,
            #simulate = simulate,
            #verbose = verbose
        #)
        
        ## Commit externals property on the alias directory
        #self.client().commit(
            #branch_alias_local_temporary,
            #simulate = simulate,
            #verbose = verbose
        #)
        
        #return True
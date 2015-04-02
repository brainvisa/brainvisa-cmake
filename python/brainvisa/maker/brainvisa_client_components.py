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
from brainvisa.maker.brainvisa_projects         import parse_versioning_client_info
from brainvisa.maker.brainvisa_clients          import normurl

class BranchType:
    """ Branch types that can be used by clients
        TRUNK: branch used for main development and new features integration
        BUG_FIX: branch that are created to initiate a release and that can be
                bug fixed
        RELEASE: branch that is never modified and that correspond to a release
    """

    TRUNK = 'trunk'
    BUG_FIX = 'bug_fix'
    RELEASE = 'release'

def get_client_component( project,
                          name,
                          client_info  ):
    """ Return a ClientComponent using its associated client information.
    
        @type project: string
        @param project: The project name of the component
        
        @type name: string
        @param name: The name of the component
        
        @type client_info: string
        @param client_info: The versioning client information is described using
                            the format <client_type> <url> [<client_parameters>]
                            i.e: svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-gpl/branches/4.4
                              or git https://github.com/neurospin/soma-workflow.git master
    """
    import brainvisa.maker.plugins
    from brainvisa.maker.brainvisa_plugins_registry import plugins

    client_key, client_url, client_params = parse_versioning_client_info(
                                                client_info
                                            )
                    
    client_component_class = None
    # Try to find in client_components plugins the matching key
    for c in plugins().get( 'client_components', [] ):
        if c.client_type().key() == client_key:
            client_component_class = c
            
    if client_component_class is not None:
        return client_component_class( project, name,
                                       client_url, client_params )
        
    else:
        raise RuntimeError( 'Component: %s:%s uses unsupported client key %s.'
                          % ( project, name, client_key ) )
  
class ClientComponent(object):
    """ Base abstract class that is used to get component informations
        independently of its repository type (svn, ...)
    """
    def __init__( self,
                  project,
                  name,
                  url,
                  params = None ):
        """ ClientComponent constructor
        
            @type project: string
            @param project: The project name of the component
            
            @type name: string
            @param name: The name of the component
            
            @type url: string
            @param url: The client url to build the component
            
            @type params: string
            @param params: The versioning client parameters to use
        """
        super( ClientComponent, self ).__init__()
                                                
        self._project = project
        self._name = name
        self._url = normurl( url )
        self._params = params
        self._client = self.client_type()()

    def client( self ) :
        """ Returns a Client instance associated to the ClientComponent
        
            @rtype: Client
            @return: The Client instance associated to the ClientComponent
        """
        return self._client

    @classmethod
    def client_type( cls ) :
        """ Class method that returns a Client class associated to the
            ClientComponent.
            This method must be implemented by subclasses.
        
            @rtype: Client
            @return: The Client class associated to the ClientComponent
        """
        raise RuntimeError( 'ClientComponent: client_type method is not '
                          + 'implemented. It must be defined by subclasses.' )

    def url( self ) :
        """ Returns the url of the ClientComponent.
        
            @rtype: string
            @return: The url of the ClientComponent
        """
        return self._url

    def name( self ) :
        """ Returns the name of the ClientComponent.
        
            @rtype: string
            @return: The name of the ClientComponent
        """
        return self._name

    def project( self ) :
        """ Returns the project of the ClientComponent.
        
            @rtype: string
            @return: The project of the ClientComponent
        """
        return self._project

    def params( self ) :
        """ Returns the parameters used by the ClientComponent.
        
            @rtype: string
            @return: The parameters used by the ClientComponent
        """
        return self._params
        
    def branch_version_max( self,
                            branch_type = BranchType.TRUNK,
                            version_pattern = '*' ):
        """ Maximum version for a BranchType and a version pattern.
            
            @type: string
            @param branch_type: The svn BranchType to get version list for.
            
            @type: string
            @param version_pattern: The version pattern to match [Default: *].
            
            @rtype: string
            @return: The maximum version for the branch type and version pattern
        """
        branch_version_list = self.branch_version_list(
                                branch_type = branch_type,
                                version_pattern = version_pattern
                              )
        if (len(branch_version_list) > 0):
            return max( branch_version_list,
                        key = lambda v : v.split( '.' ) )
        
        return None
    
    def branch_version_list( self,
                             branch_type = BranchType.TRUNK,
                             version_pattern = '*' ):
        """ List available versions for a BranchType and a version pattern.
            This method must be implemented by subclasses.
            
            @type: string
            @param branch_type: The svn BranchType to get version list for.
            
            @type: string
            @param version_pattern: The version pattern to match [Default: *].
            
            @rtype: list
            @return: The list of matching versions
        """
        raise RuntimeError( 'ClientComponent: branch_version_list method is not '
                          + 'implemented. It must be defined by subclasses.' )
        
    def branch_project_info( self,
                             branch_type = BranchType.TRUNK, 
                             version = None ) :
        """ Reads project info file for a BranchType and a version.
            This method must be implemented by subclasses.
            
            @type: string
            @param branch_type: The svn BranchType to get the project info for
                                [Default: BranchType.TRUNK].
            
            @type: string
            @param version: The version to get project info for
                            [Default: None].
            
            @rtype: tuple
            @return: A tuple containing project name, component name and version
                     read from the project info file.
        """
        raise RuntimeError( 'ClientComponent: branch_project_info method is '
                          + 'not implemented. It must be defined by '
                          + 'subclasses.' )
    
    def branch_exists( self,
                       branch_type = BranchType.TRUNK,
                       version = None ):
        """ Checks that a BranchType version exists.
            This method must be implemented by subclasses.
            
            @type: string
            @param branch_type: The svn BranchType to check
                                [Default: BranchType.TRUNK].
            
            @type: string
            @param version: The version to check
                            [Default: None].
            
            @rtype: bool
            @return: True if the branch exists for the specified version,
                     False otherwise.
        """
        raise RuntimeError( 'ClientComponent: branch_exists method is not '
                          + 'implemented. It must be defined by subclasses.' )
  
    def branch_create( self,
                       src_branch_type = BranchType.TRUNK,
                       src_version = None,
                       dest_branch_type =  BranchType.BUG_FIX,
                       dest_version = None,
                       message = '',
                       simulate = False,
                       verbose = False ):
        """ Creates a new branch from a source branch.
            This method must be implemented by subclasses.
            
            @type: string
            @param src_branch_type: The source BranchType to create from
                                    [Default: BranchType.TRUNK].
            
            @type: string
            @param src_version: The source branch version to create from
                                [Default: None].
            @type: string
            @param dest_branch_type: The destination BranchType to create
                                    [Default: BranchType.BUG_FIX].
            
            @type: string
            @param dest_version: The destination branch version to create
                                [Default: None].
            
            @type: string
            @param message: The message to log to create the branch
                            [Default: ''].
        """
        raise RuntimeError( 'ClientComponent: branch_create method is not '
                          + 'implemented. It must be defined by subclasses.' )

    
    def branch_update_version_info( self,
                                    branch_type = BranchType.TRUNK,
                                    version = None,
                                    message = '',
                                    simulate = False,
                                    verbose = False ):
        """ Update the project info file for component branch version.
            This method must be implemented by subclasses.
            
            @type: string
            @param branch_type: The BranchType to update project info file for
                                [Default: BranchType.TRUNK].
            
            @type: string
            @param version: The version to update project info file for
                            [Default: None].
            
            @type: string
            @param message: The message used to log the version info update in
                            svn. [Default: ''].
                            
            @rtype: bool
            @return: True if the project info version was updated, False 
                     otherwise.
        """
        raise RuntimeError( 'ClientComponent: branch_update_version_info '
                          + 'method is not implemented. It must be defined '
                          + 'by subclasses.' )
                          
    def branch_merge_version_info( self,
                                   src_branch_type = BranchType.BUG_FIX,
                                   src_version = None,
                                   dest_branch_type = BranchType.TRUNK,
                                   dest_version = None,
                                   message = '',
                                   simulate = False,
                                   verbose = False ):
        """ Merge the project info file for component branch version.
            
            @type: string
            @param src_branch_type: The source BranchType to merge project info
                                    file for [Default: BranchType.TRUNK].
            
            @type: string
            @param src_version: The source version to merge project info file
                                for [Default: None].

            @type: string
            @param dest_branch_type: The destination BranchType to merge project
                                     info file for [Default: BranchType.TRUNK].
            
            @type: string
            @param dest_version: The destination version to merge project info 
                                 file for [Default: None].
            
            @type: string
            @param message: The message used to log the merge of version info in
                            svn. [Default: ''].
            
            @rtype: bool
            @return: True if the project info version was merged, False 
                     otherwise.
        """
        raise RuntimeError( 'ClientComponent: branch_merge_version_info '
                          + 'method is not implemented. It must be defined '
                          + 'by subclasses.' )
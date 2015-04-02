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
import glob, os, string, sys, traceback

class PluginsRegistry( object ):
    '''
        Class used to register plugins.
    '''
    def __new__( cls, *args, **kwargs ):
        '''
            The __new__ method of :py:class:`PluginsRegistry` class instanciates
            a singleton instance to register plugins.
        '''
        if '_registry_instance' not in cls.__dict__:
            cls._registry_instance = super(PluginsRegistry, cls).__new__( cls )
            registry_init = getattr( cls._registry_instance,
                                     '__registry_init__', None )
            if registry_init is not None:
                registry_init( *args, **kwargs )
        
        return cls._registry_instance

    def __init__( self, *args, **kwargs ):
        '''
            The __init__ method of :py:class:`PluginsRegistry` derived class
            should do nothing.
            Derived classes must define :py:meth:`__registry_init__` instead of 
            __init__.
        '''

    def __registry_init__( self, *args, **kwargs ):
        '''
            The __registry_init__ method is used to initialize
            :py:class:`PluginsRegistry` singleton instance.
        '''
        super(PluginsRegistry, self).__init__( *args, **kwargs )
        self._registered_plugins = {}

    def plugins_register( self, *classes ):
        '''
            Register plugin classes to the :py:class:`PluginsRegistry`.
            
            @type classes: list
            @param classes: The plugin classes to be registered to the
                            :py:class:`PluginsRegistry`
        '''
        for c in classes:
            try:
                for g in c._plugin_type.plugin_groups():
                    # Register plugin class for each group it belongs to
                    group_plugins = self._registered_plugins.setdefault(
                        g,
                        []
                    )
                    
                    if c not in group_plugins:
                        group_plugins.append(
                            c
                        )
            
            except AttributeError, e:
                print >> sys.stderr, 'WARNING: BrainVISA plugin', \
                                     module, 'class', c, 'failed to register', \
                                     'as plugin. It is necessary to add a', \
                                     'decorator @plugin_info to the class.'
    
    def plugins( self ):
        '''
            Returns the plugin classes registered to 
            :py:class:`PluginsRegistry`.
            
            @rtype: list
            @return: The classes registered to the
                     :py:class:`PluginsRegistry`
        '''
        return self._registered_plugins
    
def plugins():
    '''
        Returns the plugin classes registered to :py:class:`PluginsRegistry`.
        
        @rtype: list
        @return: The classes registered to the
                    :py:class:`PluginsRegistry`
    '''
    return PluginsRegistry().plugins()
    
def plugins_register( *classes ):
    '''
        Register plugin classes to the :py:class:`PluginsRegistry`.
        
        @type classes: list
        @param classes: The plugin classes to be registered to the
                        :py:class:`PluginsRegistry`
    '''
    PluginsRegistry().plugins_register( *classes )

def plugins_find( pathes ):
    '''
        Find plugin files in pathes. All '.py' files excluding '__init__.py'
        are considered to contain plugin classes.
        
        @type pathes: list
        @param pathes: The list of pathes to to find plugin files in.
        
        @rtype: list
        @return: The list of found python files.
    '''
    plugins = []
    for p in pathes:
        for f in glob.glob( os.path.join( p, '*.py' ) ):
            # Get python module name
            plugin_module_name, extension = os.path.splitext(
                os.path.basename(f)
            )
            
            if plugin_module_name not in ( '__init__', ):
                plugins.append(
                    ( plugin_module_name,
                      os.path.abspath( f ) )
                )

    return plugins
                
def plugins_import( *plugin_modules ):
    '''
        Import plugin files contained in python plugin modules.
        The plugin modules must have been imported before calling this method
        otherwise a KeyError will be raised. Each plugin module is a directory
        that must be importable, so it is necessary that it contains a
        __init__.py file.
        
        The __init__.py file can contain the following code to automatically
        register plugins when the plugin module is imported:
        
def _init_plugins():
    from brainvisa.maker.brainvisa_plugins_registry import plugins_import
    plugins_import( __name__ )
    
_init_plugins()

        Once plugin files have been imported, plugin classes decorated with
        \@plugin_info are available in the registered plugins.
        
        @type plugin_modules: list
        @param plugin_modules: The list of module names to load plugin files
                               for.
    '''
    for m in plugin_modules:
        
        # The module must have been imported before
        # being used there
        plugins_module = sys.modules[ m ]
    
        # Find python files contained in the plugins
        # directory
        for plugin_module_name, plugin_module_file \
            in plugins_find( plugins_module.__path__ ):

            if plugin_module_name != '__init__':
                plugin_module = string.join( 
                    ( m, plugin_module_name ),
                    '.'
                )
                
                try:
                    # Import the plugin module
                    __import__( plugin_module )
                
                except Exception, e:
                    traceback.print_exc(file = sys.stdout)
                    print >> sys.stderr, 'WARNING: BrainVISA plugin', \
                                        plugin_module, \
                                        'failed to import.'
                    continue
                
def plugins_module_import( *plugin_modules ):
    '''
        Import plugin files contained in python plugin modules. Each plugin
        module is a directory that must be importable, so it is necessary that 
        it contains a __init__.py file.
        
        Once plugin files have been imported, plugin classes decorated with
        \@plugin_info are available in the registered plugins.
        
        @type plugin_modules: list
        @param plugin_modules: The list of module names to load plugin files
                               for.
    '''
    for m in plugin_modules:
        if m not in sys.modules:
            try:
                __import__( m )
            
            except ImportError, e:
                continue
        
        # Import plugins
        plugins_import(
            m
        )
        
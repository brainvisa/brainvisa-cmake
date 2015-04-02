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
        
def plugin_info( name = None,
                 groups = (None,),
                 suffix = 'Plugin' ):
    """
        Class decorator to build plugin class.
        When the module that contain such a decorated class is imported,
        the class is automatically registered in the :py:class:`PluginRegistry`
    """
    
    def plugin_class_builder( cls ):
        """
            Function called to build plugin class.
        """
        
        import sys
        from brainvisa.maker.brainvisa_plugins_registry import plugins_register
    
        class Plugin(object):
            """
                Plugin base class.
            """
    
            @classmethod
            def plugin_name( cls ):
                return cls._plugin_name
            
            @classmethod
            def plugin_groups( cls ):
                return cls._plugin_groups
            
        try:
            if name is None:
                prefix = cls.__name__
                
            else:
                prefix = name
              
            # Create the name of the plugin class
            plugin_class_name = prefix + suffix
          
            # Generate the new plugin class that is defined in the module
            # of the original class
            plugin_cls = type(
                plugin_class_name,
                ( Plugin, ),
                { '_plugin_name'   : plugin_class_name,
                  '_plugin_groups' : groups,
                  '__module__'     : cls.__module__ }
            )
        
        except:
            raise TypeError( '@plugin_info: the class', cls, 'cannot'
                           + 'be decorated using @plugin_info. A class'
                           + 'that is decorated using @plugin_info must'
                           + 'derive from \'object\' class.' )
                                 
        # Set created plugin_type to the class
        cls._plugin_type = plugin_cls
        
        # Register Plugin class to the module
        #cls.__module__.__dict__[ plugin_class_name ] = plugin_cls
        
        # Register the new plugin class
        plugins_register( cls )
        
        return cls
    
    return plugin_class_builder
    
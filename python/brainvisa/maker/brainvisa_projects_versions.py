# -*- coding: utf-8 -*-

import brainvisa.compilation_info as pinfo

def project_version( projectname ):
    '''Brainvisa-cmake project version.'''
    # For now, take axon version. Could be specialized by project one day.
    return pinfo.packages_info[ 'axon' ][ 'version' ]


def project_description( projectname ):
    '''Brainvisa-cmake project description, to be displayed in the installer'''
    # hard-coded for now.
    descriptions = {
        'axon' : 'Axon: processes and data management, with GUI',
        'aims' : '3D/4D neuroimaging data manipulation and processing library and commands',
        'anatomist' : '3D/4D neuroimaging data viewer',
    }
    return descriptions.get( projectname, '' )


def component_version( componentname ):
    '''Brainvisa-cmake component version. Access brainvisa.compilation_info dictionary via a function.'''
    return pinfo.packages_info[ componentname ][ 'version' ]


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
        'axon' : 'Axon: organizes processing, pipelining, and data management for neuroimaging. It works both as a graphical user interface or batch and programming interfaces, and allows transparent processing distribution on a computing resource.',
        'aims' : '3D/4D neuroimaging data manipulation and processing library and commands. Includes C++ libraries, command lines, and a Python API.',
        'anatomist' : '3D/4D neuroimaging data viewer. Modular and versatile, Anatomist can display any kind of neuroimaging data (3D/4D images, meshes and textures, fiber tracts, and structured sets of objects such as cortical sulci), in an arbitrary number of views. Allows C++ and Python programming, both for plugins add-ons, as well as complete custom graphical applications design.',
    }
    return descriptions.get( projectname, '' )


def component_version( componentname ):
    '''Brainvisa-cmake component version. Access brainvisa.compilation_info dictionary via a function.'''
    return pinfo.packages_info[ componentname ][ 'version' ]


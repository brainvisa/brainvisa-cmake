# -*- coding: utf-8 -*-

import brainvisa.compilation_info as pinfo
from brainvisa.maker.brainvisa_projects import \
    brainvisaComponentsPerProject, brainvisaComponentsPerGroup


def project_version( projectname ):
    '''Brainvisa-cmake project version.'''
    # For now, take axon version. Could be specialized by project one day.
    return pinfo.packages_info[ 'axon' ][ 'version' ]


def project_description( projectname ):
    '''Brainvisa-cmake project description, to be displayed in the installer'''
    # hard-coded for now.
    descriptions = {
        'axon' : 'Axon organizes processing, pipelining, and data management for neuroimaging. It works both as a graphical user interface or batch and programming interfaces, and allows transparent processing distribution on a computing resource.',
        'aims' : '3D/4D neuroimaging data manipulation and processing library and commands. Includes C++ libraries, command lines, and a Python API.',
        'anatomist' : '3D/4D neuroimaging data viewer. Modular and versatile, Anatomist can display any kind of neuroimaging data (3D/4D images, meshes and textures, fiber tracts, and structured sets of objects such as cortical sulci), in an arbitrary number of views. Allows C++ and Python programming, both for plugins add-ons, as well as complete custom graphical applications design.',
        'soma' : 'Set of lower-level libraries for neuroimaging processing infrastructure',
        'morphologist' : 'Anatomical MRI (T1) analysis toolbox, featuring cortex and sulci segmentation, and sulci analysis tools, by the <a href="http://lnao.fr">LNAO team</a>.',
        'morphologist-ui' : 'New graphical interface for the Morphologist main pipelines',
        'cortical_surface' : 'Cortex-based surfacic parameterization and analysis toolbox from the <a href="http://www.lsis.org">LSIS team</a>. Homepage: <a href="http://olivier.coulon.perso.esil.univmed.fr/brainvisa.html">http://olivier.coulon.perso.esil.univmed.fr/brainvisa.html</a>.<br/>Also contains the FreeSurfer toolbox for BrainVisa, by the LNAO team.',
        'brainrat' : 'Ex vivo 3D reconstruction and analysis toolbox, from the <a href="http://www-dsv.cea.fr/dsv/instituts/institut-d-imagerie-biomedicale-i2bm/services/mircen-mircen/unite-cnrs-ura2210-lmn/fiches-thematiques/traitement-et-analyse-d-images-biomedicales-multimodales-du-cerveau-normal-ou-de-modeles-precliniques-de-maladies-cerebrales">BioPICSEL CEA team</a>. Homepage: <a href="http://brainvisa.info/doc/brainrat-gpl/brainrat_man/en/html/index.html">http://brainvisa.info/doc/brainrat-gpl/brainrat_man/en/html/index.html</a>',
        'datamind' : 'Statistics, data mining, machine learning.',
    }
    return descriptions.get( projectname, '' )


def component_version( componentname ):
    '''Brainvisa-cmake component version. Access brainvisa.compilation_info dictionary via a function.'''
    return pinfo.packages_info[ componentname ][ 'version' ]


def project_components( projectname, remove_private=False ):
    if projectname in brainvisaComponentsPerProject:
        return [
            component for component in \
                brainvisaComponentsPerProject[ projectname] \
            if __keep_component( component, remove_private ) ]
    elif projectname in pinfo.packages_info:
          return [ projectname ]
    raise ValueError( 'Unknown project name: %s' % projectname )


def __keep_component( component, remove_private ):
    if component not in pinfo.packages_info:
        return False
    if not remove_private:
        return True
    return not is_private_component( component )


def is_private_component( component ):
    '''Private components are not packaged in public releases, but only part of "i2bm" releases.'''
    if component not in brainvisaComponentsPerGroup['all']:
        return False
    additional_private_components = (
        'baby', 'tms', 'sulci-data', 'constellation-private',
        'constellation-gpl', 'bioprocessing', )
    if component in additional_private_components:
        return True
    return False

def is_default_project( projectname ):
    '''Default projects are selected by default in the installer. They are important components.
    '''
    if projectname in ( 'aims', 'anatomist', 'axon', 'brainrat', 
            'cortical_surface', 'datamind', 'morphologist', 
            'morphologist_ui' ):
        return True
    return False

def is_default_component( componentname ):
    '''Default components are selected by default in the installer. They are important components. If they are "virtual" and default, then they will be installed anyway, the user will not be able to disable them.'''
    component = pinfo.packages_info.get( componentname )
    if not component:
        return False
    return component.get( 'default_install', False )



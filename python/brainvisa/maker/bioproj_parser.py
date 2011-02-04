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

from subprocess import Popen, PIPE, STDOUT
from tempfile import NamedTemporaryFile

SVN_URL = 'https://bioproj.extra.cea.fr/neurosvn'
BRAINVISA_SVN_URL = SVN_URL + '/brainvisa'
# Projects that are listed here to define an order of processing
# for their components. Projects not listed but present in BioProj
# will be added at the end of this list in an unknown order.
projects = [ 
  'development',
  'installer',
  'brainvisa-share',
  'soma',
  'aims', 
  'anatomist', 
  'axon', 
  'axon_web',
  'data_storage_client',
  'datamind',
  't1mri',
  'sulci',
  'connectomist',
  'cortical_surface',
  'brainrat',
  'optical_imaging',
  'nuclear_processing',
  'pyhrf',
  'fmri',
  'famis',
  'sandbox',
  'ptk',
  'communication',
]

excludeProjects = set()
excludeComponents = set()

# If component order inside a project is important, it is possible to
# declare them in componentsPerProject. Components not listed but present
# in BioProj will be added in an unknown order.
componentsPerProject = {
 'development': [ 'brainvisa-cmake', 'brainvisa-svn' ],
 'aims': [ 'aims-free', 'aims-gpl' ],
 'anatomist': [ 'anatomist-free', 'anatomist-gpl' ],
 'brainrat': [ 'brainrat-gpl', 'brainrat-private', 'bioprocessing' ],
 'connectomist': [ 'connectomist-private', 'connectomist-gpl' ],
 'cortical_surface': [ 'cortical_surface-private', 'cortical_surface-gpl' ],
 'fmri': [ 'fmri-private', 'fmri-gpl' ],
 'optical_imaging' : ['optical_imaging-private', 'optical_imaging-gpl'],
 'nuclear_processing': [ 'nuclear_processing-gpl',
                         'nuclear_processing-private' ],
 'soma': [ 'soma-base',  'soma-io', 'soma-qtgui' ],
 'sulci': [ 'sulci-private', 'sulci-gpl', 'sulci-data' ],
 't1mri': [ 't1mri-private', 't1mri-gpl' ],
 'famis': [ 'famis-private', 'famis-gpl' ],
 'pyhrf': [ 'pyhrf-free', 'pyhrf-gpl' ],
 'communication': [ 'bibliography', 'latex', 'web', 'documentation' ],
}


groupsDefinition = {
  'standard': [ 
    'aims/*',
    'brainvisa-share/*',
    'anatomist/*',
    'axon/*',
    'axon_web/*',
    'brainrat/brainrat-gpl',
    'communication/*',
    'connectomist/*',
    'cortical_surface/*',
    'datamind/*',
    'data_storage_client/*',
    'development/*',
    'fmri/*',
    'installer/*',
    'optical_imaging/*',
    'nuclear_processing/*',
    'soma/*',
    'sulci/*',
    't1mri/*',
    'pyhrf/*',
  ],
  'opensource': [
    'aims/*',
    'brainvisa-share/*',
    'anatomist/*',
    'axon/*',
    'axon_web/*',
    'brainrat/*-gpl',
    'communication/*',
    'connectomist/*-gpl',
    'cortical_surface/*-gpl',
    'cortical_surface/freesurfer_plugin',
    'data_storage_client/*',
    'development/*',
    'fmri/*-gpl',
    'installer/*',
    'optical_imaging/*-gpl',
    'nuclear_processing/*-gpl',
    'soma/*',
    'sulci/*-gpl',
    't1mri/*-gpl',
    'pyhrf/*',
  ],
  'anatomist': [
    'aims/*',
    'brainvisa-share/*',
    'soma/soma-base',
    'anatomist/*',
    'development/brainvisa-cmake',
  ],
}

projectPerComponent = {}
for project, components in componentsPerProject.iteritems():
  for component in components:
    p = projectPerComponent.setdefault( component, project )
    if p != project:
      raise RuntimeError( 'Component ' + component + ' is declared to be in two projects, ' + p + ' and ' + project )

def system( *command ):
  cmd = Popen( command, stdout=PIPE, stderr=STDOUT )
  output = cmd.stdout.read()
  cmd.wait()
  if cmd.returncode != 0:
    raise SystemError( 'System command exited with error code ' + repr( cmd.returncode ) + ': ' + ' '.join( ('"'+i+'"' for i in command) ) )
  return output


def list_svn_directories( url ):
  output = system( 'svn', 'list', url )
  return [ i[ :-1 ] for i in output.split( '\n' ) if i and i[-1] == '/' ]

def find_branches_and_tags( projects=None, components=None, excludeProjects=excludeProjects ):
  '''
  Look in BRAINVISA_SVN_URL for branches. Returns a generator
  containing tuples with four elements: ( project, component, url, branches ).
    project is the project name (e.g. 'anatomist', 'axon').
    component is the component name (e.g. 'anatomist-gpl', 'anatomist-free') or
      None when the project is a component (such as axon).
    url is the base Subversion URL for the component (e.g. 
      'https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-gpl').
    branches is a list of existing branches sorted from the lowest to the highest
      (e.g. ['3.1', '3.2', '3.12', '3.113']).
  '''
  if projects is None:
    projects = [ i for i in list_svn_directories( BRAINVISA_SVN_URL ) if i != 'source_views' ]
  for project in projects:
    if excludeProjects and project in excludeProjects: continue
    if components is None:
      selected_components = [ i for i in list_svn_directories( BRAINVISA_SVN_URL + '/' + project ) if i != 'build-config' ]
    else:
      selected_components = components
    if selected_components:
      if 'trunk' in selected_components:
        selected_components = [ None ]
      for component in selected_components:
        if component in excludeComponents: continue
        if component is None:
          url = BRAINVISA_SVN_URL + '/' + project
        else:
          url = BRAINVISA_SVN_URL + '/' + project + '/' + component
        try:
          branches = [ '.'.join( (str(l) for l in k ) ) for k in sorted( ( ([int(j) for j in i.split('.')] for i in list_svn_directories( url + '/branches' ) ) ) ) ]
        except SystemError:
          branches = []
        try:
          tags = [ '.'.join( (str(l) for l in k ) ) for k in sorted( ( ([int(j) for j in i.split('.')] for i in list_svn_directories( url + '/tags' ) ) ) ) ]
        except SystemError:
          tags = []
        yield ( project, component, url, branches, tags )

def read_bioproj_cmake_version( url ):
  temporary = NamedTemporaryFile()
  command = [ 'svn', 'export', url, temporary.name ]
  cmd = Popen( command, stdout=PIPE, stderr=STDOUT )
  cmd.stdout.read()
  cmd.wait()
  if cmd.returncode == 0:
    major = ''
    minor = ''
    patch = ''
    for line in open( temporary.name ):
      l = line.split()
      if 'BRAINVISA_PACKAGE_VERSION_MAJOR' in l:
        major = l[ l.index( 'BRAINVISA_PACKAGE_VERSION_MAJOR' ) + 1 ]
      if 'BRAINVISA_PACKAGE_VERSION_MINOR' in l:
        minor = l[ l.index( 'BRAINVISA_PACKAGE_VERSION_MINOR' ) + 1 ]
      if 'BRAINVISA_PACKAGE_VERSION_PATCH' in l:
        patch = l[ l.index( 'BRAINVISA_PACKAGE_VERSION_PATCH' ) + 1 ]
    return ( major,  minor, patch )
  return None

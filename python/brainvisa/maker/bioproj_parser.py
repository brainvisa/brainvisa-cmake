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

import re
from subprocess import Popen, PIPE, STDOUT
from tempfile import NamedTemporaryFile
from fnmatch import fnmatch, fnmatchcase
from brainvisa.maker.brainvisa_projects import brainvisaComponentsPerGroup, brainvisaComponentsPerProject, brainvisaProjectPerComponent, brainvisaBranchesPerComponent, brainvisaTagsPerComponent, brainvisaURLPerComponent

SVN_URL = 'https://bioproj.extra.cea.fr/neurosvn'
BRAINVISA_SVN_URL = SVN_URL + '/brainvisa'
# Projects that are listed here to define an order of processing
# for their components. Projects not listed but present in BioProj
# will be added at the end of this list in an unknown order.
projects = [
  'communication',
  'development',
  'brainvisa-installer',
  'brainvisa-share',
  'soma',
  'aims',
  'anatomist',
  'axon',
  'data_storage_client',
  'datamind',
  'morphologist',
  'connectomist',
  'cortical_surface',
  'brainrat',
  'nuclear_imaging',
  'nuclear_processing',
  'optical_imaging',
  'pyhrf',
  'fmri',
  'ptk',
  'famis',
  'sandbox',
]

excludeComponents = [ 'ptk/toolbox-user-*' ]

# If component order inside a project is important, it is possible to
# declare them in componentsPerProject. Components not listed but present
# in BioProj will be added in an unknown order.
componentsPerProject = {
 'development': [ 'brainvisa-cmake', 'brainvisa-svn' ],
 'communication': [ 'documentation', 'bibliography', 'latex', 'web' ],
 'aims': [ 'aims-free', 'aims-gpl' ],
 'anatomist': [ 'anatomist-free', 'anatomist-gpl' ],
 'brainrat': [ 'brainrat-gpl', 'brainrat-private', 'bioprocessing' ],
 'connectomist': [ 'connectomist-private', 'connectomist-gpl' ],
 'cortical_surface': [ 'cortical_surface-private', 'cortical_surface-gpl' ],
 'fmri': [ 'fmri-private', 'fmri-gpl' ],
 'nuclear_imaging': [ 'nuclear_imaging-gpl', ],
 'nuclear_processing': [ 'nuclear_processing-gpl',
                         'nuclear_processing-private' ],
 'optical_imaging' : ['optical_imaging-private', 'optical_imaging-gpl'],
 'soma': [ 'soma-base',  'soma-io', 'soma-qtgui' ],
 'morphologist': [ 'morphologist-private', 'morphologist-gpl', 'baby', 'tms', 'sulci-data', 'sulci-private', 'sulci-gpl' ],
 'famis': [ 'famis-private', 'famis-gpl' ],
 'pyhrf': [ 'pyhrf-free', 'pyhrf-gpl' ],
 'ptk': [ 'ptk', 'pyptk', 'mri-reconstruction', 'relaxometrist', 'nucleist', 'functionalist', 'connectomist', 'microscopist', 'realtime-mri' ],
}


groupsDefinition = {
  'standard': [
    'aims/*',
    'brainvisa-share/*',
    'anatomist/*',
    'axon/*',
    'brainrat/brainrat-gpl',
    'communication/*',
    'connectomist/*',
    'cortical_surface/*',
    'datamind/*',
    'data_storage_client/*',
    'development/*',
    'fmri/*',
    'brainvisa-installer/*',
    'nuclear_imaging/*',
    'optical_imaging/*',
    'soma/*',
    'morphologist/*',
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
    'brainvisa-installer/*',
    'nuclear_imaging/*-gpl',
    'nuclear_processing/*-gpl',
    'optical_imaging/*-gpl',
    'soma/*',
    'morphologist/*-gpl',
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

def find_branches_and_tags( projects=None, components=None, excludeComponents=excludeComponents ):
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
  real_component_name = {}
  if projects is None:
    projects = [ i for i in list_svn_directories( BRAINVISA_SVN_URL ) if i != 'source_views' ]
  for project in projects:
    if components is None:
      selected_components = [ i for i in list_svn_directories( BRAINVISA_SVN_URL + '/' + project ) if i != 'build-config' ]
    else:
      selected_components = components
    if selected_components:
      if 'trunk' in selected_components:
        selected_components = [ None ]
      for component in selected_components:
        if excludeComponents:
          projectAndComponent = project + ( '/' + component if component else '' )
          for exclude_pattern in excludeComponents:
            if fnmatch( projectAndComponent, exclude_pattern ):
              exclude = True
              break
          else:
            exclude = False
          if exclude:
            continue
        if component is None:
          url = BRAINVISA_SVN_URL + '/' + project
        else:
          url = BRAINVISA_SVN_URL + '/' + project + '/' + component
        try:
          list_svn_directories(url)
        except SystemError:
          pass
        else:
          try:
            branches = [ '.'.join( (str(l) for l in k ) ) for k in sorted( ( ([int(j) for j in i.split('.')] for i in list_svn_directories( url + '/branches' ) if (re.match("\d+\.\d+", i) is not None) ) ) ) ]
          except SystemError:
            branches = []
          try:
            tags = [ '.'.join( (str(l) for l in k ) ) for k in sorted( ( ([int(j) for j in i.split('.')] for i in list_svn_directories( url + '/tags' ) ) ) ) ]
          except SystemError:
            tags = []
          component_name = real_component_name.get( ( project if component is None else component ) )
          if component_name is None:
            try:
              project_info = system( 'svn', 'cat', url + '/trunk/project_info.cmake' )
            except SystemError:
              component_name = ''
            else:
              l = project_info.split()
              component_name = l[ l.index( 'BRAINVISA_PACKAGE_NAME' ) + 1 ]
            real_component_name[ component ] = component_name
          if component_name:
            yield ( project, component_name, url, branches, tags )

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

def getBrainVISAComponents( componentsPattern ):
  """Gets all the Brainvisa components that match the given pattern. 
  
  @type componentsPattern: string
  @param componentsPattern: The pattern can be:
  - the name of a group of projects (standard, opensource...)
  - the name of a project (soma, axon, anatomist...)
  - the name of a component (soma-base, anatomist-gpl...)
  - a fnmatch pattern matching a Brainvisa component in any project (soma-*, old-connectomist-*, ...)
  - fnmatch patterns matching a project and a component <project_pattern>:<component_pattern> (anatomist:*, connectomist:old-connectomist-*,...)
  
  @rtype: list
  @return: the list of components that match the pattern
  """
  components = brainvisaComponentsPerGroup.get( componentsPattern )
  if components is None:
    components = brainvisaComponentsPerProject.get( componentsPattern )
    if components is None:
      if componentsPattern in brainvisaProjectPerComponent:
        components = [ componentsPattern ]
      else:
        l = componentsPattern.split( ':' )
        if len( l ) > 2:
          raise SyntaxError()
        if len( l ) == 1:
          projectPattern = '*'
          componentPattern = l[ 0 ]
        else:
          projectPattern, componentPattern = l
        components = []
        for project, projectComponents in brainvisaComponentsPerProject.iteritems():
          if fnmatchcase( project, projectPattern ):
            for component in projectComponents:
              if fnmatchcase( component, componentPattern ):
                components.append( component )
  return components

_urlsAlias = {
  'development': 'trunk',
  'bug_fix': 'branch:-1',
  'latest_release': 'tag:-1',
  'tag': 'tag:-1',
  'branch': 'branch:-1',
  'stable': 'branch:-1',
}

def getMatchingURLs( component, versionPattern ):
  """
  Gets the url in svn repository for the given component and version.
  @type component: string
  @param component: the name of the component
  @type versionPattern: string
  @param versionPattern: the version of the component. It could be:
  - the name of the branch: trunk or development; bug_fix, branch or stable; latest_release or tag
  - a version number (4.1, 3.2.0...)
  - the type of branch and an index: the nth tag or branch (branch:0, tag:2, branch:-1, ...)
  
  @rtype: tuple
  @return: a tuple containing (<component name>, <branch type>, <url>); branch type is trunk, branch or tag
  """
  versionPattern = _urlsAlias.get( versionPattern, versionPattern )
  if versionPattern == 'trunk':
    versions = [ ( 'trunk', 'trunk' ) ]
  else:
    l = versionPattern.split( ':' )
    if len( l ) == 1:
      if fnmatchcase( 'trunk', versionPattern ):
        versions = [ ( 'trunk', 'trunk' ) ]
      else:
        versions = []
      for branch in brainvisaBranchesPerComponent.get( component, [] ):
        if fnmatchcase( branch, versionPattern ):
          versions.append( ( 'branch', 'branches/' + branch ) )
      for tag in brainvisaTagsPerComponent.get( component, [] ):
        if fnmatchcase( tag, versionPattern ):
          versions.append( ( 'tag', 'tags/' + tag  ) )
    elif len( l ) == 2:
      try:
        index = int( l[1] )
      except ValueError:
        raise SyntaxError()
      if l[0] == 'branch':
        try:
          versions = [ ( 'branch', 'branches/' + brainvisaBranchesPerComponent.get( component, [] )[ index ] ) ]
        except IndexError:
          versions = []
      elif l[0] == 'tag':
        try:
          versions = [ ( 'tag', 'tags/' + brainvisaTagsPerComponent.get( component, [] )[ index ] ) ]
        except IndexError:
          versions = []
      else:
        raise SyntaxError() 
    else:
      raise SyntaxError()
  return [ ( component, i[0], brainvisaURLPerComponent[ component ] + '/' + i[1] ) for i in versions ]
# -*- coding: utf-8 -*-

import glob, operator, os, re, string, urlparse
from fnmatch import fnmatchcase

SVN_URL = 'https://bioproj.extra.cea.fr/neurosvn'
BRAINVISA_SVN_URL = SVN_URL + '/brainvisa'

from brainvisa.maker.components_definition import components_definition
from brainvisa.maker.version_number        import VersionNumber, \
                                                  version_format_unconstrained

ordered_projects = [] # Keeping the order of project is important because this
                      # is the way configuration dependencies are handled
components_per_group = {}
components_per_project = {}
project_per_component = {}
url_per_component = {}
info_per_component = {}
attributes_per_component = {}
for project, components in components_definition:
  ordered_projects.append(project)
  for component, component_info in components['components']:
    for group in component_info['groups']:
      components_per_group.setdefault(group,set()).add(component)
      url_per_component[component] = component_info['branches']
      info_per_component[component] = component_info
    components_per_project.setdefault(project,[]).append(component)
    project_per_component[component] = project
del project, component, components, component_info, group

def parse_project_info_cmake(
    path,
    version_format = version_format_unconstrained
):
  """Parses a project_info.cmake file
  
  @type path: string
  @param path: The path of the project_info.cmake file
  
  @rtype: tuple
  @return: A tuple that contains project name, component name and version
  """
  project = None
  component = None
  version = VersionNumber(
                '1.0.0',
                format = version_format
            )

  p = re.compile( r'\s*set\(\s*([^ \t]*)\s*(.*[^ \t])\s*\)' )
  for line in open( path ):
    match = p.match( line )
    if match:
      variable, value = match.groups()
      if variable == 'BRAINVISA_PACKAGE_NAME':
        component = value
      elif variable == 'BRAINVISA_PACKAGE_MAIN_PROJECT':
        project = value
      elif variable == 'BRAINVISA_PACKAGE_VERSION_MAJOR' and len(version) > 0:
        version[ 0 ] = value
      elif variable == 'BRAINVISA_PACKAGE_VERSION_MINOR' and len(version) > 1:
        version[ 1 ] = value
      elif variable == 'BRAINVISA_PACKAGE_VERSION_PATCH' and len(version) > 2:
        version[ 2 ] = value
        
  return ( project, component, version )

def parse_project_info_python(
    path,
    version_format = version_format_unconstrained
):
  """Parses an info.py file
  
  @type path: string
  @param path: The path of the info.py file
  
  @rtype: tuple
  @return: A tuple that contains project name, component name and version
  """

  d = {}
  version = VersionNumber(
                '1.0.0',
                format = version_format
            )
  execfile(path, d, d)
  for var in ('NAME', 'version_major', 'version_minor', 'version_micro'):
    if var not in d:
      raise KeyError('Variable %s missing in info file %s' % (var, path))
    
  project = component = d['NAME']
  if len(version) > 0:
    version[0] = d['version_major']
    
    if len(version) > 1:
      version[1] = d['version_minor']
    
      if len(version) > 2:
        version[2] = d['version_micro']
  
  return ( project, component, version )

def find_project_info( directory ):
  """Find the project_info.cmake or the info.py file
     contained in a directory.
     Files are searched using the patterns :
     1) <directory>/project_info.cmake
     2) <directory>/python/*/info.py
     3) <directory>/*/info.py
     
  @type directory: string
  @param directory: The directory to search project_info.cmake or info.py
  
  @rtype: string
  @return: The path of the found file containing project information
           or None when no file was found
  """
  project_info_cmake_path = os.path.join( directory,
                                          'project_info.cmake' )
  project_info_python_pattern = os.path.join( directory,
                                              'python',
                                              '*',
                                              'info.py' )
  project_info_python_fallback_pattern = os.path.join( directory,
                                                       '*',
                                                       'info.py' )

  # Searches for project_info.cmake and info.py file
  for pattern in ( project_info_cmake_path,
                    project_info_python_pattern,
                    project_info_python_fallback_pattern ):
    project_info_python_path = glob.glob( pattern )
  
    if project_info_python_path:
      return project_info_python_path[0]
  
  return None

def read_project_info( directory,
                       version_format = version_format_unconstrained ):
  """Find the project_info.cmake or the info.py file
     contained in a directory and parses its content.
     Files are searched using the patterns :
     1) <directory>/project_info.cmake
     2) <directory>/python/*/info.py
     3) <directory>/*/info.py
     
  @type directory: string
  @param directory: The directory to search project_info.cmake or info.py
  
  @type version_format: VersionFormat
  @param version_format: The version format to use to parse version.
  
  @rtype: tuple
  @return: A tuple that contains project name, component name and version
  """
  project_info = None
  project_info_path = find_project_info( directory )
  
  if project_info_path is not None:
    
    if project_info_path.endswith( '.cmake' ):
      project_info = parse_project_info_cmake(
                         project_info_path,
                         version_format = version_format
                     )
      
    elif project_info_path.endswith( '.py' ):
        project_info = parse_project_info_python(
                           project_info_path,
                           version_format = version_format
                       )
        
    else:
      raise RuntimeError( 'File ' + project_info_path + ' has unknown '
                        + 'extension for project info file.'  )
    
    return project_info
    
  else:
    return None

def parse_versioning_client_info( client_info ):
  """Parses versioning client information for BrainVISA projects.
     The versioning client information is described using the format
     <client_type> <url> [<client_parameters>]
     
     i.e: svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-gpl/branches/4.4
     or git https://github.com/neurospin/soma-workflow.git master
  
  @type client_info: string
  @param client_info: The informations concerning the client
  """
  splitted_client_info = string.split(client_info, ' ')
  client_type, url = splitted_client_info[ 0:2 ]
  client_params = splitted_client_info[ 2: ]
  return (client_type, url, client_params)
  
def find_components( componentsPattern ):
  """Gets all the Brainvisa components that match the given pattern. 
  
  @type componentsPattern: string
  @param componentsPattern: The pattern can be:
  - the name of a group of projects (standard, opensource...)
  - the name of a project (soma, axon, anatomist...)
  - the name of a component (soma-base, anatomist-gpl...)
  - a fnmatch pattern matching a Brainvisa component in any project
    (soma-*, old-connectomist-*, ...)
  - fnmatch patterns matching a project and a component
    <project_pattern>:<component_pattern> (anatomist:*, connectomist:old-connectomist-*,...)
  
  @rtype: list
  @return: the list of components that match the pattern
  """
  components = components_per_group.get( componentsPattern )
  if components is None:
    components = components_per_project.get( componentsPattern )
    if components is None:
      if componentsPattern in project_per_component:
        components = [ componentsPattern ]
      else:
        l = componentsPattern.split( ':' )
        if len( l ) > 2:
          raise SyntaxError( '%s is not a valid component pattern' % repr(componentsPattern) )
        if len( l ) == 1:
          projectPattern = '*'
          componentPattern = l[ 0 ]
        else:
          projectPattern, componentPattern = l
        components = []
        for project, projectComponents in components_per_project.iteritems():
          if fnmatchcase( project, projectPattern ):
            for component in projectComponents:
              if fnmatchcase( component, componentPattern ):
                components.append( component )
  return components

#if __name__ == '__main__':
    
    #print 'components_definition = ['
    #for project in sorted(components_definition):
        #project_dict = components_definition[project]
        #print "    ('%s', {" % project
        #description = project_dict.get('description')
        #if description:
            #print "        'description': %s," % repr(description)
        #print "        'components': ["
        #for component, component_dict in project_dict['components']:
            #print "            ['%s', {" % component
            #groups = component_dict.pop('groups')
            #print "                'groups': %s," % repr(groups)
            #print "                'branches': {"
            #for branch in ('trunk', 'bug_fix', 'tag'):
                #url = component_dict['branches'].get(branch)
                #if url:
                  #url, dest_directory = url
                  #print "                    '%s': (%s,%s)," % (branch,repr(url),repr(dest_directory))
            #print '                },'
            #print '            }],'
        #print "        ],"
        #print '    }),'
    #print ']'

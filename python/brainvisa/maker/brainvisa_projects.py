# -*- coding: utf-8 -*-

import operator
from fnmatch import fnmatchcase

SVN_URL = 'https://bioproj.extra.cea.fr/neurosvn'
BRAINVISA_SVN_URL = SVN_URL + '/brainvisa'

from brainvisa.maker.components_definition import components_definition

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


def find_components( componentsPattern ):
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

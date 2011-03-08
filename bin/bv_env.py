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

import sys, os
from glob import glob

if os.path.exists( sys.argv[0] ):
  this_script = sys.argv[0]
else:
  this_script = None
  for p in os.environ.get( 'PATH', '' ).split( os.pathsep ) + [ os.curdir ]:
    s = os.path.join( p, sys.argv[0] )
    if os.path.exists( s ):
      this_script = s
      break
if this_script:
  install_directory = os.path.dirname( os.path.dirname( this_script ) )

# Define environment variables modifications
unset_variables = [ 'SIGRAPH_PATH', 'ANATOMIST_PATH', 'AIMS_PATH' ]
set_variables = {
 'LC_NUMERIC': 'C',
 'BRAINVISA_SHARE': install_directory + '/share',
}
path_prepend = {
  'DCMDICTPATH': [ install_directory + '/lib/dicom.dic' ],
  'PYTHONPATH': [ install_directory + '/python' ],
  'PATH': [ install_directory + '/bin/real-bin', install_directory + '/bin' ],
  'LD_LIBRARY_PATH': [ install_directory + '/lib' ],
}

# Look for Python in install_directory
python_dirs = glob( os.path.join( install_directory, 'lib', 'python*' ) )
if python_dirs:
  python_version = python_dirs[ 0 ][ -3: ]
  set_variables[ 'PYTHONHOME' ] = install_directory
  path_prepend[ 'PYTHONPATH' ].append( install_directory + '/lib/python' + python_version + '/site-packages' )


backup_variables = {}
for n in unset_variables:
  if n in os.environ:
    backup_variables[ n ] = os.environ[ n ]
    del os.environ[ n ]
for n, v in set_variables.iteritems():
  v = v.replace( '${INSTALL_DIRECTORY}', install_directory )
  if n in os.environ and os.environ[ n ] != v:
    backup_variables[ n ] = os.environ[ n ]
  os.environ[ n ] = v
for n, l in path_prepend.iteritems():
  if n in os.environ:
    backup_variables[ n ] = os.environ[ n ]
    content = os.environ[ n ].split( os.pathsep )
  else:
    content = []
  
  for v in reversed( l ):
    v = v.replace( '${INSTALL_DIRECTORY}', install_directory )
    content.insert( 0, v )
  os.environ[ n ] = os.pathsep.join( ( i for i in content if os.path.exists( i ) ) )

if len( sys.argv ) > 1:
  for n, v in backup_variables.iteritems():
    os.environ[ 'BRAINVISA_UNENV_' + n ] = v
  os.execvpe( sys.argv[1], sys.argv[ 1: ], os.environ )
else:
  for n, v in backup_variables.iteritems():
    print 'export BRAINVISA_UNENV_' + n + "='" + v + "'"
  for n in unset_variables:
    print 'unset', n
  for n in set_variables:
    print 'export', n + "='" + os.environ[ n ] + "'"
  for n in path_prepend:
    v = os.environ[ n ]
    if v:
      print 'export', n + "='" + v + "'"
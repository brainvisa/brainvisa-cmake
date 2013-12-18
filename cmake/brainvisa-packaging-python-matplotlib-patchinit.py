#!/usr/bin/env python

import os, re, sys

infile = sys.argv[1]
outfile = sys.argv[2]

r = re.compile( "((^.*$\n)*)^( *path = '/usr/share/matplotlib/mpl-data')$\n((^.*$\n)*)^( *raise RuntimeError\('Could not find the matplotlib data files'\))$\n+( *# setuptools' namespace_packages may highjack this init file$\n(^.*$\n)*)^( *path = *('/etc') # guaranteed to exist or raise)$\n((^.*$\n?)*)\Z", re.MULTILINE )

lines = open( infile ).read()
m = r.match( lines )

olines = open( outfile, 'w' )
olines.write( m.group(1) )
olines.write( "    path = os.sep.join([os.path.dirname(__file__), 'mpl-data'])\n" )
olines.write( m.group(4) )
olines.write( m.group(7) )
olines.write( '    path =  get_data_path() # guaranteed to exist or raise\n' )
olines.write( m.group(11) )

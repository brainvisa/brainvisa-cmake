#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import sys, os, glob

toreplace = 'gtk+'
replaced = 'kg+t'

def usage( fail=False ):
  print(os.path.basename( sys.argv[0] ), '''[--replace] [-h] [--help] [<libdir>]
Patch libQtGui to remove references to gtk+ library, to avoid system binaries incompatibilities
options:
  -h, --help : print this help and quit
  --revert   : revert patching: set references to gtk+ as original

<libdir> is the libraries dir. If not specified, libraries will be found relatively to this script, in "../lib/libQtGui.so.*"
''')
  if fail:
    sys.exit( 1 )
  else:
    sys.exit( 0 )

if '-h' in sys.argv[1:] or '--help' in sys.argv[1:]:
  usage()

if '--revert' in sys.argv[1:]:
  toreplace = 'kg+t'
  replaced = 'gtk+'
  sys.argv.remove( '--revert' )

if os.path.dirname( sys.argv[0] ).endswith( 'real-bin' ):
  path = os.path.join( os.path.dirname( os.path.dirname( sys.argv[0] ) ),
    'lib' )
else:
  path = os.path.join( os.path.dirname( sys.argv[0] ), 'lib' )

if len( sys.argv ) == 2:
  path = sys.argv[1]
elif len( sys.argv ) != 1:
  usage( True )

for f in glob.glob( os.path.join( path, 'libQtGui.so.*' ) ):
  if not os.path.islink( f ) and not f.endswith( '.debug' ):
    print('patching:', f)
    contents = open( f, 'rb' ).read().replace( toreplace, replaced )
    open( f, 'wb' ).write( contents )


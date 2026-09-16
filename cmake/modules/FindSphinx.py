import sys
import sphinx
import os

ver = sphinx.__version__.split( '.' )
ver = [ int(x) for x in ver ]
ver = ver[0] * 0x10000 + ver[1] * 0x100 + ver[2]
print( "sphinx_version:%x" % ver )
print( "sphinx_package_dir:%s" % sphinx.package_dir )
pths = os.getenv( 'PATH' ).split( os.pathsep )
altbindir = None
bindir = None
binext = ''
if sys.platform.startswith('win'):
    binext='.exe'
    
for p in pths:
  if os.path.exists( os.path.join( p, 'sphinx-build' + binext ) ):
    if sphinx.package_dir.startswith( os.path.dirname( p ) ):
      bindir = p
      break
    elif altbindir is None:
      altbindir = p
if bindir is None:
  bindir = altbindir
  if bindir is None:
    bindir = ''
print( "sphinx_bin_dir:%s" % bindir )

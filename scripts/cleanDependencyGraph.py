import sys, os, re
reNode = re.compile( r'\s*"(?P<node>[^"]*)"\s*\[\s*label="(?P<label>[^"]*)"\s*shape="(?P<shape>[^"]*)"\];.*' )
reLink = re.compile( r'\s*"(?P<node1>[^"]*)"\s*-\>\s*"(?P<node2>[^"]*)".*' )
reExclude = re.compile( r'(Aims.*)|(Vip.*)|(.*_test)|(comist.*)' )
excludeNodes = set()
excludeLabels = set( ( 'pthread', '-lpthread' ) )
for line in open( 'dependencies.dot' ).readlines():
  match = reNode.match( line )
  if match:
    print >> sys.stderr, repr( match.group( 'label' ) ), match.group( 'label' ) in excludeLabels 
    if match.group( 'label' ) in excludeLabels or ( match.group( 'shape' ) == 'house' and reExclude.match( match.group( 'label' ) ) ):
      excludeNodes.add( match.group( 'node' ) )
    else:
      sys.stdout.write( line )
  else:
    match = reLink.match( line )
    if match:
      print >> sys.stderr, match.group( 'node1' ), match.group( 'node2' )
    if not match or ( match.group( 'node1' ) not in excludeNodes and match.group( 'node2' ) not in excludeNodes ):
      sys.stdout.write( line )


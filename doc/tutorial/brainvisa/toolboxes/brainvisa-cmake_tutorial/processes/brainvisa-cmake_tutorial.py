# -*- coding: utf-8 -*-

from __future__ import absolute_import

from brainvisa.processes import *

signature = Signature()

def initialization( self ):
  pass
  
def execution( self, context ):
  context.write( 'Sample process for project brainvisa-cmake_tutorial' )

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

from __future__ import print_function

import unittest
import sys

from brainvisa.maker.path import Path, SystemPathConverter

#-------------------------------------------------------------------------------
# Main functions
#-------------------------------------------------------------------------------
def execute_tests(argv):
    """ Function to execute unitest
    """
   
    loader = unittest.TestLoader()
    suite = loader.loadTestsFromTestCase(PathTestCases)
    runtime = unittest.TextTestRunner(verbosity=2).run(suite)
    return runtime.wasSuccessful()

def main(argv):
    """ Main function
    """
    ret = execute_tests(sys.argv[1:])
    print("RETURNCODE: ", ret)
    return 0 if ret else 1

#-------------------------------------------------------------------------------
# Path test cases
#-------------------------------------------------------------------------------
class PathTestCases(unittest.TestCase):
    
    def test_path(self):
        #print('{:-^80}'.format(' Path object tests '))
        
        p1 = Path('/dir1/dir2/file')
        p2 = Path('/dir1/dir2/file', 'msys')
        
        # Check constructor from tuple
        self.assertEqual(p1, Path(('/dir1/dir2/file', 'linux')))
        
        # Check constructor from dict
        self.assertEqual(p2, Path({'path':'/dir1/dir2/file', 
                                   'system':'msys'}))
        
        # Check copy constructor
        self.assertEqual(p2, Path(p2))

        self.assertNotEqual(p1, p2)
        
        # Check string conversion
        self.assertEqual(str(p1), '/dir1/dir2/file')
        self.assertEqual(str(p2), '/dir1/dir2/file')
        
        # Check repr
        self.assertEqual(repr(p1), str(('/dir1/dir2/file', 'linux')))
        self.assertEqual(repr(p2), str(('/dir1/dir2/file', 'msys')))
        
    def test_path_copy_ctr(self):
        # Check conversion
        # TO GENERATE tests, uncomment following code:
        #for p in (('/dir1/dir2/file', 'linux'),
                    #('/c/dir1/dir2/file', 'linux'),
                    #('/dir1/dir2/file', 'msys'),
                    #('/c/dir1/dir2/file', 'msys'),
                    #('/dir1/dir2/file', 'windows_alt'),
                    #('c:/dir1/dir2/file', 'windows_alt'),
                    #(r'\dir1\dir2\file', 'windows'),
                    #(r'c:\dir1\dir2\file', 'windows'),
                    #('file:///dir1/dir2/file', 'uri'),
                    #('file:///c:/dir1/dir2/file', 'uri')):
            #for s in ('linux', 'msys', 'windows_alt', 'windows', 'uri'):
                ##p = Path(p)
                ##print(repr(p), '=>', s, ':', repr(Path(p, s)))
                #try:
                    #r = Path(p,s)
                    #print('        self.assertEqual(Path(%s,%s), \n'
                          #'%sPath(%s, %s))' 
                          #% (str(p), repr(s), ' ' * 25, repr(str(r)), repr(s)))
                #except:
                    #print('        with self.assertRaises(RuntimeError):')
                    #print('            Path(%s,%s)' % (repr(p), repr(s)))
             
        self.assertEqual(Path(('/dir1/dir2/file', 'linux'),'linux'), 
                         Path('/dir1/dir2/file', 'linux'))
        with self.assertRaises(RuntimeError):
            Path(('/dir1/dir2/file', 'linux'),'msys')
        with self.assertRaises(RuntimeError):
            Path(('/dir1/dir2/file', 'linux'),'windows_alt')
        with self.assertRaises(RuntimeError):
            Path(('/dir1/dir2/file', 'linux'),'windows')
        self.assertEqual(Path(('/dir1/dir2/file', 'linux'),'uri'), 
                         Path('file:///dir1/dir2/file', 'uri'))
        self.assertEqual(Path(('/c/dir1/dir2/file', 'linux'),'linux'), 
                         Path('/c/dir1/dir2/file', 'linux'))
        with self.assertRaises(RuntimeError):
            Path(('/c/dir1/dir2/file', 'linux'),'msys')
        with self.assertRaises(RuntimeError):
            Path(('/c/dir1/dir2/file', 'linux'),'windows_alt')
        with self.assertRaises(RuntimeError):
            Path(('/c/dir1/dir2/file', 'linux'),'windows')
        self.assertEqual(Path(('/c/dir1/dir2/file', 'linux'),'uri'), 
                         Path('file:///c/dir1/dir2/file', 'uri'))
        with self.assertRaises(RuntimeError):
            Path(('/dir1/dir2/file', 'msys'),'linux')
        self.assertEqual(Path(('/dir1/dir2/file', 'msys'),'msys'), 
                         Path('/dir1/dir2/file', 'msys'))
        self.assertEqual(Path(('/dir1/dir2/file', 'msys'),'windows_alt'), 
                         Path('/dir1/dir2/file', 'windows_alt'))
        self.assertEqual(Path(('/dir1/dir2/file', 'msys'),'windows'), 
                         Path('\\dir1\\dir2\\file', 'windows'))
        self.assertEqual(Path(('/dir1/dir2/file', 'msys'),'uri'), 
                         Path('file:////dir1/dir2/file', 'uri'))
        with self.assertRaises(RuntimeError):
            Path(('/c/dir1/dir2/file', 'msys'),'linux')
        self.assertEqual(Path(('/c/dir1/dir2/file', 'msys'),'msys'), 
                         Path('/c/dir1/dir2/file', 'msys'))
        self.assertEqual(Path(('/c/dir1/dir2/file', 'msys'),'windows_alt'), 
                         Path('c:/dir1/dir2/file', 'windows_alt'))
        self.assertEqual(Path(('/c/dir1/dir2/file', 'msys'),'windows'), 
                         Path('c:\\dir1\\dir2\\file', 'windows'))
        self.assertEqual(Path(('/c/dir1/dir2/file', 'msys'),'uri'), 
                         Path('file:///c:/dir1/dir2/file', 'uri'))
        with self.assertRaises(RuntimeError):
            Path(('/dir1/dir2/file', 'windows_alt'),'linux')
        self.assertEqual(Path(('/dir1/dir2/file', 'windows_alt'),'msys'), 
                         Path('/dir1/dir2/file', 'msys'))
        self.assertEqual(Path(('/dir1/dir2/file', 'windows_alt'),'windows_alt'), 
                         Path('/dir1/dir2/file', 'windows_alt'))
        self.assertEqual(Path(('/dir1/dir2/file', 'windows_alt'),'windows'), 
                         Path('\\dir1\\dir2\\file', 'windows'))
        self.assertEqual(Path(('/dir1/dir2/file', 'windows_alt'),'uri'), 
                         Path('file:////dir1/dir2/file', 'uri'))
        with self.assertRaises(RuntimeError):
            Path(('c:/dir1/dir2/file', 'windows_alt'),'linux')
        self.assertEqual(Path(('c:/dir1/dir2/file', 'windows_alt'),'msys'), 
                         Path('/c/dir1/dir2/file', 'msys'))
        self.assertEqual(Path(('c:/dir1/dir2/file', 'windows_alt'),
                               'windows_alt'), 
                         Path('c:/dir1/dir2/file', 'windows_alt'))
        self.assertEqual(Path(('c:/dir1/dir2/file', 'windows_alt'),'windows'), 
                         Path('c:\\dir1\\dir2\\file', 'windows'))
        self.assertEqual(Path(('c:/dir1/dir2/file', 'windows_alt'),'uri'), 
                         Path('file:///c:/dir1/dir2/file', 'uri'))
        with self.assertRaises(RuntimeError):
            Path(('\\dir1\\dir2\\file', 'windows'),'linux')
        self.assertEqual(Path(('\\dir1\\dir2\\file', 'windows'),'msys'), 
                         Path('/dir1/dir2/file', 'msys'))
        self.assertEqual(Path(('\\dir1\\dir2\\file', 'windows'),
                               'windows_alt'), 
                         Path('/dir1/dir2/file', 'windows_alt'))
        self.assertEqual(Path(('\\dir1\\dir2\\file', 'windows'),'windows'), 
                         Path('\\dir1\\dir2\\file', 'windows'))
        self.assertEqual(Path(('\\dir1\\dir2\\file', 'windows'),'uri'), 
                         Path('file:////dir1/dir2/file', 'uri'))
        with self.assertRaises(RuntimeError):
            Path(('c:\\dir1\\dir2\\file', 'windows'),'linux')
        self.assertEqual(Path(('c:\\dir1\\dir2\\file', 'windows'),'msys'), 
                         Path('/c/dir1/dir2/file', 'msys'))
        self.assertEqual(Path(('c:\\dir1\\dir2\\file', 'windows'),
                               'windows_alt'), 
                         Path('c:/dir1/dir2/file', 'windows_alt'))
        self.assertEqual(Path(('c:\\dir1\\dir2\\file', 'windows'),'windows'), 
                         Path('c:\\dir1\\dir2\\file', 'windows'))
        self.assertEqual(Path(('c:\\dir1\\dir2\\file', 'windows'),'uri'), 
                         Path('file:///c:/dir1/dir2/file', 'uri'))
        self.assertEqual(Path(('file:///dir1/dir2/file', 'uri'),'linux'), 
                         Path('/dir1/dir2/file', 'linux'))
        self.assertEqual(Path(('file:///dir1/dir2/file', 'uri'),'msys'), 
                         Path('dir1/dir2/file', 'msys'))
        self.assertEqual(Path(('file:///dir1/dir2/file', 'uri'),'windows_alt'), 
                         Path('dir1/dir2/file', 'windows_alt'))
        self.assertEqual(Path(('file:///dir1/dir2/file', 'uri'),'windows'), 
                         Path('dir1\\dir2\\file', 'windows'))
        self.assertEqual(Path(('file:///dir1/dir2/file', 'uri'),'uri'), 
                         Path('file:///dir1/dir2/file', 'uri'))
        self.assertEqual(Path(('file:///c:/dir1/dir2/file', 'uri'),'linux'), 
                         Path('/c:/dir1/dir2/file', 'linux'))
        self.assertEqual(Path(('file:///c:/dir1/dir2/file', 'uri'),'msys'), 
                         Path('/c/dir1/dir2/file', 'msys'))
        self.assertEqual(Path(('file:///c:/dir1/dir2/file', 'uri'),
                               'windows_alt'), 
                         Path('c:/dir1/dir2/file', 'windows_alt'))
        self.assertEqual(Path(('file:///c:/dir1/dir2/file', 'uri'),'windows'), 
                         Path('c:\\dir1\\dir2\\file', 'windows'))
        self.assertEqual(Path(('file:///c:/dir1/dir2/file', 'uri'),'uri'), 
                         Path('file:///c:/dir1/dir2/file', 'uri'))

    def test_wine_path_conversion(self):
        # Try to find winepath command
        from distutils.spawn import find_executable
        w = find_executable('winepath')
        if not w:
            print('winepath command not found, skipping test', '...', end = ' ')
            sys.stdout.flush()
            return
        
        print('winepath command found', '...', end = ' ')
        sys.stdout.flush()
        
        # Add windows path converter to linux using wine
        SystemPathConverter('windows', 'linux', [w, '-u'])

        # Add linux path converter to windows using wine
        SystemPathConverter('linux', 'windows', [w, '-w'])
        
        # Get root path wine installation prefix
        wine_z = str(Path('z:\\','windows').to_system('linux'))
        wine_c = str(Path('c:\\','windows').to_system('linux'))

        self.assertEqual(
            Path('/dir1/dir2/file','linux').to_system('msys'), 
            Path('/Z/dir1/dir2/file', 'msys'))
        self.assertEqual(
            Path('/dir1/dir2/file','linux').to_system('windows_alt'), 
            Path('Z:/dir1/dir2/file', 'windows_alt'))
        self.assertEqual(
            Path('/dir1/dir2/file','linux').to_system('windows'), 
            Path('Z:\\dir1\\dir2\\file', 'windows'))
        self.assertEqual(
            Path('/c/dir1/dir2/file','linux').to_system('msys'), 
            Path('/Z/c/dir1/dir2/file', 'msys'))
        self.assertEqual(
            Path('/c/dir1/dir2/file','linux').to_system('windows_alt'), 
            Path('Z:/c/dir1/dir2/file', 'windows_alt'))
        self.assertEqual(
            Path('/c/dir1/dir2/file','linux').to_system('windows'), 
            Path('Z:\\c\\dir1\\dir2\\file', 'windows'))
        self.assertEqual(
            Path('/dir1/dir2/file','msys').to_system('linux'),
            Path('%sdir1/dir2/file' % wine_z, 'linux'))
        self.assertEqual(
            Path('/c/dir1/dir2/file','msys').to_system('linux'), 
            Path('%sdir1/dir2/file' % wine_c, 'linux'))
        self.assertEqual(
            Path('/dir1/dir2/file','windows_alt').to_system('linux'),
            Path('%sdir1/dir2/file' % wine_z, 'linux'))
        self.assertEqual(
            Path('c:/dir1/dir2/file','windows_alt').to_system('linux'), 
            Path('%sdir1/dir2/file' % wine_c, 'linux'))
        self.assertEqual(
            Path('\\dir1\\dir2\\file','windows').to_system('linux'),
            Path('%sdir1/dir2/file' % wine_z, 'linux'))
        self.assertEqual(
            Path('c:\\dir1\\dir2\\file','windows').to_system('linux'),
            Path('%sdir1/dir2/file' % wine_c, 'linux'))

if __name__ == "__main__":
    sys.exit(main(sys.argv))
   

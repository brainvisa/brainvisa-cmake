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

import sys

pyqt_ver = 4

if len(sys.argv) >= 2:
  pyqt_ver = int(sys.argv[1])

if pyqt_ver == 5:
    import os
    import PyQt5.QtCore

    print("pyqt_version:%06.0x" % PyQt5.QtCore.PYQT_VERSION)
    print("pyqt_version_str:%s" % PyQt5.QtCore.PYQT_VERSION_STR)

    pyqtcfg = PyQt5.QtCore.PYQT_CONFIGURATION
    pyqt_version_tag = ""
    in_t = False
    for item in pyqtcfg["sip_flags"].split(' '):
        if item=="-t":
            in_t = True
        elif in_t:
            if item.startswith("Qt_5"):
                pyqt_version_tag = item
        else:
            in_t = False
    print("pyqt_version_tag:%s" % pyqt_version_tag)

    # finding .sip files location seems not obvioous with PyQt5.
    sip_dir = "/usr/share/sip/PyQt5"
    if not os.path.isdir(sip_dir):
        # Trying a trick with PyQt4
        try:
            import PyQt4.pyqtconfig

            pyqtcfg = PyQt4.pyqtconfig.Configuration()
            sip4_dir = pyqtcfg.pyqt_sip_dir
            sip_dir = os.path.join(os.path.dirname(sip4_dir, "PyQt5"))
        except:
            pass

    print("pyqt_sip_dir:%s" % sip_dir)
    print("pyqt_sip_flags:%s" % pyqtcfg["sip_flags"])

elif pyqt_ver == 4:
    import PyQt4.pyqtconfig

    pyqtcfg = PyQt4.pyqtconfig.Configuration()
    print("pyqt_version:%06.0x" % pyqtcfg.pyqt_version)
    print("pyqt_version_str:%s" % pyqtcfg.pyqt_version_str)

    pyqt_version_tag = ""
    in_t = False
    for item in pyqtcfg.pyqt_sip_flags.split(' '):
        if item=="-t":
            in_t = True
        elif in_t:
            if item.startswith("Qt_4"):
                pyqt_version_tag = item
        else:
            in_t = False
    print("pyqt_version_tag:%s" % pyqt_version_tag)

    print("pyqt_sip_dir:%s" % pyqtcfg.pyqt_sip_dir)
    print("pyqt_sip_flags:%s" % pyqtcfg.pyqt_sip_flags)


# This script comes from kdelibs's git repository at https://quickgit.kde.org/
# under [kdelibs.git]/cmake/modules/FindPyQt.py
#
# Copyright (c) 2007, Simon Edwards <simon@simonzone.com>
# Copyright (c) 2014, Raphael Kubo da Costa <rakuco@FreeBSD.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


from __future__ import print_function

import sys
import os

pyqt_ver = 4


def get_default_sip_dir():
    import sipconfig

    c = sipconfig.Configuration()
    pyqt_sip_dir = os.path.join(c.default_sip_dir, 'PyQt%d' % pyqt_ver)
    if os.path.isdir(pyqt_sip_dir):
        return pyqt_sip_dir
    # try another shape (as on Mac/homebrew)
    pyqt_sip_dir = os.path.join(c.default_sip_dir, 'Qt%d' % pyqt_ver)
    if os.path.isdir(pyqt_sip_dir):
        return pyqt_sip_dir
    return c.default_sip_dir

def get_qt_tag(sip_flags):
    in_t = False
    for item in sip_flags.split(' '):
        if item == '-t':
            in_t = True
        elif in_t:
            if item.startswith('Qt_4') or item.startswith('Qt_5'):
                return item
        else:
            in_t = False
    raise ValueError('Cannot find Qt\'s tag in PyQt\'s SIP flags.')

if __name__ == '__main__':
    if len(sys.argv) >= 2:
        pyqt_ver = int(sys.argv[1])

    if pyqt_ver == 5:
        from PyQt5 import QtCore

    else:
        from PyQt4 import QtCore

    if pyqt_ver == 5:
        sip_dir = get_default_sip_dir()
        sip_flags = QtCore.PYQT_CONFIGURATION['sip_flags']

    else:
        try:
            import PyQt4.pyqtconfig
            pyqtcfg = PyQt4.pyqtconfig.Configuration()
            sip_dir = pyqtcfg.pyqt_sip_dir
            sip_flags = pyqtcfg.pyqt_sip_flags
        except ImportError:
            # PyQt4 >= 4.10.0 was built with configure-ng.py instead of
            # configure.py, so pyqtconfig.py is not installed.
            # same method as for Qt5
            sip_dir = get_default_sip_dir()
            sip_flags = QtCore.PYQT_CONFIGURATION['sip_flags']

    print('pyqt_version:%06.x' % QtCore.PYQT_VERSION)
    print('pyqt_version_str:%s' % QtCore.PYQT_VERSION_STR)
    print('pyqt_version_tag:%s' % get_qt_tag(sip_flags))
    print('pyqt_sip_dir:%s' % sip_dir)
    print('pyqt_sip_flags:%s' % sip_flags)


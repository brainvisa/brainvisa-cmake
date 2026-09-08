import sys
import importlib
import re
import os

# found in https://github.com/kovidgoyal/calibre/commit/73a312dd648143006184ed71a0aab7336dc03cc1#diff-74e67b94edb27c8f348abd003df82f462d963c11c9ba0a786d7e73f1f7f9ae24
def pyqt_sip_abi_version(pyqt_mod):
    pyqt = importlib.import_module(pyqt_mod)
    if getattr(pyqt, '__file__', None):
        bindings_path = os.path.join(os.path.dirname(pyqt.__file__),
                                     'bindings', 'QtCore', 'QtCore.toml')
        if os.path.exists(bindings_path):
            with open(bindings_path) as f:
                raw = f.read()
                m = re.search(r'^sip-abi-version\s*=\s*"(.+?)"', raw,
                              flags=re.MULTILINE)
                if m is not None:
                    return m.group(1)

sip_mod = sys.argv[1]
#sip = importlib.import_module(sip_mod)
pyqt_mod = sip_mod.rsplit('.', 1)[0]

print(pyqt_sip_abi_version(pyqt_mod), end='')

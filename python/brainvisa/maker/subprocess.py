# -*- coding: utf-8 -*-
"""Tools for launching subprocesses from bv_maker."""

from __future__ import absolute_import, division
from __future__ import print_function, unicode_literals

import locale
import os
import subprocess
import sys

import six
from six.moves import shlex_quote


try:
    from subprocess import DEVNULL
except ImportError:
    DEVNULL = open(os.devnull, 'wb')

try:
    # backport of subprocess of python 3
    import subprocess32
except ImportError:
    subprocess32 = None


def decode_output(output_bytes):
    """Decode the output of subprocess.check_output to Unicode."""
    return output_bytes.decode(locale.getpreferredencoding())


def system(*args, **kwargs):
    print('$ ' + ' '.join(shlex_quote(arg) for arg in args))
    error = None
    try:
        try:
            kwargs = dict(kwargs)
            timeout = kwargs.pop('timeout', None)
            if subprocess32 is not None:
                popen = subprocess32.Popen(args, **kwargs)
                popen.communicate(timeout=timeout)
            else:
                # timeout not supported in python2.subprocess
                popen = subprocess.Popen(args, **kwargs)
                popen.communicate()
            if popen.returncode != 0:
                raise OSError()
        except Exception as e:
            error = (type(e), e, sys.exc_info()[2])
    finally:
        if error:
            txt = 'Command failed: %s' % ' '.join((repr(i) for i in args))
            if 'cwd' in kwargs:
                txt = '%s\nFrom directory: %s' % (txt, kwargs['cwd'])
            if error[1].args:
                txt += '\n%s' % error[1].args[0]
            error = (error[0], error[0](txt, *error[1].args[1:]), error[2])
            six.reraise(*error)


def system_output_on_error(*args, **kwargs):
    # system_output_on_error is a bit strange currently:
    # on error an exception is raised and the output value is not passed
    # to the caller. Only stdout is used in this case, when the output
    # strings is actally useful in this situation.
    # However it should be in the exception e.output
    echo = kwargs.pop('echo', True)
    if echo:
        print(' '.join([str(x) for x in args]))
    try:
        if subprocess32 is not None:
            # !!! Redirecting STDERR to STDOUT is a burden on Windows OS and
            # lead to enormous processing times using "wine" (x80) ... I do not
            # know why.
            # The issue can be reproduced using commands:
            # time python -c 'import subprocess;print subprocess.check_output(["winepath", "-u", "c:\\"]).strip()'
            # time python -c 'import subprocess;print subprocess.check_output(["winepath", "-u", "c:\\"], stderr=subprocess.STDOUT).strip()'
            output = subprocess32.check_output(*args, stderr=subprocess.STDOUT,
                                               **kwargs)
        else:
            if 'timeout' in kwargs:
                # timeout not supported in python2.subprocess
                kwargs = dict(kwargs)
                del kwargs['timeout']
            output = subprocess.check_output(*args, stderr=subprocess.STDOUT,
                                             **kwargs)
    except subprocess.CalledProcessError as e:
        print('-- failed command: --')
        print('-- command:', args)
        print('-- popen kwargs:', kwargs)
        print('-- return code: %d, output: --' % e.returncode)
        print(e.output)
        print('-- end of command outpput --')
        raise

    if sys.version_info[0] >= 3:
        output = output.decode()

    return output

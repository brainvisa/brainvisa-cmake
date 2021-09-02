# -*- coding: utf-8 -*-

"""Support code for sub-commands of bv_maker."""

from __future__ import absolute_import, division
from __future__ import print_function, unicode_literals

import io
import os
import platform
import re
from smtplib import SMTP
from socket import gethostname
import sys
import tempfile
import time
import traceback

import six

from brainvisa.maker.environment import normalize_path


IGNORED_STEP = 'ignored'


class StepCommand(object):

    def __init__(self, argv, configuration):
        # Initialize python variables that can override directories
        # python variables
        super(StepCommand, self).__init__()
        self.configuration = configuration
        self.python_vars = {}

    def process(self, step, directories_list, method, *meth_args,
                **meth_kwargs):
        for o in directories_list:
            # Update directory python variables by those coming from the command
            # line (package date and version)
            o.update_python_vars(self.python_vars)
            # Python variables update need to reprocess environment variables
            o.reset_environ()

            # Get the new directory value
            d = o.directory
            normalize_path_needed = 'directory' in \
                getattr(o, '_path_variables', set())

            # Resolve directories pattern using configuration directory
            # variables
            conf_dirs = [normalize_path(o.replace_vars(c)) \
                         if normalize_path_needed else o.replace_vars(c) \
                         for c in self.configuration.directories] \
                        if self.configuration.directories else []

            if (not conf_dirs or d in conf_dirs) and o.conditional_build():
                if (not self.options.in_config
                    and not self.configuration.options.in_config) \
                        or step in o.default_steps:
                    if o.has_satisfied_dependencies(step):
                        self.redirect_stdout(d, o, step)
                        logs = None
                        try:
                            logs = getattr(o, method)(*meth_args,
                                                      **meth_kwargs)
                            if not logs:
                                o.status[step] = 'succeeded' # mark as done
                        except KeyboardInterrupt:
                            # record failure
                            o.status[step] = 'interrupted'
                            o.stop_time[step] = time.localtime()
                            # user interruptions should stop all.
                            raise
                        except Exception:
                            traceback.print_exc()
                            # record failure
                            o.status[step] = 'failed'
                        if logs:
                            if logs == IGNORED_STEP:
                                # step did nothing and should be ignored
                                o.status[step] = 'not run'
                                self.release_stdout(o)
                                continue
                            o.stop_time[step] = time.localtime()
                            o.status[step] = 'succeeded'
                            for label, item in six.iteritems(logs):
                                log = item['log_file']
                                exc = item['exception']
                                full_step = '%s:%s' % (step, label)
                                o.start_time[full_step] = item['start_time']
                                o.stop_time[full_step] = item['stop_time']
                                if exc is None:
                                    o.status[full_step] = 'succeeded'
                                elif isinstance(exc, KeyboardInterrupt):
                                    o.status[full_step] = 'interrupted'
                                    if o.status[step] != 'failed':
                                        o.status[step] = 'interrupted'
                                else:
                                    o.status[full_step] = 'failed'
                                    o.status[step] = 'failed'
                                self.release_notify_log(d, o, step, label, log,
                                                        exc)
                        else:
                            self.release_notify_stdout(d, o, step)
                    else:
                        print('Skipping', step, 'of', d,
                              'because it depends on a step that failed.')
            elif self.configuration.verbose:
                print('Skipping', step, 'of', d,
                      'because it is not in the selected directories.')


    def redirect_stdout(self, d, o, step):
        o.start_time[step] = time.localtime()
        if self.configuration.general_section is None:
            return
        if ((self.configuration.general_section.email_notification_by_default. \
                upper() != 'ON' and not self.configuration.options.email) \
                or (self.configuration.general_section.failure_email == ''
                    and self.configuration.general_section.success_email == ''
                    and self.configuration.general_section.failure_email_by_project
                        == {})):
            return
        if o.stdout_file or o.stderr_file:
            # Line buffering is used (buffering=1) because the output from
            # bv_maker needs to be interspersed correctly with the output of
            # external commands called through subprocess.
            if o.stdout_file:
                self.tmp_stdout = open(o.stdout_file, 'w', buffering=1)
                if o.stderr_file:
                    self.tmp_stderr = open(o.stderr_file, 'w', buffering=1)
                else:
                    self.tmp_stderr = self.tmp_stdout
            else:
                self.tmp_stdout = open(o.stderr_file, 'w', buffering=1)
                self.tmp_stderr = self.tmp_stdout
        else:
            tmp_stdout = tempfile.mkstemp(prefix='buildout_')
            os.close(tmp_stdout[0])
            print('redirecting outputs to temporary file:', tmp_stdout[1])
            sys.stdout.flush()
            sys.stderr.flush()
            self.tmp_stdout = open(tmp_stdout[1], 'w', buffering=1)
            self.tmp_stderr = self.tmp_stdout
        self.orig_stdout = os.dup(sys.stdout.fileno())
        self.orig_stderr = os.dup(sys.stderr.fileno())
        os.dup2(self.tmp_stdout.fileno(), 1)
        os.dup2(self.tmp_stderr.fileno(), 2)

    def release_notify_stdout(self, d, o, step):
        o.stop_time[step] = time.localtime()
        fix_stdout = False
        if hasattr(self, 'orig_stdout'):
            fix_stdout = True
            os.dup2(self.orig_stdout, 1)
            os.dup2(self.orig_stderr, 2)
            self.tmp_stdout.close()
            if self.tmp_stderr is not self.tmp_stdout:
                self.tmp_stderr.close()
        self.notify_log(d, o, step)
        if fix_stdout:
            del self.orig_stderr
            del self.orig_stdout
            if not o.stdout_file:
                os.unlink(self.tmp_stdout.name)
            # tmp_stderr is never removed: either it is specified as a
            # persistant file or it is tmp_stdout.
            del self.tmp_stdout
            del self.tmp_stderr

    def release_stdout(self, o):
        if not hasattr(self, 'orig_stdout'):
            return
        os.dup2(self.orig_stdout, 1)
        os.dup2(self.orig_stderr, 2)
        self.tmp_stdout.close()
        if self.tmp_stderr is not self.tmp_stdout:
            self.tmp_stderr.close()
        del self.orig_stderr
        del self.orig_stdout
        if not o.stdout_file:
            os.unlink(self.tmp_stdout.name)
        # tmp_stderr is never removed: either it is specified as a persistant
        # file or it is tmp_stdout.
        del self.tmp_stdout
        del self.tmp_stderr

    def release_notify_log(self, d, o, step, label, log, exc):
        self.release_stdout(o)
        self.tmp_stdout = open(log)
        self.tmp_stdout.close()
        self.tmp_stderr = self.tmp_stdout
        full_step = '%s:%s' % (step, label)
        if exc is None:
            o.status[full_step] = 'succeeded'
        elif isinstance(exc, KeyboardInterrupt):
            o.status[full_step] = 'interrupted'
        else:
            o.status[full_step] = 'failed'
        self.notify_log(d, o, full_step)
        del self.tmp_stdout
        os.unlink(log)

    def notify_log(self, d, o, step):
        status =  o.status.get(step, 'not run')
        # global log file notification
        self.log_in_global_log_file(d, o, step, status)
        # email notification
        email = ''
        if self.configuration.general_section.email_notification_by_default.upper() \
                == 'ON' or self.configuration.options.email:
            if status in ('failed', 'interrupted'):
                email = self.configuration.general_section.failure_email
                if self.configuration.general_section.failure_email_by_project:
                    project = step.split(':')[-1]
                    if project in  self.configuration.general_section. \
                            failure_email_by_project:
                        email = self.configuration.general_section. \
                            failure_email_by_project[project]
            elif status == 'succeeded':
                email = self.configuration.general_section.success_email
        if email:
            try:
                self.send_log_email(email, d, o, step, status)
            except Exception as e:
                print('WARNING: notification email could not be sent:',
                      e.message)
                traceback.print_exc()
        # console notification
        if email and status in ('failed', 'interrupted'):
            # original stdout has been changed, we need to print again
            print(self.message_header(d, o, step, status))
            print(self.log_message_content())

    def message_header(self, d, o, step, status):
        real_dir = o.replace_vars(d)
        dlen = max((len(step), len(status), len(real_dir)))
        if hasattr(o, 'get_environ'):
            env = o.get_environ()
        else:
            env = os.environ
        start_time = '%04d/%02d/%02d %02d:%02d' % o.start_time[step][:5]
        stop_time = '%04d/%02d/%02d %02d:%02d' % o.stop_time[step][:5]
        message = '''\
=========================================
== directory: %s%s ==
== step:      %s%s ==
== status:    %s%s ==
== started:   %s%s ==
== stopped:   %s%s ==
=========================================

--- environment: ---
''' % (real_dir, ' ' * (dlen - len(real_dir)),
            step, ' ' * (dlen - len(step)),
            status, ' ' * (dlen - len(status)),
            start_time, ' ' * (dlen - len(start_time)),
            stop_time, ' ' * (dlen - len(stop_time)))
        message += '\n'.join(['%s=%s' % (var, env[var])
                              for var in sorted(env.keys())])
        message += '\n------------------------------------------\n\n'

        return message

    def send_log_email(self, email, d, o, step, status):
        if self.configuration.general_section.from_email == '':
            from_address = '%s-%s@intra.cea.fr' \
                % (os.getenv('USER'), gethostname())
        else:
            from_address = self.configuration.general_section.from_email
        if self.configuration.general_section.reply_to_email == '':
            reply_to_address = 'appli@saxifrage.saclay.cea.fr'
        else:
            reply_to_address = self.configuration.general_section.reply_to_email
        to_address = email

        # header
        machine = gethostname()
        osname = platform.platform()
        Status = status[0].upper() + status[1:]
        message = '''MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Reply-To: %s
Subject: %s - %s %s on %s (%s)

%s - build started %s, stopped %s on %s (%s)

''' % (reply_to_address, Status, step,
            '%04d/%02d/%02d' % o.start_time[step][:3],
            machine, osname, Status,
            '%04d/%02d/%02d %02d:%02d' % o.start_time[step][:5],
            '%04d/%02d/%02d %02d:%02d' % o.stop_time[step][:5], machine,
            osname)

        message += self.message_header(d, o, step, status)
        message += self.log_message_content()

        # Normalize all end-of-lines to use CRLF as required in Internet
        # messages (taken from smtplib).
        message = re.sub(r'(?:\r\n|\n|\r(?!\n))', '\r\n', message)

        if self.configuration.general_section.smtp_server != '':
            smtp_server = self.configuration.general_section.smtp_server
        else:
            smtp_server = 'mx.intra.cea.fr'
        server = SMTP(smtp_server)
        server.sendmail(from_address, to_address, message.encode('utf-8'))
        server.quit()

    def log_message_content(self):
        if self.tmp_stderr is not self.tmp_stdout:
            message = '====== standard output ======\n\n'
        else:
            message = '====== output ======\n\n'
        # Read message from file
        with io.open(self.tmp_stdout.name, mode='rt', errors='replace',
                     newline='') as file:
            message += file.read()
        if self.tmp_stderr is not self.tmp_stdout:
            message += '====== standard error ======\n\n'
            with io.open(self.tmp_stderr.name, mode='rt', errors='replace',
                         newline='') as file:
                message += file.read()
        return message

    def log_in_global_log_file(self, d, o, step, status):
        # print('log_in_global_log_file', step, status)
        if status == 'not run':
            return # don't log non-running steps
        log_file = None
        if self.configuration.general_section \
                and self.configuration.general_section.global_status_file:
            log_file = self.configuration.general_section.global_status_file
        if not log_file:
            return

        status = status.upper()
        if status == 'SUCCEEDED':
            status = 'OK' # we used OK, so let's go on
        machine = gethostname()
        osname = platform.platform()

        message = '%s step %s: %s' % (status, step, d)
        start = o.start_time.get(step)
        if start:
            message += ', started: %04d/%02d/%02d %02d:%02d' \
                % start[:5]
        stop = o.stop_time.get(step)
        if stop:
            message += ', stopped: %04d/%02d/%02d %02d:%02d' \
                % stop[:5]
        with open(log_file, 'a') as f:
            f.write('%s on %s (%s)\n' % (message, machine, osname))

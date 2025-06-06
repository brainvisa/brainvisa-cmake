#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import os.path as osp
import getpass
import socket
import sys
import subprocess
import locale
import shlex
import time
import re
import json
import traceback
import shutil
import yaml
import glob
import pathlib


def ensure_str(arg, encoding='utf-8', errors='stric'):
    if isinstance(arg, bytes):
        return arg.decode(encoding=encoding, errors=errors)
    return arg


class BBIDaily:
    NONFATAL_BV_MAKER_STEPS = {'doc', 'test'}
    """bv_maker steps whose failure still allows to proceed to further testing."""

    def __init__(self, base_directory, jenkins=None):
        # This environment variable must be set by the caller of BBIDaily, to
        # ensure that all recursively called instances of casa_distro will use
        # the correct base_directory.
        assert os.environ['CASA_BASE_DIRECTORY'] == base_directory
        self.bbe_name = f'BBE-{getpass.getuser()}-{socket.gethostname()}'
        self.bv_cmake_src = osp.dirname(osp.dirname(
            osp.dirname(__file__)))
        runpixi = osp.join(osp.dirname(osp.realpath(sys.argv[0])),
                           'bv_run_pixi_env.py')
        if not osp.exists(runpixi):
            runpixi = osp.join(
                osp.dirname(osp.dirname(osp.dirname(osp.realpath(__file__)))),
                'bin', 'bv_run_pixi_env.py')
        self.casa_distro_cmd = [sys.executable, runpixi]
        self.casa_distro_cmd_env = {'cwd': base_directory}
        self.jenkins = jenkins
        if self.jenkins and not self.jenkins.job_exists(self.bbe_name):
            self.jenkins.create_job(self.bbe_name)
        self.env_prefix = '{environment_dir}'
        self.packaging_done = False

    def log(self, environment, task_name, result, log,
            duration=None):
        if self.jenkins:
            self.jenkins.create_build(environment=environment,
                                      task=task_name,
                                      result=result,
                                      log=log+'\n',
                                      duration=duration)
        else:
            name = f'{environment}:{task_name}'
            print()
            print('  /-' + '-' * len(name) + '-/')
            print(' / ' + name + ' /')
            print('/-' + '-' * len(name) + '-/')
            print()
            print(log)

    def call_output(self, args, **kwargs):
        if self.casa_distro_cmd_env:
            kwargs2 = dict(self.casa_distro_cmd_env)
            kwargs2.update(kwargs)
            kwargs = kwargs2
        p = subprocess.Popen(args, stdout=subprocess.PIPE,
                             stderr=subprocess.STDOUT, bufsize=-1,
                             **kwargs)
        output, nothing = p.communicate()
        if isinstance(output, bytes):
            output = output.decode(encoding=locale.getpreferredencoding(),
                                   errors='backslashreplace')
        log = ['-'*40,
               '$ ' + ' '.join(shlex.quote(ensure_str(arg))
                               for arg in args),
               '-'*40,
               output]

        return p.returncode, '\n'.join(log)

    def update_brainvisa_cmake(self, config=None):
        if config is None:
            bvdir = self.bv_cmake_src
        else:
            env_dir = self.env_prefix.format(
                environment_dir=config['directory'])
            bvdir = osp.join(env_dir, 'src', 'brainvisa-cmake')
            if bvdir == self.bv_cmake_src or not osp.exists(bvdir):
                return True

        start = time.time()
        result, log = self.call_output(['git', '-C', bvdir, 'pull'])
        duration = int(1000 * (time.time() - start))
        self.log(self.bbe_name, 'update brainvisa-cmake',
                 result, log,
                 duration=duration)
        return result == 0

    def update_soma_env(self, config):
        start = time.time()
        env_dir = self.env_prefix.format(
            environment_dir=config['directory'])
        if osp.exists(osp.join(env_dir, '.git')) \
                and osp.exists(osp.join(env_dir, 'pixi.toml')):
            result, log = self.call_output(['git',
                                            '-C', env_dir,
                                            'pull'])
            msg = f'update soma-env for environment {config["name"]}'
        else:
            msg = f'update soma-env skipped: environment {config["name"]} ' \
                'is not a soma-env directory'
            result = 0
            log = 'nothing to be done done.'
        duration = int(1000 * (time.time() - start))
        self.log(self.bbe_name, msg, result, log, duration=duration)
        return result == 0

    def bv_maker(self, config, steps):
        environment = config['name']
        if self.jenkins and not self.jenkins.job_exists(environment):
            self.jenkins.create_job(environment, **config)
        done = []
        failed = []
        for step in steps:
            start = time.time()
            print('run:', self.casa_distro_cmd + [
                'bv_maker',
                'name={}'.format(config['name']),
                '--',
                step,
            ])
            result, log = self.call_output(self.casa_distro_cmd + [
                'bv_maker',
                'name={}'.format(config['name']),
                '--',
                step,
            ])
            duration = int(1000 * (time.time() - start))
            self.log(environment, step, result, log, duration=duration)
            if result:
                failed.append(step)
                break  # stop on the first failed step
            else:
                done.append(step)
        return (done, failed)

    def tests(self, test_config, dev_config):
        environment = test_config['name']
        if self.jenkins and not self.jenkins.job_exists(environment):
            self.jenkins.create_job(environment, **test_config)
        # get test commands dict, and log it in the test config log (which may
        # be the dev log or the user image log)
        tests = self.get_test_commands(dev_config,
                                       log_config_name=test_config['name'])
        successful_tests = []
        failed_tests = []
        env_dir = self.env_prefix.format(
            environment_dir=test_config['directory'])
        dev_env_dir = dev_config['directory']
        srccmdre = re.compile(r'/casa/host/src/.*/bin/')
        dev_build = osp.join(dev_env_dir, 'build')
        user_root = osp.join(env_dir, '.pixi', 'envs', 'default')
        for test, commands in tests.items():
            log = []
            start = time.time()
            success = True
            for command in commands:
                if test_config['type'] in ('run', 'user'):
                    # replace paths in build dir with install ones
                    if command.startswith(osp.join(dev_env_dir, '')):
                        # should be /path/to/env/.../bin/bv_env_test
                        # we are not using it in conda tests: pixi is
                        # playing this role
                        command = shlex.join(shlex.split(command)[1:])
                    else:
                        command = command.replace('/casa/host/build',
                                                  '/casa/install')
                        # replace paths in sources with install ones
                        command = srccmdre.sub('/casa/install/bin/', command)
                    command = command.replace(dev_build, user_root)
                    command = command.replace(osp.join(dev_env_dir, ''),
                                              osp.join(env_dir, ''))
                result, output = self.call_output(self.casa_distro_cmd + [
                    'run',
                    'name={}'.format(test_config['name']),
                    f'env=BRAINVISA_TEST_RUN_DATA_DIR={env_dir}/tests/test,'
                    f'BRAINVISA_TEST_REF_DATA_DIR={env_dir}/tests/ref',
                    '--',
                    'sh', '-c', command
                ])
                log.extend(('=' * 80, output, '=' * 80))
                if result:
                    success = False
                    if result in (124, 128+9):
                        log.append(f'TIMED OUT (exit code {result})')
                    else:
                        log.append(f'FAILED with exit code {result}')
                else:
                    log.append(f'SUCCESS (exit code {result})')
            duration = int(1000 * (time.time() - start))
            self.log(environment, test, (0 if success else 1),
                     '\n'.join(log), duration=duration)
            if success:
                successful_tests.append(test)
            else:
                failed_tests.append(test)
        if failed_tests:
            self.log(environment, 'tests failed', 1,
                     'The following tests failed: {}'.format(
                         ', '.join(failed_tests)))
        return (successful_tests, failed_tests)

    def get_test_commands(self, config, log_config_name=None):
        '''
        Given the config of a dev environment, return a dictionary
        whose keys are name of a test (i.e. 'axon', 'soma', etc.) and
        values are a list of commands to run to perform the test.
        '''
        env_dir = self.env_prefix.format(
            environment_dir=config['directory'])
        cmd = self.casa_distro_cmd + [
            'run',
            'name={}'.format(config['name']),
            f'cwd={env_dir}/build',
            '--',
            'ctest', '--print-labels'
        ]
        # universal_newlines is the old name to request text-mode (text=True)
        o = subprocess.check_output(cmd, bufsize=-1,
                                    universal_newlines=True)
        labels = [i.strip() for i in o.split('\n')[2:] if i.strip()]
        log_lines = ['$ ' + ' '.join(shlex.quote(arg) for arg in cmd),
                     o, '\n']
        tests = {}
        for label in labels:
            cmd = self.casa_distro_cmd + [
                'run',
                'name={}'.format(config['name']),
                f'cwd={env_dir}/build',
                'env=BRAINVISA_TEST_REMOTE_COMMAND=echo',
                '--',
                'ctest', '-V', '-L',
                f'^{label}$'
            ] + config.get('ctest_options', [])
            p = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE, bufsize=-1,
                                 universal_newlines=True)
            o, stderr = p.communicate()
            log_lines += ['$ ' + ' '.join(shlex.quote(arg) for arg in cmd),
                          o, '\n']
            if p.returncode != 0:
                # We want to hide stderr unless ctest returns a nonzero exit
                # code. In the case of test filtering where no tests are
                # matched (e.g. with ctest_options=['-R', 'dummyfilter']), the
                # annoying message 'No tests were found!!!' is printed to
                # stderr by ctest, but it exits with return code 0.
                sys.stderr.write(stderr)
                log_lines.append('Error in get_test_commands:')
                log_lines.append('get_test_commands command:')
                log_lines.append("'" + "' '".join(cmd) + "'")
                log_lines.append('Error:')
                log_lines.append(stderr)
                self.log(log_config_name, 'get test commands', 0,
                         '\n'.join(log_lines))
                raise RuntimeError('ctest failed with the above error')
            o = o.split('\n')
            # Extract the third line that follows each line containing ': Test
            # command:'
            commands = []
            cis = [i for i in range(len(o)) if ': Test command:' in o[i]]
            for i, ci in enumerate(cis):
                if i < len(cis) - 1:
                    cinext = cis[i+1]
                else:
                    cinext = len(o)
                command = o[ci][o[ci].find(':')+2:].strip()
                command = command[command.find(':')+2:].strip()
                timeout = None
                for j in range(ci+1, cinext):
                    if 'Test timeout' in o[j]:
                        timeout = o[j][o[j].find(':')+2:].strip()
                        timeout = timeout[timeout.find(':')+2:]
                        timeout = float(timeout)
                        break
                if timeout is not None and timeout < 9.999e+06:
                    command = f'timeout -k 10 {timeout} {command}'
                commands.append(command)

            if commands:  # skip empty command lists
                tests[label] = commands
        log_lines += ['Final test dictionary:',
                      json.dumps(tests, indent=4, separators=(',', ': '))]

        if log_config_name is None:
            log_config_name = config['name']
        self.log(log_config_name, 'get test commands', 0, '\n'.join(log_lines))
        return tests

    def build_packages(self, config):
        env_dir = self.env_prefix.format(
            environment_dir=config['directory'])
        if osp.exists(osp.join(env_dir, 'plan')):
            shutil.rmtree(osp.join(env_dir, 'plan'))
        # packaging plan, don't test, don't publish.
        cmd = ['pixi', 'run', '--frozen', 'soma-env', 'packaging-plan',
               '--test', '0']
        log = ['buid packages plan', 'command:', ' '.join(cmd), 'from dir:',
               env_dir]
        environment = config['name']
        self.log(environment, 'buid packages plan', 0,
                 '\n'.join(log), duration=0)
        start = time.time()
        result, output = self.call_output(cmd, cwd=env_dir)
        log = []
        log.append('=' * 80)
        log.append(output)
        log.append('=' * 80)
        success = True
        if result:
            success = False
            if result in (124, 128+9):
                log.append(f'TIMED OUT (exit code {result})')
            else:
                log.append(f'FAILED with exit code {result}')
        else:
            log.append(f'SUCCESS (exit code {result})')

        duration = int(1000 * (time.time() - start))
        self.log(environment, 'packaging', (0 if success else 1),
                 '\n'.join(log), duration=duration)
        if not success:
            self.log(environment, 'packaging failed', 1,
                     'The packaging plan failed.')

        if success:
            # is there anything changed ? If no plan file, nothing left to do.
            if not osp.exists(osp.join(env_dir, 'plan', 'actions.yaml')):
                self.packaging_done = False
                return success

            # pack
            cmd = ['pixi', 'run', '--frozen', 'soma-env', 'apply-plan']
            log = ['buid packages plan', 'command:', ' '.join(cmd),
                   'from dir:', env_dir]
            self.log(environment, 'buid packages', 0,
                     '\n'.join(log), duration=0)
            start = time.time()
            result, output = self.call_output(cmd, cwd=env_dir)
            log = []
            log.append('=' * 80)
            log.append(output)
            log.append('=' * 80)
            success = True
            if result:
                success = False
                if result in (124, 128+9):
                    log.append(f'TIMED OUT (exit code {result})')
                else:
                    log.append(f'FAILED with exit code {result}')
            else:
                log.append(f'SUCCESS (exit code {result})')

            duration = int(1000 * (time.time() - start))
            self.log(environment, 'packaging', (0 if success else 1),
                     '\n'.join(log), duration=duration)
            if not success:
                self.log(environment, 'packaging failed', 1,
                         'The packaging failed.')

            else:

                # index - needed even if the repos is newly created
                cmd = ['pixi', 'run', '--frozen', 'conda', 'index',
                       osp.join(env_dir, 'plan', 'packages')]
                log = ['buid packages index', 'command:', ' '.join(cmd),
                       'from dir:', env_dir]
                self.log(environment, 'buid packages index', 0,
                         '\n'.join(log), duration=0)
                start = time.time()
                result, output = self.call_output(cmd, cwd=env_dir)
                log = []
                log.append('=' * 80)
                log.append(output)
                log.append('=' * 80)
                success = True
                if result:
                    success = False
                    if result in (124, 128+9):
                        log.append(f'TIMED OUT (exit code {result})')
                    else:
                        log.append(f'FAILED with exit code {result}')
                else:
                    log.append(f'SUCCESS (exit code {result})')

                duration = int(1000 * (time.time() - start))
                self.log(environment, 'packaging index',
                         (0 if success else 1),
                         '\n'.join(log), duration=duration)
                if not success:
                    self.log(environment, 'packaging failed', 1,
                             'The packaging failed.')
                else:
                    self.packaging_done = True

        return success

    def read_packages_list(self, dev_config):
        with open(osp.join(dev_config['directory'], 'conf',
                           'soma-env.json')) as f:
            binfo = json.load(f)
        packages = {p: {'version': v} for p, v in binfo['packages'].items()}
        for p, d in packages.items():
            recipe_f = osp.join(dev_config['directory'], 'plan', 'recipes', p,
                                'recipe.yaml')
            if osp.exists(recipe_f):
                with open(recipe_f) as f:
                    recipe = yaml.safe_load(f)
                d['version'] = f'{recipe["package"]["version"]}'
        return packages

    def cleanup_pixi_cache(self, dev_config):
        # make sure the new packages are not stored in the pixi cache,
        # because it could be older ones.
        dev_env_dir = osp.abspath(dev_config['directory'])
        packages = glob.glob(osp.join(dev_env_dir, 'plan/packages/*/*.conda'))
        print('packages:', packages)
        cache_dir = os.environ.get('XDG_CACHE_HOME')
        if cache_dir is None:
            home = pathlib.Path.home()
            cache_dir = str(home / '.cache')
        pixi_cache = osp.join(cache_dir, 'rattler/cache/pkgs')
        for package in packages:
            pack_name = osp.basename(package).split('.conda')[0]
            pack_dir = osp.join(pixi_cache, pack_name)
            if osp.exists(pack_dir):
                print('removing cache:', pack_dir)
                shutil.rmtree(pack_dir)
                if osp.exists(f'{pack_dir}.lock'):
                    os.unlink(f'{pack_dir}.lock')

    def recreate_user_env(self, user_config, dev_config):
        environment = user_config['name']
        if self.jenkins and not self.jenkins.job_exists(environment):
            self.jenkins.create_job(environment, **user_config)
        start = time.time()
        env_dir = user_config['directory']
        dev_env_dir = osp.abspath(dev_config['directory'])
        if os.path.exists(env_dir):
            shutil.rmtree(env_dir)
        os.makedirs(env_dir)
        cmd = ['pixi', 'init', '-c', f'file://{dev_env_dir}/plan/packages',
               # '-c', 'https://brainvisa.info/neuro-forge',
               '-c', 'file:///drf/neuro-forge/public',
               '-c', 'file:///drf/neuro-forge/brainvisa-cea',
               '-c', 'nvidia', '-c', 'pytorch', '-c', 'conda-forge']
        log = ['create user environment', 'command:', ' '.join(cmd),
               'from dir:', env_dir]
        self.log(environment, 'create user environment', 0,
                 '\n'.join(log), duration=0)
        result, output = self.call_output(cmd, cwd=env_dir)
        log = []
        log.append('=' * 80)
        log.append(output)
        log.append('=' * 80)
        success = True
        if result:
            success = False
            if result in (124, 128+9):
                log.append(f'TIMED OUT (exit code {result})')
            else:
                log.append(f'FAILED with exit code {result}')
        else:
            log.append(f'SUCCESS (exit code {result})')

        pixi_toml = osp.join(env_dir, 'pixi.toml')
        with open(pixi_toml) as f:
            lines = list(f.readlines())
        lines.insert(1, 'channel-priority = "disabled"\n')
        deps_i = lines.index('[dependencies]\n')
        lines.insert(deps_i + 1, 'soma-env = "0.0.*"\n')
        lines.insert(deps_i + 2, 'pytest = "*"\n')
        lines += ['\n',
                  '[pypi-dependencies]\n',
                  'dracopy = ">=1.4.2, <2"\n',
                  # 'acres = ">=0.2.0"\n',
                  ]
        with open(pixi_toml, 'w') as f:
            f.write(''.join(lines))

        self.cleanup_pixi_cache(dev_config)
        duration = int(1000 * (time.time() - start))
        self.log(environment, 'create user environment',
                 (0 if success else 1),
                 '\n'.join(log), duration=duration)
        if not success:
            self.log(environment, 'create user environment failed', 1,
                     'The environment init failed.')

        if success:
            # make test dir with symlink to ref data from the dev env
            os.makedirs(osp.join(env_dir, 'tests', 'test'))
            os.symlink(osp.join('../..', osp.basename(dev_env_dir), 'tests',
                                'ref'),
                       osp.join(env_dir, 'tests', 'ref'))

            start = time.time()
            packages = self.read_packages_list(dev_config)
            packages_list = [f'{p}={packages[p]["version"]}'
                             for p in sorted(packages)]
            # nibabel is used in a test, but is not a required dependency
            # of any package.
            cmd = ['pixi', 'add'] + packages_list + ['nibabel']
            log = ['install packages', 'command:', ' '.join(cmd),
                   'from dir:', env_dir]
            self.log(environment, 'install packages', 0,
                     '\n'.join(log), duration=0)
            result, output = self.call_output(cmd, cwd=env_dir)
            log = []
            log.append('=' * 80)
            log.append(output)
            log.append('=' * 80)
            if result:
                success = False
                if result in (124, 128+9):
                    log.append(f'TIMED OUT (exit code {result})')
                else:
                    log.append(f'FAILED with exit code {result}')
            else:
                log.append(f'SUCCESS (exit code {result})')

            duration = int(1000 * (time.time() - start))
            self.log(environment, 'install packages',
                     (0 if success else 1),
                     '\n'.join(log), duration=duration)
            if not success:
                self.log(environment, 'create user environment failed', 1,
                         'The packages installation failed.')

        return success

    def run_bbi(self, dev_configs, user_configs,
                update_neuroforge=True,
                bv_maker_steps='sources,configure,build,doc',
                dev_tests=True, pack=True, install_packages=True,
                user_tests=True):
        successful_tasks = []
        failed_tasks = []

        if bv_maker_steps:
            bv_maker_steps = bv_maker_steps.split(',')

        successful = True

        try:

            if update_neuroforge:
                successful |= self.update_brainvisa_cmake()
                if successful:
                    successful_tasks.append('update_neuroforge')
                else:
                    failed_tasks.append('update_neuroforge')

            for dev_config, user_config in zip(dev_configs, user_configs):
                # doc_build_success = False
                if update_neuroforge:
                    successful |= self.update_soma_env(dev_config)
                    successful |= self.update_brainvisa_cmake(dev_config)
                    if successful:
                        successful_tasks.append(
                            f'update_neuroforge {dev_config["name"]}')
                    else:
                        failed_tasks.append(
                            f'update_neuroforge {dev_config["name"]}')
                if bv_maker_steps:
                    successful, failed = self.bv_maker(dev_config,
                                                       bv_maker_steps)
                    successful_tasks.extend(
                        '{}: {}'.format(dev_config['name'], i)
                        for i in successful)
                    failed_tasks.extend(
                        '{}: {}'.format(dev_config['name'], i)
                        for i in failed)
                    if set(failed) - self.NONFATAL_BV_MAKER_STEPS:
                        # There is no point in running tests
                        # if compilation failed.
                        continue
                    # doc_build_success = ('doc' in successful)

                if dev_tests:
                    successful, failed = self.tests(dev_config, dev_config)
                    successful_tasks.extend(
                        '{}: {}'.format(dev_config['name'], i)
                        for i in successful)
                    failed_tasks.extend(
                        '{}: {}'.format(dev_config['name'], i)
                        for i in failed)

                if pack:
                    success = self.build_packages(dev_config)
                    if success:
                        successful_tasks.append(
                            '{}: build_packages'.format(dev_config['name']))
                    else:
                        failed_tasks.append(
                            '{}: build_packages'.format(dev_config['name']))

                if install_packages or (install_packages is None
                                        and self.packaging_done):
                    success = self.recreate_user_env(user_config, dev_config)
                    if success:
                        successful_tasks.append(
                            '{}: install_packages'.format(dev_config['name']))
                    else:
                        failed_tasks.append(
                            '{}: install_packages'.format(dev_config['name']))

                if user_tests or (user_tests is None and self.packaging_done):
                    successful, failed = self.tests(user_config, dev_config)
                    successful_tasks.extend(
                        '{}: {}'.format(user_config['name'], i)
                        for i in successful)
                    failed_tasks.extend(
                        '{}: {}'.format(user_config['name'], i)
                        for i in failed)

        except Exception:
            log = ['Successful tasks']
            log.extend(f'  - {i}' for i in successful_tasks)
            if failed_tasks:
                log .append('Failed tasks')
                log.extend(f'  - {i}' for i in failed_tasks)
            log += ['', 'ERROR:', '', traceback.format_exc()]
            self.log(self.bbe_name, 'error', 1, '\n'.join(log))
        else:
            log = ['Successful tasks']
            log.extend(f'  - {i}' for i in successful_tasks)
            if failed_tasks:
                log .append('Failed tasks')
                log.extend(f'  - {i}' for i in failed_tasks)
            self.log(self.bbe_name, 'finished',
                     (1 if failed_tasks else 0), '\n'.join(log))


def main():

    import argparse

    base_directory = os.environ.get('CASA_BASE_DIRECTORY')
    if not base_directory:
        base_directory = os.getcwd()
    jenkins_server = None
    jenkins_auth = f'{base_directory}/jenkins_auth'

    parser = argparse.ArgumentParser(
        description='run tests for a Conda-based build of BrainVisa, and log '
        'to a Jenkins server. Can also test installed packages.')
    parser.add_argument('-b', '--base_directory',
                        help='environment directory. default: '
                        f'{base_directory}',
                        default=base_directory)
    parser.add_argument('-e', '--environment', action='append',
                        help='environment dirs to run BBI on. '
                        'default: [<current_dir>]', default=[])
    parser.add_argument('-j', '--jenkins_server',
                        help='Jenkins server URL.',
                        default=jenkins_server)
    parser.add_argument('-a', '--jenkins_auth',
                        help=f'Jenkins auth file. default: {jenkins_auth}',
                        default=jenkins_auth)
    parser.add_argument('--update_neuroforge',
                        action=argparse.BooleanOptionalAction,
                        help='Update the neuro-forge repository before '
                        'proceeding. default: true',
                        default=True)
    parser.add_argument('--bv_maker_steps',
                        help='Coma separated list of bv_maker commands to '
                        'perform on dev environments. May be empty to do '
                        'nothing. default: sources,configure,build,doc',
                        default='sources,configure,build,doc')
    parser.add_argument('--dev_tests',
                        action=argparse.BooleanOptionalAction,
                        help='Perform dev build tree tests. default: true',
                        default=True)
    parser.add_argument('--pack',
                        action=argparse.BooleanOptionalAction,
                        help='Perform dev build tree packaging. '
                        'default: true', default=True)
    parser.add_argument('--install_packages',
                        action=argparse.BooleanOptionalAction,
                        help='Install packages in a user environment. '
                        'default: done only if new packages are built',
                        default=None)
    parser.add_argument('--user_tests',
                        action=argparse.BooleanOptionalAction,
                        help='Perform installed packages tests (as a user '
                        'install). default: done only if new packages are '
                        'built', default=None)

    args = parser.parse_args(sys.argv[1:])

    base_directory = args.base_directory
    jenkins_server = args.jenkins_server
    jenkins_auth = args.jenkins_auth
    environments = args.environment
    update_neuroforge = args.update_neuroforge
    bv_maker_steps = args.bv_maker_steps
    dev_tests = args.dev_tests
    user_tests = args.user_tests
    pack = args.pack
    install_packages = args.install_packages
    if len(environments) == 0:
        environments = [osp.basename(os.getcwd())]
        base_directory = osp.dirname(os.getcwd())
    base_directory = osp.abspath(base_directory)
    # print('base:', base_directory)
    # print('jenkins:', jenkins_server)
    # print('auth:', jenkins_auth)
    # print('envs:', environments)
    # print('dev tests:', dev_tests)
    # print('pack:', dev_tests)

    # Ensure that all recursively called instances of casa_distro will use
    # the correct base_directory.
    os.environ['CASA_BASE_DIRECTORY'] = base_directory

    if jenkins_server:
        # Import jenkins only if necessary to avoid dependency
        # on requests module
        try:
            from .jenkins import BrainVISAJenkins
        except ImportError:
            sys.path.append(osp.dirname(osp.dirname(osp.dirname(__file__))))
            from neuro_forge.soma_forge.jenkins import BrainVISAJenkins

        jenkins_auth = jenkins_auth.format(base_directory=base_directory)
        with open(jenkins_auth) as f:
            jenkins_login, jenkins_password = [i.strip() for i in
                                               f.readlines()[:2]]
        jenkins = BrainVISAJenkins(jenkins_server, jenkins_login,
                                   jenkins_password)
    else:
        jenkins = None

    dev_configs = [{'name': osp.basename(e),
                    'directory': osp.join(base_directory, e),
                    'type': 'dev'}
                   for e in environments]
    user_configs = [{'name': e['name'] + '_user',
                     'directory': e['directory'] + '_user',
                     'type': 'user'}
                    for e in dev_configs]

    bbi_daily = BBIDaily(base_directory, jenkins=jenkins)
    bbi_daily.run_bbi(dev_configs, user_configs, update_neuroforge,
                      bv_maker_steps, dev_tests, pack, install_packages,
                      user_tests)


if __name__ == '__main__':
    main()

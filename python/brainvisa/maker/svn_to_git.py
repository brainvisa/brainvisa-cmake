#!/usr/bin/env python

from __future__ import print_function
import os
import subprocess


def convert_project(project, repos, svn_repos, authors_file=None):
    '''
    Parameters
    ----------
    project: str
        component name (brainvisa-share, axon etc)
    repos: str
        git base repos directory. The project repos will be a subdirectory of
        it so it's safe to use the same repos directory for several projects
    svn_repos: str
        svn repos URL, including project/component dir
        (ex: https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-base)
    authors_file: str
        correspondance map file betweeen svn and git[hub] logins.
        format: see git-svn manpage (--authors-file)
    '''
    cur_dir = os.getcwd()
    os.chdir(repos)
    if authors_file:
        auth_args = '--authors-file %s ' % authors_file
    cmd = 'git svn clone --stdlayout --follow-parent %s%s' \
        % (auth_args, svn_repos)
    try:
        print(cmd)
        subprocess.check_call(cmd.split())
    except:
        # git-svn died with signal 11
        print('conversion fails at some point... trying again...')
        os.chdir(project)
        # several times...
        ok = False
        while not ok:
            cmd = 'git svn fetch'
            try:
                print(cmd)
                subprocess.check_call(cmd.split())
                ok = True
            except:
                print('conversion fails at some point... trying again...')
    make_branches(os.path.join(repos, project))
    make_tags(os.path.join(repos, project))
    os.chdir(cur_dir)


def make_branches(repos):
    '''
    Make master / integration branches matching resp. bug_fix and trunk
    branches in svn

    Parameters
    ----------
    repos: str
        git repos directory, including the project dir.
    '''
    cur_dir = os.getcwd()
    os.chdir(repos)
    cmd = 'git branch -m master integration'
    print(cmd)
    subprocess.check_call(cmd.split())
    cmd = 'git branch master origin/bug_fix' # --track
    print(cmd)
    subprocess.check_call(cmd.split())
    os.chdir(cur_dir)


def make_tags(repos):
    '''
    Make tags

    Parameters
    ----------
    repos: str
        git repos directory, including the project dir.
     '''
    cur_dir = os.getcwd()
    os.chdir(repos)
    cmd = 'git branch -a'
    print(cmd)
    branches = subprocess.check_output(cmd.split()).split('\n')
    for branch in branches:
        branch = branch.strip()
        if branch.startswith('remotes/origin/tags/'):
            tag = branch[len('remotes/origin/tags/'):]
            print('tag:', tag)
            if tag != 'latest_release':
                cmd = 'git tag -a -m'.split() + ["version %s" % tag, tag,
                                                 branch]
            else:
                cmd = 'git tag %s %s' % (tag, branch)
                cmd = cmd.split()
            print(cmd)
            subprocess.check_call(cmd)
    os.chdir(cur_dir)


def convert_perforce_directory(project, repos, svn_repos, authors_file=None):
    '''
    Parameters
    ----------
    project: str
        component name (brainvisa-share, axon etc)
    repos: str
        git base repos directory. The project repos will be a subdirectory of
        it so it's safe to use the same repos directory for several projects
    svn_repos: str
        svn repos URL, including project/component dir
        (ex: https://bioproj.extra.cea.fr/neurosvn/perforce/brainvisa)
    authors_file: str
        correspondance map file betweeen svn and git[hub] logins.
        format: see git-svn manpage (--authors-file)
    '''
    cur_dir = os.getcwd()
    os.chdir(repos)
    if authors_file:
        auth_args = '--authors-file %s ' % authors_file
    cmd = 'git svn clone --trunk=main --branches=. %s%s' \
        % (auth_args, svn_repos)
    try:
        try:
            print(cmd)
            subprocess.check_call(cmd.split())
        except:
            # some errors are due to non-understood history items
            print('conversion fails at some point...')
    finally:
        os.chdir(cur_dir)


def graft_history(project, old_project, repos, branch='master',
                  old_branch='trunk'):
    '''
    branch older commits (perforce) to the beginning of master
    '''
    cur_dir = os.getcwd()
    os.chdir(os.path.join(repos, old_project))
    cmd = 'git checkout %s' % old_branch
    print(cmd)
    subprocess.check_call(cmd.split())
    os.chdir(os.path.join(repos, project))
    cmd = 'git remote add old %s' % os.path.join(repos, old_project)
    print(cmd)
    subprocess.check_call(cmd.split())
    cmd = 'git fetch old'
    print(cmd)
    subprocess.check_call(cmd.split())
    cmd = 'git replace --graft `git rev-list %s | tail -n 1` old/%s' \
        % (branch, old_branch)
    print(cmd)
    subprocess.check_call(cmd, shell=True)
    os.chdir(cur_dir)


# --

def main():
    import argparse

    bioproj = 'https://bioproj.extra.cea.fr/neurosvn'

    parser = argparse.ArgumentParser('Convert some svn repositories to git')
    parser.add_argument('-p', '--project', action='append',
                        help='project (component) to be converted. A project or component name may precise which sub-directory in the svn repos they are in, using a ":", ex: "soma-base:soma/soma-base". If not specified, the project dir is supposed to be found directly under the project name directory in the base svn repository.'
                        'Multiple projects can be processed using multiple '
                        '-p arguments')
    parser.add_argument('-r', '--repos',
                        help='git local repository directory '
                        '[default: current directory]')
    parser.add_argument('-s', '--svn',
                        help='svn repository base URL [default: %s]' % bioproj)
    parser.add_argument('-A', '--authors-file',
                        help='authors file passed to git-svn: Syntax is '
                        'compatible with the file used by git cvsimport:\n'
                        'loginname = Joe User <user@example.com>')
    parser.add_argument('--p4', action='append', default=[],
                        help='convert old perforce directory project, to graft missing history from. format: project[:svn_dir[:git_dir]]]. \n'
                        'Several -o options allowed.')

    options = parser.parse_args()
    projects = options.project
    if not projects:
        parser.parse_args(['-h'])
    repos = options.repos
    if not repos:
        repos = os.getcwd()
    svn_repos = options.svn
    if not svn_repos:
        svn_repos = bioproj
    authors_file = options.authors_file
    p4_projects = options.p4

    for project in projects:
        if ':' in project:
            project, svn_dir = project.split(':')
        else:
            svn_dir = project
        convert_project(project, repos, '%s/%s' % (svn_repos, svn_dir),
                        authors_file=authors_file)

    for project_def in p4_projects:
        pdef = project_def.split(':')
        project = pdef[0]
        svn_dir = 'perforce/%s' % project
        #branch = 'main'
        if len(pdef) >= 2:
            svn_dir = pdef[1]
            #if len(pdef) >= 3:
                #branch = pdef[2]

        convert_perforce_directory(project,
                                   repos,
                                  '%s/%s' % (svn_repos, svn_dir),
                                  authors_file=authors_file)
    ## graft older perforce history on axon
    #perforce_project = 'brainvisa'
    #graft_history('axon', 'brainvisa', repos, 'integration', 'trunk')


if __name__ == '__main__':
    main()

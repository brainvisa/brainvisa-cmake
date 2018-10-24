#!/usr/bin/env python

from __future__ import print_function
import os
import re
import subprocess
import time


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
    auth_args = ''
    if authors_file:
        auth_args = '--authors-file %s ' % authors_file
    cmd = 'git svn clone --stdlayout --follow-parent %s%s' \
        % (auth_args, svn_repos)
    try:
        print(cmd)
        subprocess.check_call(cmd.split())
    except:
        # git-svn died with signal 11
        print('conversion fails at some point... trying again in 5 seconds...')
        os.chdir(project)
        # several times...
        ok = False
        while not ok:
            time.sleep(5)
            cmd = 'git svn fetch'
            try:
                print(cmd)
                subprocess.check_call(cmd.split())
                ok = True
            except:
                print('conversion fails at some point... trying again in 5 seconds...')
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


def make_tags(repos, latest_release_version=None):
    '''
    Make tags

    Parameters
    ----------
    repos: str
        git repos directory, including the project dir.
    latest_release_version: str
        version number that will replace the latest_release SVN tag
    '''
    cur_dir = os.getcwd()
    os.chdir(repos)
    cmd = 'git branch -a'
    print(cmd)
    branches = subprocess.check_output(cmd.split()).split('\n')
    for branch in branches:
        branch = branch.strip()
        if branch.startswith('remotes/origin/tags/'):
            svn_tag_name = branch[len('remotes/origin/tags/'):]
            print('tag:', svn_tag_name)
            # The SVN tag can have a history that deviates from the main line
            # of history, which typically consists of empty commits that are
            # created when the branch is moved from latest_release to a named
            # version. We want the tag to point to a commit that is on the main
            # line of history as far as possible, so that e.g. "git describe"
            # can give useful output. Therefore, we search for the closest
            # commit on the mainline with "git merge-base", then we validate
            # with "git diff" that the contents of this commit are the same as
            # the tag.
            ancestor_commit = subprocess.check_output(
                ['git', 'merge-base', branch, 'master']
            ).strip()
            returncode = subprocess.call(['git', 'diff', '--quiet',
                                          ancestor_commit, branch])
            if returncode == 0:
                tag_cmd_env = {}
                if (re.match(r'^\d+\.\d+\.\d+$', svn_tag_name)
                    or (svn_tag_name == 'latest_release'
                        and latest_release_version is not None)):
                    if svn_tag_name == 'latest_release':
                        tag_version = latest_release_version
                    else:
                        tag_version = svn_tag_name
                    tag_cmd = ['git', 'tag', '-a', '-m',
                               "version %s" % tag_version,
                               'v' + tag_version, ancestor_commit]
                    # We want the tag object to carry the date and committer
                    # who created the tag in SVN in the first place (typically,
                    # the person who moved the branch to tags/latest_release).
                    tag_commit = subprocess.check_output(
                        ['git', 'rev-list', '--reverse',
                         ancestor_commit + '..' + branch]
                    ).split('\n', 1)[0]
                    tag_date, tagger_name, tagger_email = subprocess.check_output(
                        ['git', 'show', '--format=%cI%n%cn%n%ce', '--no-patch',
                         tag_commit]
                    ).strip().split('\n')
                    tag_cmd_env = {'GIT_COMMITTER_NAME': tagger_name,
                                   'GIT_COMMITTER_EMAIL': tagger_email,
                                   'GIT_COMMITTER_DATE': tag_date}
                else:
                    # Create a lightweight tag for SVN tags that are not named
                    # X.Y.Z (these tags may move, e.g. latest_release)
                    tag_cmd = ['git', 'tag', svn_tag_name, branch]
                print(tag_cmd)
                tag_cmd_env.update(os.environ)
                subprocess.check_call(tag_cmd, env=tag_cmd_env)
            else:
                print('WARNING: cannot find a mainline commit that matches '
                      'the SVN tag %s, no git tag will be created.')
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
    auth_args = ''
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


def graft_history(project, old_project, repos, old_repos, branch='master',
                  old_branch='trunk'):
    '''
    branch older commits (perforce) to the beginning of master

    Parameters
    ----------
    project: str
        later project name
    old_project: str
        former project name
    repos: str
        later project git repos directory (including project name)
    old_repos: str
        former project git repos directory (including project name)
    branch: str
        later project branch to graft
    old_branch: str
        former project branch
    '''
    cur_dir = os.getcwd()
    os.chdir(old_repos)
    cmd = 'git checkout %s' % old_branch
    print(cmd)
    subprocess.check_call(cmd.split())
    os.chdir(repos)
    cmd = 'git remote add old %s' % old_repos
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
    parser.add_argument('-g', '--graft', action='append', default=[],
                        help='graft the beginning of a project branch to the end of another project branch to recover older history that git-svn could not figure out (especially useful for old perforce history). Several -g options allowed. Syntax: later_project[/later_git_branch][@later_repos_dir]:older_project[/older_git_branch][@older_repos_dir]. Projects/branches should have been converted to git first using -p / --p4 options (during this run of bv_git_to_svn or a previous one). Ex: axon/master:brainvisa/trunk will graft axon after brainvisa. The default branches are resp. master and trunk.')

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
    grafts = options.graft

    for project in projects:
        if ':' in project:
            project, svn_dir = project.split(':')
        else:
            svn_dir = project
        convert_project(project, repos, '%s/%s' % (svn_repos, svn_dir),
                        authors_file=authors_file)

    # recover older perforce histories in separate projects
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
    # graft older perforce history on axon
    for graft_spec in grafts:
        new, old = [x.split('@') for x in grafts.split(':')]
        if len(new) >= 2:
            newp, new_dir = new
        else:
            newp = new[0]
            new_dir = None
        if len(old) >= 2:
            oldp, old_dir = old
        else:
            oldp = old[0]
            old_dir = None
        new_project = newp.split(':')
        if len(new_project) >= 2:
            new_project, new_branch = new_project
        else:
            new_project, new_branch = new_project[0], 'master'
        old_project = oldp.split(':')
        if len(old_project) >= 2:
            old_project, old_branch = old_project
        else:
            old_project, old_branch = old_project[0], 'trunk'
        if new_dir is None:
            new_dir = s.path.join(repos, new_project)
        if old_dir is None:
            old_dir = os.path.join(repos, old_project)
        graft_history(new_project, old_project, new_dir, old_dir,
                      new_branch, old_branch)


if __name__ == '__main__':
    main()

=================================
How to compile BrainVISA projects
=================================

How to setup a developement environement for BrainVISA projects

There are several possibilities to compile a series of BrainVISA components. One can use a standard CMake procedure where each component have its own build directory and links between components are done via CMake cache variables. But at the time of this writing, there are 44 components in 21 BrainVISA project. Configuring and compiling all of them manualy can be a hard work. This is why bv_maker script have been developped in order to easily create a complete source synchronization and compilation pipeline for a selected set of projects or components. This document describes the use of bv_maker.


First time configuration
========================

1) Install dependencies on your system
--------------------------------------

You must have the following software on your system:

* Subversion. The command svnadmin must also be installed on your system. On some Linux distributions it is not in the subversion package (for instance in Ubuntu you must install subversion-tools package).
* Git
* CMake (version >= 2.6.4)
* Python (version >= 2.6)
* Make
* Other dependencies depends on the components you want to build.

If you work at the I2BM (Neurospin, MirCen or SHFJ), you can call the bash function *bv_setup_devel* in your ``.bashrc`` file. This will add ``/i2bm/brainvisa`` paths in your environment variables where some useful dependencies for the development environment are installed.


2) Get an up-to-date working copy of bv_maker
---------------------------------------------

bv_maker is part of the brainvisa-cmake project. Since you need bv_maker to download the sources and do the first build directory, you may have to download a temporary version with the following code:

For Linux and MacOS:
####################

.. code-block:: bash

    git clone https://github.com/brainvisa/brainvisa-cmake.git /tmp/brainvisa-cmake
    cd /tmp/brainvisa-cmake
    cmake -DCMAKE_INSTALL_PREFIX=. .
    make install

For Windows:
############

Creating a developpment environment is not supported under Windows. Building Windows version of BrainVISA software is done on Linux using cross-compilation.

You can now use :code:`/tmp/brainvisa-cmake/bin/bv_env_host bv_maker` to setup your environement (**you must edit the configuration file first**). You will always have a copy of brainvisa-cmake installed in a build directory at configuration time. Therefore, you may delete this temporary brainvisa-cmake version and use the one in your build directory.


3) Edit bv_maker configuration file
-----------------------------------

You must create this file in the following directory: ``$HOME/.brainvisa/bv_maker.cfg``. In this file you can configure mainly two types of directory:

* source directory: A source directory contains the source code of a set of selected projects. This source code will be updated (to reflect the changes that occured on BioProj server) each time you use bv_maker configure. You can define as many source directory as you want. In a source directory configuration you can select any project and combine several versions of the same project.
* build directory: A build directory will contain compiled version of the projects. A build directory can contain any project but only one version per project is allowed. You can define as many build directory as you want.

See :doc:`bv_maker configuration syntax <configuration>` for a complete documentation with examples.

Typical configuration:
######################

.. code-block:: bash

    # definition of the source directory: open-source projects in bug_fix version (i.e. the branch with the highest version) except web project because it takes space
    [ source $HOME/brainvisa/source ]
      + opensource bug_fix
      - web

    # definition of the build directory: build open-source projects from the source directory except anatomist-gpl and anatomist-private components
    [ build $HOME/brainvisa/build/bug_fix ]
      make_options = -j4
      build_type = Release
      opensource bug_fix $HOME/brainvisa/source
      - anatomist-*
      - communication:web

.. warning::
    The option build_type is very important, the execution can be two to three times slower if the build is not in Release mode.


4) Download sources
-------------------

.. code-block:: bash

    /tmp/brainvisa-cmake/bin/bv_env_host bv_maker sources


5) Configure build directories with CMake
-----------------------------------------

.. code-block:: bash

    /tmp/brainvisa-cmake/bin/bv_env_host bv_maker configure

(look at the section `In case of problems`_ for troubleshooting)

After this step, you have a version of ``brainvisa-cmake`` installed in each build directory you have defined. You can therefore find :doc:`bv_maker <bv_maker>` in ``<build_directory>/bin/bv_maker``.


6) Compile in build directories with make
-----------------------------------------

.. code-block:: bash

    /tmp/brainvisa-cmake/bin/bv_env_host bv_maker build


7) Remove directory created in step 2
-------------------------------------

You should now remove the temporary bv_maker that have been downloaded in step 2 and use the one installed in your build directory: ``<build_directory>/bin/bv_maker``.

.. code-block:: bash

    rm -Rf /tmp/brainvisa-cmake

If you want to use all your build directory, set the following environment variables: ``PATH``, ``LD_LIBRARY_PATH``, ``PYTHONPATH`` and ``BRAINVISA_SHARE``. To make it easier, we provide a program called :doc:`bv_env <bv_env>` that sets up the required environment variables:

.. code-block:: bash

    . <build_directory>/bin/bv_env.sh <build_directory>


8) Build documentation (docbook, doxygen, epydoc)
-------------------------------------------------

.. code-block:: bash

  bv_maker doc


In case of problems
===================

* **CMake has caches**. They sometimes keep erroneous values. Do not hesitate to remove the ``CMakeCache.txt`` file at the root of the build trees before reconfiguring. It sometimes solves incomprehensible configure problems.

.. _git_repositories:

Git repositories and bv_maker
=============================

in the ``[source]`` section of ``bv_maker.cfg``:

.. code-block:: bash

  git https://github.com/neurospin/highres-cortex.git master highres-cortex/master


Remotes and forks
-----------------

Git repos are normally linked to the main "origin" repository. When personal forks are used, the local repository has to be linked to this indirect personal fork. Connecting to personal forks can be done in each client repository once it is setup once:

.. code-block:: bash

    git remote add -f perso git@github.com:<login>/morphologist.git
    git branch --set-upstream-to perso/master master

You can use any other name instead of "perso".

This way later *pulls* (as done by ``bv_maker sources``) will pull from the personal fork.

The way bv_maker handles git repositories has changed in bv_maker 3:

* in bv_maker >= 3, repositories are full clones. All remotes are fetched by default when ``bv_maker sources`` is invoked (:ref:`see the config option <source_directory>` ``update_git_remotes``). The default branch (``master``, ``integration``) is checked out according to the target branch. If `git-lfs <https://git-lfs.github.com/>`_ is installed on the system, it is used to clone repositories which might use it, and initialized on new repositories (the ``git lfs install`` comamnd is run on newly cloned directories). The new behavior is havier in terms of network traffic and disk space occupation, but easier to use for developers, and more closely corresponds to the standard git use workflow. Moreover it seemed necessary to perform a "full clone" to be able to use git-lfs properly.

* in bv_maker < 3, repositories were in "light" mode: remotes were not fetched at first, and a detached branch was used to follow the movements of the default remote branch. On later updates, only the current branch was fast-forwarded, and by default remotes were not fetched at all (:ref:`see the config option <source_directory>` ``update_git_remotes``).


Credentials
-----------

GitHub may use either https or git (ssh) protocols. Https is likely to ask username and password at each push operation. git/ssh protocol uses a ssh key, which avoids the needs to type a password every time. This key has to be registered by users on the GitHub web site.
You may swich to git/ssh protocol by changing a remote URL in a repository directory (which has to be done for each repository client directory):

.. code-block:: bash

    git remote set-url origin git@github.com:brainvisa/brainvisa-cmake.git

Brainvisa-cmake provides the https version by default because we cannot know if users have registered a ssh key on GitHub (or even if users actually have an account on GitHub or are using the anonymous read access).

BioProj projects which are under git (there are a few) always use https, and moreover need credentials even at read time (on fetch / pull operations), which is even more annoying. Consider storing permanently credential information in the git config:

.. code-block:: bash

    git config credential.helper store

This will allow git to store username and password **unencrypted** in the .git directory of the project. You have to do so for each project, and in brainvisa-cmake, each declared branch (bug_fix / trunk etc.) since each is a separate clone of the git repos. Then on the next update (``bv_maker sources``) git will ask for username and password, still for each project directory, and then store them and don't ask again the next time.


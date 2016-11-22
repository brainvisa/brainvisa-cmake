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

    svn export https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-cmake/branches/bug_fix /tmp/brainvisa-cmake
    cd /tmp/brainvisa-cmake
    cmake -DCMAKE_INSTALL_PREFIX=. .
    make install

For Windows:
############

.. code-block:: cmake

    svn export https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-cmake/branches/bug_fix /c/tmp/brainvisa-cmake
    cd /c/tmp/brainvisa-cmake
    cmake -G 'MSYS Makefiles' -DCMAKE_INSTALL_PREFIX=. .
    make install

You can now use /tmp/brainvisa-cmake/bin/bv_env bv_maker to setup your environement (**you must edit the configuration file first**). You will always have a copy of brainvisa-cmake installed in a build directory at configuration time. Therefore, you may delete this temporary brainvisa-cmake version and use the one in your build directory.

.. note::
    The svn address here, https://bioproj.extra.cea.fr/neurosvn/brainvisa/branches/bug_fix/brainvisa-cmake is the address of the **bug_fix** branch in our development tree, which corresponds to the "stable, usable" version, not the released version as found in https://bioproj.extra.cea.fr/neurosvn/brainvisa/source_views/brainvisa_cmake. As new features have been added sonce the last release, such as support for **git** projects and svn project hosted on a separate repository (such as capsul), this newer version is needed to build projects on the current repository.


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

    /tmp/brainvisa-cmake/bin/bv_env bv_maker sources

You can permanently accept the certificate for https://bioproj.extra.cea.fr:443 by typing p when asked.
When a password is requested you can press return and use your BioProj login and password.


5) Configure build directories with CMake
-----------------------------------------

.. code-block:: bash

    /tmp/brainvisa-cmake/bin/bv_env bv_maker configure

(look at the section `In case of problems`_ for troubleshooting)

After this step, you have a version of ``brainvisa-cmake`` installed in each build directory you have defined. You can therefore find :doc:`bv_maker <bv_maker>` in ``<build_directory>/bin/bv_maker``.


6) Compile in build directories with make
-----------------------------------------

.. code-block:: bash

    /tmp/brainvisa-cmake/bin/bv_env bv_maker build


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


Git repositories and bv_maker
=============================

in the ``[source]`` section of ``bv_maker.cfg``:

.. code-block::

  git https://github.com/neurospin/highres-cortex.git master highres-cortex/master

Git repos are normally linked to the main "origin" repository. When personal forks are used, the local repository has to be linked to this indirect personal fork. Connecting to personal forks can be done in each client repository once it is setup once:

.. code-block:: bash

    git remote add -f perso git@github.com:<login>/morphologist.git
    git branch --set-upstream-to perso/master master

This way later *pulls* (as done by ``bv_maker sources``) will pull from the personal fork.

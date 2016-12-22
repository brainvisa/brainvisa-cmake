===================================
The bv_maker.cfg configuration file
===================================

You must create this file in the following directory: ``$HOME/.brainvisa/bv_maker.cfg``.

In this file you can configure several types of directories:

* **source directory**: A source directory contains the source code of a set of selected projects. This source code will be updated (to reflect the changes that occured on BioProj server) each time you use bv_maker configure. You can define as many source directory as you want. In a source directory configuration you can select any project and combine several versions of the same project.

* **build directory**: A build directory will contain compiled version of the projects. A build directory can contain any project but only one version per project is allowed. You can define as many source directory as you want.

* **package directory**: A package directory is an installer repository directory. It is built from a build directory, and can be used to make a repository, to install the package, and to run tests on the installed packages.

A section may also contain conditional parts. See the `Conditional subsections`_ section for details.


General structure and syntax of bv_maker configuration file
===========================================================

The :doc:`bv_maker` configuration file is composed of sections delimited by a line enclosed in square brackets: ``[ ... ]``. Each section contains the definition of a directory (either a source directory, a build directory, or a packaging directoty), or a "general" section. In this file, blank lines are ignored and spaces at the begining or end of lines are also ignored. It means that you can indent and separate lines as you wish. For instance the three following configurations are equivalent:

.. code-block:: bash

    [ source $HOME/brainvisa/source ]
      + standard trunk
      + standard bug_fix
      - communication
      + perso/myself/myproject

    [ build $HOME/brainvisa/build/bug_fix ]
      build_type = Release
      make_options = -j8
      standard bug_fix $HOME/brainvisa/source

    [ build $HOME/brainvisa/build/trunk ]
      make_options = -j8
      standard trunk $HOME/brainvisa/source
      + $HOME/brainvisa/source/perso/myself/myproject

A line begining with ``#`` or ``//`` is considered as a comment and ignored. Comments cannot be added at the end of a line. For instance the following are valid comments:

.. code-block:: bash

    # A comment
      # Another comment
    // This is also a comment !


But the following line is not valid:

.. code-block:: bash

    [ build $HOME/brainvisa/build/trunk ] # This is a syntax error


Definition of a general section
===============================

The general section is optional, and contains variable which are independent from each other sections (or shared accross them).

The general section definition starts with a line with the following syntax:

.. code-block:: bash

    [ general ]

Option variables are stored in this section using the syntax ``option = value``. The following options are supported:

* ``email_notification_by_default``: ``ON```or ``OFF`` (default). If set to ``ON``, email notification will always be used if ``failure_email`` or ``success_email`` are provided. Otherwise, the default behavior is to use email notification only when the ``bv_maker`` commabdline is invoked with the ``--email`` option.
* ``global_status_file``: if this file is specified, a line will be appended to it for each source/build/package directory. This line will log the build status for the given directory: OK/FAILED, last step executed, directory, start and stop date and time, machine and system. It can be parsed and displayed using the command ``bv_show_build_log``.
* ``failure_email``: email address where bv_maker outputs are sent in case of failure. If not specified, no email will be sent and bv_maker outputs will be sent to the standard output. One email will be sent for each directory and build step that fail.
* ``success_email``: email address where bv_maker outputs are sent in case of success. If not specified, no email will be sent and bv_maker outputs will be sent to the standard output. One email will be sent for each directory and build step that succeeds.
* ``smtp_server``: SMTP (email server) hostname to be used to send emails
* ``from_email``: displayed expeditor of sent emails. If not specified, it will be ``<user>-<hostname>@intra.cea.fr`` (the suffix is needed, and is correct for our lab)
* ``reply_to_email``: displayed reply email address in sent emails. If not specified, ``appli@saxifrage.saclay.cea.fr``.


Definition of a source directory
================================

A source directory definition section starts with a line with the following syntax:

.. code-block:: bash

    [ source <directory> ]

where ``<directory>`` is the name of the directory that will be created and whose content will synchronized with selected source directories located in BrainVISA Subversion server. The directory name can contain environment variable substitution by using ``$VARIABLE_NAME``. For instance, on Unix systems, ``$HOME/brainvisa`` will be replaced by the brainvisa directory located in the user home directory. If the specified directory does not exists, it will be created (as well as parent directories) when the sources will be processed by bv_maker.

The content of the source directory section is composed of a set of rules to select and unselect Subversion directories to copy in the source directory. Each source directory is first associated with an empty list of subdirectories. Then, the configuration file is parsed in order to modify this list. Each line in the source directory section correspond to an action that can modify the list. These actions are executed in the order they are given. It means that you can unselect directories previously selected or the contrary. For instance if one wants to select all components but one, he will make a first action to select all components and a second one to remove the component to ignore. There are three kind of actions that can be done to modify this list of subdirectories. The syntax of the configuration rules corresponding to these actions are described in the following paragraphs.

In the source section, it is also possible to define some options, delcared in the syntax ``option = value``. The following options are supported:

* ``build_condition``: a condition which must be True to allow configure and build steps, otherwise they will be skipped. The condition is evaluated in **python language**, and is otherwise free: it may typically be used to restrict build to certain systems or hostnames, some dates, etc.
* ``revision_control``: ``ON`` (default) or ``OFF``. If enabled, revision control systems (*svn*, *git*) will be used to update the sources. If OFF, the sources directory will be left as is as a fixed sources tree.
* ``default_steps``: steps performed for this build directory when bv_maker is invoked without specifying steps (typically just ``bv_maker``). Defaults to: ``sources``.
* ``stderr_file``: file used to redirect the standard error stream of bv_maker when email notification is used. This file is "persistant" and will not be deleted. If not specified, it will be mixed with standard output.
* ``stdout_file``: file used to redirect the standard output stream of bv_maker when email notification is used. This file is "persistant" and will not be deleted. If neither it nor ``stderr_file`` are specified, then a temporary file will be used, and erased when each step is finished.


Add components to the list
--------------------------

.. code-block:: bash

    + component_selection version_selection

A line starting with a plus will use Subversion to add some directories from the BrainVISA BioProj repository. The selections of the directories is done by selecting components according to their name and version. Once the components are selected, bv_maker is able to find the corresponding directories in BrainVISA repository. component_selection is used to select a list of components according to their name (see `Component selection`_). It is not mandatory to provide a version_selection. If it is given, it is used to further filter the list of selected components according to their version (see `Version selection`_).


Remove components from the list
-------------------------------

.. code-block:: bash

    - component_selection version_selection

A line starting with a minus is has the same syntax as the previous action but removes the selected directories from the list.


Add directories to the list
---------------------------

.. code-block:: bash

    + repository_directory local_directory

In order to include some directories that do not correspond to registered BrainVISA components, one can directly give the directory name in ``repository_directory``. This directory name must be given relatively to the main BrainVISA repository URL: https://bioproj.extra.cea.fr/neurosvn/brainvisa. By default, ``repository_directory`` is also used to define where this directory will be in the source directory. It is not mandatory to provide a value for local_directory. If it is given, it is used instead of repositor_directory to define the directory location relatively to the source directory.

For instance, the following configuration will link the repository directory https://bioproj.extra.cea.fr/neurosvn/brainvisa/perso/myself/myproject with the local directory ``/home/myself/brainvisa/perso/myself/myproject``.

.. code-block:: bash

    [ source /home/myself/brainvisa ]
      + perso/myself/myproject

Whereas the following configuration will link the same repository directory with the local directory ``/home/myself/brainvisa/myproject``.

.. code-block:: bash

    [ source /home/myself/brainvisa ]
      + perso/myself/myproject myproject


Definition of a build directory
===============================

A build directory definition section starts with a line with the following syntax:

.. code-block:: bash

    [ build <directory> ]

where ``<directory>`` is the name of the directory where the compilation results will be written. As the source directory, the build directory name can contain environment variable substitution.

This section defines the list of components that will be built and their version and the source directory where they can be found. The components and versions are defined as they were in the source directory. It is also possible to remove components from the list with a line beginning with a minus.

In the build section, it is also possible to define some build options:

* ``cmake_options``: passed to cmake (ex: ``-DMY_VARIABLE=dummy``)
* ``ctest_options``: passed to ctest in the test step (ex: ``-j4 -VV -R carto*``)
* ``make_options``: passed to make (ex: ``-j8``)
* ``build_type``: ``Debug``, ``Release`` or none (no optimization options)
* ``packaging_thirdparty``: Set this option to ``ON`` if you need to create a BrainVISA package containing thirdparty libraries dependency.
* ``build_condition``: a condition which must be True to allow configure and build steps, otherwise they will be skipped. The condition is evaluated in **python language**, and is otherwise free: it may typically be used to restrict build to certain systems or hostnames, some dates, etc.
* ``clean_build``: ``ON`` or ``OFF`` (default), if set, the build tree will be cleaned of obsolete files before the build step (using the command ``bv_clean_build_tree``)
* ``clean_config``: ``ON`` or ``OFF`` (default), if set, the build tree will be cleaned of obsolete files before the configuration step (using the command ``bv_clean_build_tree``)
* ``default_steps``: steps performed for this build directory when bv_maker is invoked without specifying steps (typically just ``bv_maker``). Defaults to: ``configure build``, but may also include ``doc`` and ``test``.
* ``stderr_file``: file used to redirect the standard error stream of bv_maker when email notification is used. This file is "persistant" and will not be deleted. If not specified, it will be mixed with standard output.
* ``stdout_file``: file used to redirect the standard output stream of bv_maker when email notification is used. This file is "persistant" and will not be deleted. If neither it nor ``stderr_file`` are specified, then a temporary file will be used, and erased when each step is finished.

**Example**

.. code-block:: bash

    [ build $HOME/brainvisa/build/bug_fix ]
      packaging_thirdparty = ON
      build_type = Release
      make_options = -j8
      standard bug_fix $HOME/brainvisa/source

In the above example, the *bug_fix* version of standard components which are located in ``$HOME/brainvisa/source`` directory will be compiled in the build directory ``$HOME/brainvisa/build/bug_fix`` in ``Release`` mode with the option ``-j8`` passed to make command (compilation distributed on 8 processors).


Variants of build directories
-----------------------------

A build directory may also be a *python virtualenv* directory. To specify it the section type may be virtualenv instead of build:

.. code-block:: bash

    [ virtualenv <directory> ]

A virtualenv directory will be initialized the first time it is used, and a python virtualenv environment will be installed there. Then it will be used as a build directory in addition. This allows to use ``pip install`` commands within it with a local install, just for this build directory.


Definition of a package directory
=================================

A package directory definition section starts with a line with the following syntax:

.. code-block:: bash

    [ package <directory> ]

where ``<directory>`` is the name of the directory where the packaging results will be written (packages repository). As the source and build directories, the package directory name can contain environment variable substitution.

The package section allows 3 additional steps :doc:`bv_maker`: ``pack``, ``install_pack`` and ``test_pack``

* ``pack`` will build a packages repository and an installer program
* ``install_pack`` will install the previously built installer, possibly on a remote machine or docker machine
* ``test_pack`` will run tests (same as ``bv_maker test`` on the installed package, possibly on a remote or docker machine

The package section must define some variables which specify which build directory will be packaged and how.

* ``build_directory``: references a build directory, which must exist in the configuration file. It is mandatory.
* ``ctest_options``: passed to ctest in the test_pack step (ex: ``-j4 -VV -R carto*``)
* ``data_repos_dir``: Data repository directory. Mandatory when installing a non-data package (dependencies on data packages must be satisfied to install runtime packages)
* ``default_steps``: steps performed for this package directory when bv_maker is invoked without specifying steps (typically just ``bv_maker``). Defaults to none, may include ``pack``, ``install_pack`` and ``test_pack``.
*  ``init_components_from_build_dir``: if ``ON`` (default), the build directory will provide the initial list of projects and components to be packaged. If ``OFF``, the initial list of projects and components to be packages is empty.
* ``installer_filename``: output installer program file name. Mandatory unless packaging_options specify --data (data package, no installer output).
* ``pack_version``: package version string. Optional. If not specified, it will be guessed from the python module ``brainvisa.config`` (from the *axon* project) if it is present.
* ``packaging_options``: options passed to the *bv_packaging* program (in *brainvisa-installer* project). Typically: --i2bm
* ``build_condition``: As in build sections, condition when the package section steps are performed.
* ``remote_test_host_cmd``: The contents of this variable is actually prepended to package install and package test commands. It it typically used to perform remote connections to a test machine, using ssh and/or docker for instance:
* ``stderr_file``: file used to redirect the standard error stream of bv_maker when email notification is used. This file is "persistant" and will not be deleted. If not specified, it will be mixed with standard output.
* ``stdout_file``: file used to redirect the standard output stream of bv_maker when email notification is used. This file is "persistant" and will not be deleted. If neither it nor ``stderr_file`` are specified, then a temporary file will be used, and erased when each step is finished.

  .. code-block:: bash

      remote_test_host_cmd = ssh -t -X testmachine

  or:

  .. code-block:: bash

      remote_test_host_cmd = docker run --rm -v /tests:/tests -u "$(id -u):$(id -g)" -e USER=$USER custom_test_image xvfb-run

* ``test_install_dir``: Package installation directory. Mandatory if ``install_pack`` or ``test_pack`` steps are performed.

In addition to variables definition, the *package* section may contain components selection definitions, in the same format as in the build section.

In the package section, the package directory definition, and other path variables (``installer_filename``, ``test_install_dir``, ``data_repos_dir``) will undergo environment variables substitution, and an additional variables substiuttion in "python-style":

.. code-block:: bash

    installer_filename = $HOME/build-cmake/tests/repository/brainvisa-installer-%(version)s-%(os)s

Variables substitution in the form ``$(variable)s`` can replace the following variables:

* ``i2bm``: ``public`` or ``i2bm`` if ``packaging_options`` contain the option ``--i2bm``
* ``os``: ``linux64-glibc-2.15``, ``osx``, ``win32`` for instance
* ``version``: package version
* ``public``: empty for public packages, ``-i2bm`` if ``packaging_options`` contain the option ``--i2bm``
* ``online``: ``online`` or ``offline``


**Example**

.. code-block:: bash

    [ package /home/local/brainvisa_packages/test_data_repository ]
      build_directory = $HOME/brainvisa/build/bug_fix
      build_condition = sys.platform == "linux2"
      packaging_options = --repository-only --no-thirdparty --no-dependencies --data
      init_components_from_build_dir = OFF
      brainvisa-share bug_fix $HOME/brainvisa/sources

    [ package /home/local/brainvisa_packages/test_repository ]
      build_directory = $HOME/brainvisa/build/bug_fix
      installer_filename = /home/local/brainvisa_packages/test_installer
      build_condition = sys.platform == "linux2"
      test_install_dir = /home/local/brainvisa_packages/test_install
      data_repos_dir = /home/local/brainvisa_packages/test_data_repository
      - communication
      - web


Syntax for components selection
===============================

Components can be selected according to their name and (in some context) to their version. This paragraph explain how to use component_selection and version_selection and gives some examples of their usage.

Information about the components, components groups and versions are extracted from svn repository and stored in the following file: https://bioproj.extra.cea.fr/redmine/projects/brainvisa-devel/repository/entry/brainvisa-cmake/bug_fix/python/brainvisa/maker/components_definition.py


Component selection
-------------------

A component_selection is a string that is used to select one or more component according to their name. The following rules are used to transform this string into a list of components:

#. If component_selection is a group name, all components of this group are selected. At the time of this writing, four groups are defined:

  * **all** which contains all known components,
  * **opensource** for all open source components
  * **standard** containing only standard components of BrainVISA project
  * **anatomist** containing Anatomist and its dependencies.

#. If component_selection is a project name, all components of this project are selected
#. If component_selection is a component name, only this component is selected
#. Component selection must be a single pattern (with Unix shell-style wildcards) or two patterns separated by a colon:

  #. If there is only one pattern, all components matching this pattern are selected
  #. If there are two patterns, all components that are in a project matching the first pattern and that are matching the second pattern are selected


Version selection
-----------------

To select the version of a component or a group of component, it is possible

* to give the exact version number of a branch (4.0) or a tag (4.0.1)
* to use one of the following keywords:

  * **development**, **trunk**: trunk version in svn repository
  * **bug_fix**, **branch**, **stable** : latest stable version, the higher version number in branches directory of svn repository
  * **tag**, **latest_release**: latest tag version, the higher version number in tags directory of svn repository

* **branch:n** : the nth version in branches directory
* **tag:n** : the nth version in tags directory


Examples of components selection
--------------------------------

Select all versions of all existing components:

.. code-block:: bash

    all

Select latest release version of all components:

.. code-block:: bash

    all tag

Select latest bug fixing branch of open source components:

.. code-block:: bash

    opensource branch

Select all components in project aims with version 4.0.2:

.. code-block:: bash

    aims 4.0.2

Select development version of soma-workflow component:

.. code-block:: bash

    soma-workflow trunk

Select latest bug fixing branch of all components in anatomist project:

.. code-block:: bash

    anatomist:* bug_fix


Conditional subsections
=======================

A section of the configuration file may contain conditional parts. This allows to specialize parts of the configuration according to host system, host name, or whatever.

Condition blocks
----------------

A conditional subsection should be located inside an existing section (sources, build or package). It follows the syntax:

.. code-block:: bash

    [ if <expression> ]
      <config lines>
      ...
    [ else ]
      <other config lines>
    [ endif ]

The ``[ else ]`` block is of course optional, and a global section end also ends the conditional section, so the ``[ endif ]`` section may be omitted if it is at the end of the section.


Condition expressions
---------------------

The condition expression may contain substitution variables as in the shape ``%(variable)s`` syntax, like in the package section, at the difference that only the following variables are recognized:

* os
* date
* time

Other variables depend on the configuration of the section itself, which is only done later, so they are not available yet when parsing conditions.

The condition expression is then evaluated in python language (using the ``eval()`` function), thus allows all python language syntax and loaded libraries. The expression result is cast to a boolean value.

Thus a configuration may look like the following:

.. code-block:: bash

    [ build $HOME/brainvisa/build/bug_fix ]
      build_type = Release
      [ if '%(os)'.startswith('linux') ]
        packaging_thirdparty = ON
      [ else ]
        packaging_thirdparty = OFF
      [ endif ]
      [ if gethostname() == 'my_machine' ]
        make_options = -j8
      [ else ]
        make_options = -j2
      [ endif ]
      standard bug_fix $HOME/brainvisa/source


Examples
========

.. warning:: TO DO

.. code-block:: bash

    [ source $HOME/brainvisa/source ]
      + standard trunk
      + standard bug_fix
      - communication
      + perso/myself/myproject

    [ build $HOME/brainvisa/build/bug_fix ]
      build_type = Release
      make_options = -j8
      standard bug_fix $HOME/brainvisa/source

    [ build $HOME/brainvisa/build/trunk ]
      make_options = -j8
      standard trunk $HOME/brainvisa/source
      - connectomist-*
      + $HOME/brainvisa/source/perso/myself/myproject


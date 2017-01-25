===============
CMake functions
===============

``Brainvisa-cmake`` provides a set of CMake functions which help configuring Brainbisa-cmake projects. They can (should) be used within ``CMakeLists.txt`` files of peojects.


.. _brainvisa_add_test:

brainvisa_add_test
------------------

::

    BRAINVISA_ADD_TEST( NAME <name> [CONFIGURATIONS [Debug|Release|...]]
                                    [WORKING_DIRECTORY dir]
                        COMMAND <command> [arg1 [arg2 ...]]
                                    [TYPE Exe|Python] )

Add a test to the project with the specified arguments.
brainvisa_add_test(testname Exename arg1 arg2 ... )
If ``TYPE Python`` is given, the appropriate python interpreter is used to
start the test (i.e.: target python for cross compiling case).
Test command is also launched through bv_env_test command.

ex:

.. code-block:: cmake

    brainvisa_add_test(axon-tests "${TARGET_PYTHON_EXECUTABLE_NAME}" -m brainvisa.tests.test_axon)


.. _brainvisa_generate_doxygen_doc:

brainvisa_generate_doxygen_doc
------------------------------

Add rules to generate doxygen documentation with "make doc" or "make devdoc".

::

    BRAINVISA_GENERATE_DOXYGEN_DOC( <input_variable> [<file to copy> ...] [INPUT_PREFIX <path>] [COMPONENT <name>] )

``<input_variable>``
    variable containing a string or a list of input sources.
    Its content will be copied in the ``INPUT`` field of the
    Doxygen configuration file.

``<file to copy>``
    file (relative to ``${CMAKE_CURRENT_SOURCE_DIR}``) to copy in
    the build tree. Files are copied in ``${DOXYGEN_BINARY_DIR}``
    if defined, otherwise they are copied in
    ``${PROJECT_BINARY_DIR}/doxygen``. The doxygen configuration
    file is generated in the same directory.

``INPUT_PREFIX``
    directory where to find input files

``COMPONENT``
    component name for this doxygen documentation. it is used to create the output directory and the tag file name.
    By default it is the ``PROJECT_NAME``. but it is useful to give an alternative name when there are several libraries documented with doxygen in the same project.

Before calling this macro, it is possible to specify values that are going to be written in doxygen configuration file by setting variable names ``DOXYFILE_<doxyfile variable name>``. For instance, in order to set project name in Doxygen, one should use:

.. code-block:: cmake

    set( DOXYFILE_PROJECT_NAME, "My wonderful project" ).

Example:

.. code-block:: cmake

    find_package( Doxygen )
    if( DOXYGEN_FOUND )
      set(component_name "cartodata")
      set( DOXYFILE_PREDEFINED "${AIMS_DEFINITIONS}")
      set( DOXYFILE_TAGFILES "cartobase.tag=../../cartobase-${${PROJECT_NAME}_VERSION_MAJOR}.${${PROJECT_NAME}_VERSION_MINOR}/doxygen")
      BRAINVISA_GENERATE_DOXYGEN_DOC(
        _headers
        INPUT_PREFIX "${CMAKE_BINARY_DIR}/include/${component_name}"
        COMPONENT "${component_name}")
    endif( DOXYGEN_FOUND )


.. _brainvisa_generate_sphinx_doc:

brainvisa_generate_sphinx_doc
-----------------------------

Add rules to generate sphinx documentation with ``make doc`` or ``make <component>-doc`` or ``make devdoc`` or ``make <component>-devdoc``.

::

    BRAINVISA_GENERATE_SPHINX_DOC( <source directory> <output directory>
                                   [TARGET <target_name>]
                                   [USER] )

Example:

.. code-block:: cmake

    BRAINVISA_GENERATE_SPHINX_DOC( "doc/source"
      "share/doc/soma-workflow-${BRAINVISA_PACKAGE_VERSION_MAJOR}.${BRAINVISA_PACKAGE_VERSION_MINOR}" )

if ``TARGET`` argument is not specified, the target name defaults to ``${PROJECT_NAME}-sphinx``

if ``USER`` is specified, the generated doc will be part of the usrdoc (user
documentation) global target, and included in user docs packages.
Otherwise, by default, sphinx docs are considered developer docs (devdoc)


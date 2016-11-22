===============
BrainVisa-Cmake
===============

Build system based on `CMake <https://cmake.org>`_

It handles all CMake does (compilation for compiled languages, build directopry preparation, test, installation), plus:

* Multi-project handling: builds in a single build directory tree a set of projects
* Manages easy source repositories syncronization
* Integrates in a common BrainVisa environment
* Packaging (see the brainvisa-installer project)

BrainVisa-Cmake consists in several connected parts, mainly:

* CMake environment
* Python modules and tools
* the bv_maker program
* the bv_env program


:doc:`How to compile BrainVISA projects <compile_existing>`
===========================================================

:doc:`The bv_maker.cfg configuration file <configuration>`
==========================================================

:doc:`How to compile a new project with brainvisa-cmake <new_project>`
======================================================================

:doc:`Dependencies in brainvisa-cmake <dependencies>`
=====================================================

:doc:`bv_maker command documentation <bv_maker>`
================================================

:doc:`bv_env program and similar shell scripts <bv_env>`
========================================================

:doc:`bv_packaging script <bv_packaging>`
=========================================


Contents
========

.. toctree::
    :maxdepth: 2

    compile_existing
    configuration
    new_project
    dependencies
    bv_maker
    bv_env
    bv_packaging

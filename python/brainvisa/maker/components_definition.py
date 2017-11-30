# -*- coding: utf-8 -*-
import os
import sys

components_definition = [
    ('development', {
        'components': [
            ['brainvisa-cmake', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    # trunk actually points to bug_fix branch, because both
                    # have to be synchronized. trunk will be reserved for
                    # future incompatible releases.
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-cmake/branches/bug_fix','development/brainvisa-cmake/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-cmake/branches/bug_fix','development/brainvisa-cmake/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-cmake/branches/bug_fix','development/brainvisa-cmake/latest_release'),
                },
            }],
            ['brainvisa-installer', {
                'groups': ['all', 'opensource', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-installer/trunk','brainvisa-installer/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-installer/branches/bug_fix','brainvisa-installer/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-installer/tags/latest_release','brainvisa-installer/latest_release'),
                },
            }],
            ['casa-distro', {
                'groups': ['all', 'cati_platform', 'opensource'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/casa-distro/branches/bug_fix','casa-distro/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/casa-distro/branches/bug_fix','casa-distro/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/casa-distro/branches/bug_fix','casa-distro/latest_release'),
                },
                'build_model': 'pure_python',
            }],
        ],
    }),
    ('communication', {
        'components': [
            ['documentation', {
                'groups': ['all', 'opensource', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/documentation/trunk','communication/documentation/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/documentation/branches/bug_fix','communication/documentation/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/documentation/tags/latest_release','communication/documentation/latest_release'),
                },
            }],
            ['bibliography', {
                'groups': ['all', 'opensource', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/bibliography/trunk','communication/bibliography/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/bibliography/trunk','communication/bibliography/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/bibliography/trunk','communication/bibliography/latest_release'),
                },
            }],
            ['latex', {
                'groups': ['all', 'opensource', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/latex/trunk','communication/latex/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/latex/trunk','communication/latex/bug_fix'),
                },
            }],
            ['web', {
                'groups': ['all', 'opensource', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/web/trunk','communication/web/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/web/branches/bug_fix','communication/web/bug_fix'),
                    # WARNING latest_release points to bug_fix (to allow site evolve with
                    # fixed versions of projects)
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/web/branches/bug_fix','communication/web/latest_release'),
                },
            }],
        ],
    }),
    ('brainvisa-share', {
        'components': [
            ['brainvisa-share', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainvisa-share/trunk','brainvisa-share/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainvisa-share/branches/bug_fix','brainvisa-share/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainvisa-share/tags/latest_release','brainvisa-share/latest_release'),
                },
            }],
        ],
    }),
    ('soma', {
        'description': 'Set of lower-level libraries for neuroimaging processing infrastructure',
        'components': [
            ['soma-base', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-base/trunk','soma/soma-base/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-base/branches/bug_fix','soma/soma-base/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-base/tags/latest_release','soma/soma-base/latest_release'),
                },
            }],
            ['soma-io', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io/trunk','soma/soma-io/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io/branches/bug_fix','soma/soma-io/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io/tags/latest_release','soma/soma-io/latest_release'),
                },
            }],
            ['soma-database', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-database/trunk','soma/soma-database/trunk'),
                },
            }],
            ['soma-io-gpl', {
                'groups': ['all', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io-gpl/trunk','soma/soma-io-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io-gpl/branches/bug_fix','soma/soma-io-gpl/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io-gpl/tags/latest_release','soma/soma-io-gpl/latest_release'),
                },
            }],
            ['soma-workflow', {
                'groups': ['all', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/neurospin/soma-workflow.git branch:integration','soma/soma-workflow/trunk'),
                    'bug_fix': ('git https://github.com/neurospin/soma-workflow.git default:master','soma/soma-workflow/bug_fix'),
                    'latest_release': ('git https://github.com/neurospin/soma-workflow.git tag:latest_release','soma/soma-workflow/latest_release'),
                },
            }],
        ],
    }),
    ('capsul', {
        'components': [
            ['capsul', {
                'groups': ['all', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/neurospin/capsul.git branch:integration','capsul/trunk'),
                    'bug_fix': ('git https://github.com/neurospin/capsul.git default:master','capsul/bug_fix'),
                    'latest_release': ('git https://github.com/neurospin/capsul.git tag:latest_release','capsul/latest_release'),
                },
                'build_model': 'pure_python',
            }],
        ],
    }),
    ('aims', {
        'description': '3D/4D neuroimaging data manipulation and processing library and commands. Includes C++ libraries, command lines, and a Python API.',
        'components': [
            ['aims-free', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-free/trunk','aims/aims-free/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-free/branches/bug_fix','aims/aims-free/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-free/tags/latest_release','aims/aims-free/latest_release'),
                },
            }],
            ['aims-gpl', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-gpl/trunk','aims/aims-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-gpl/branches/bug_fix','aims/aims-gpl/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-gpl/tags/latest_release','aims/aims-gpl/latest_release'),
                },
            }],
            ['aims-til', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-til/trunk','aims/aims-til/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-til/branches/bug_fix','aims/aims-til/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-til/tags/latest_release','aims/aims-til/latest_release'),
                },
            }],
        ],
    }),
    ('anatomist', {
        'description': '3D/4D neuroimaging data viewer. Modular and versatile, Anatomist can display any kind of neuroimaging data (3D/4D images, meshes and textures, fiber tracts, and structured sets of objects such as cortical sulci), in an arbitrary number of views. Allows C++ and Python programming, both for plugins add-ons, as well as complete custom graphical applications design.',
        'components': [
            ['anatomist-free', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-free/trunk','anatomist/anatomist-free/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-free/branches/bug_fix','anatomist/anatomist-free/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-free/tags/latest_release','anatomist/anatomist-free/latest_release'),
                },
            }],
            ['anatomist-gpl', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-gpl/trunk','anatomist/anatomist-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-gpl/branches/bug_fix','anatomist/anatomist-gpl/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-gpl/tags/latest_release','anatomist/anatomist-gpl/latest_release'),
                },
            }],
        ],
    }),
    ('axon', {
        'description': 'Axon organizes processing, pipelining, and data management for neuroimaging. It works both as a graphical user interface or batch and programming interfaces, and allows transparent processing distribution on a computing resource.',
        'components': [
            ['axon', {
                'groups': ['all', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/axon/trunk','axon/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/axon/branches/bug_fix','axon/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/axon/tags/latest_release','axon/latest_release'),
                },
            }],
        ],
    }),
    ('spm', {
        'description': 'Python module and Axon toolbox for SPM.',
        'components': [
            ['spm', {
                'groups': ['all', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/spm/trunk','spm/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/spm/branches/bug_fix','spm/bug_fix'),
                    #'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/spm/tags/latest_release','axon/latest_release'),
                },
            }],
        ],
    }),
    ('axon_web', {
        'components': [
            ['axon_web', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/axon_web/trunk','axon_web/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/axon_web/branches/4.0','axon_web/branches/4.0'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/axon_web/tags/4.0.2','axon_web/tags/4.0.2'),
                },
            }],
        ],
    }),
    ('datamind', {
        'description': 'Statistics, data mining, machine learning.',
        'components': [
            ['datamind', {
                'groups': ['all', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/datamind/trunk','datamind/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/datamind/branches/bug_fix','datamind/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/datamind/tags/latest_release','datamind/latest_release'),
                },
            }],
        ],
    }),
    ('morphologist', {
        'description': 'Anatomical MRI (T1) analysis toolbox, featuring cortex and sulci segmentation, and sulci analysis tools, by the <a href="http://lnao.fr">LNAO team</a>.',
        'components': [
            ['morphologist-private', {
                'groups': ['all', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-private/trunk','morphologist/morphologist-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-private/branches/bug_fix','morphologist/morphologist-private/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-private/tags/latest_release','morphologist/morphologist-private/latest_release'),
                },
            }],
            ['morphologist-gpl', {
                'groups': ['all', 'opensource', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-gpl/trunk','morphologist/morphologist-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-gpl/branches/bug_fix','morphologist/morphologist-gpl/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-gpl/tags/latest_release','morphologist/morphologist-gpl/latest_release'),
                },
            }],
            ['baby', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/baby/trunk','morphologist/baby/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/baby/branches/bug_fix','morphologist/baby/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/baby/tags/latest_release','morphologist/baby/latest_release'),
                },
            }],
            ['tms', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/tms/trunk','morphologist/tms/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/tms/branches/bug_fix','morphologist/tms/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/tms/tags/latest_release','morphologist/tms/latest_release'),
                },
            }],
            ['sulci-data', {
                'groups': ['all', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-data/trunk','morphologist/sulci-data/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-data/trunk','morphologist/sulci-data/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-data/tags/2008','morphologist/sulci-data/tags/2008'),
                },
            }],
            ['sulci-private', {
                'groups': ['all', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-private/trunk','morphologist/sulci-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-private/branches/bug_fix','morphologist/sulci-private/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-private/tags/latest_release','morphologist/sulci-private/latest_release'),
                },
            }],
            ['sulci-models', {
                'groups': ['all', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-models/trunk','morphologist/sulci-models/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-models/branches/bug_fix','morphologist/sulci-models/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-models/branches/bug_fix','morphologist/sulci-models/latest_release'),
                },
            }],
            ['morphologist-ui', {
                'groups': ['all', 'opensource', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/neurospin/morphologist.git branch:integration', 'morphologist/morphologist-ui/trunk'),
                    'bug_fix': ('git https://github.com/neurospin/morphologist.git default:master', 'morphologist/morphologist-ui/bug_fix'),
                    'latest_release': ('git https://github.com/neurospin/morphologist.git tag:latest_release', 'morphologist/morphologist-ui/latest_release'),
                },
            }],
        ],
    }),
    ('brainrat', {
        'description': 'Ex vivo 3D reconstruction and analysis toolbox, from the <a href="http://www-dsv.cea.fr/dsv/instituts/institut-d-imagerie-biomedicale-i2bm/services/mircen-mircen/unite-cnrs-ura2210-lmn/fiches-thematiques/traitement-et-analyse-d-images-biomedicales-multimodales-du-cerveau-normal-ou-de-modeles-precliniques-de-maladies-cerebrales">BioPICSEL CEA team</a>. Homepage: <a href="http://brainvisa.info/doc/brainrat-gpl/brainrat_man/en/html/index.html">http://brainvisa.info/doc/brainrat-gpl/brainrat_man/en/html/index.html</a>',
        'components': [
            ['brainrat-gpl', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-gpl/trunk','brainrat/brainrat-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-gpl/branches/bug_fix','brainrat/brainrat-gpl/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-gpl/tags/latest_release','brainrat/brainrat-gpl/latest_release'),
                },
            }],
            ['brainrat-private', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-private/trunk','brainrat/brainrat-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-private/branches/bug_fix','brainrat/brainrat-private/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-private/tags/latest_release','brainrat/brainrat-private/latest_release'),
                },
            }],
            ['bioprocessing', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/bioprocessing/trunk','brainrat/bioprocessing/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/bioprocessing/branches/bug_fix','brainrat/bioprocessing/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/bioprocessing/tags/latest_release','brainrat/bioprocessing/latest_release'),
                },
            }],
            ['preclinical-imaging-iam', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/preclinical-imaging-iam/trunk','brainrat/preclinical-imaging-iam/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/preclinical-imaging-iam/branches/bug_fix','brainrat/preclinical-imaging-iam/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/preclinical-imaging-iam/tags/latest_release','brainrat/preclinical-imaging-iam/latest_release'),
                },
            }],
            ['primatologist-gpl', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/primatologist-gpl/trunk','brainrat/primatologist-gpl/trunk'),
                   'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/primatologist-gpl/branches/bug_fix','brainrat/primatologist-gpl/bug_fix'),
#                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/primatologist-gpl/tags/latest_release','brainrat/primatologist-gpl/latest_release'),
                },
            }],
        ],
    }),
    ('connectomist', {
        'components': [
            ['connectomist-private', {
                'groups': ['all'],
                'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/connectomist-private/trunk','connectomist/connectomist-private/trunk'),
                    #'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/connectomist-private/branches/bug_fix','connectomist/connectomist-private/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/connectomist-private/tags/4.0.2','connectomist/connectomist-private/tags/4.0.2'),
                },
            }],
            ['old_connectomist-gpl', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-gpl/trunk','connectomist/old_connectomist-gpl/trunk'),
                    #'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-gpl/branches/bug_fix','connectomist/old_connectomist-gpl/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-gpl/tags/latest_release','connectomist/old_connectomist-gpl/latest_release'),
                },
            }],
            ['old_connectomist-private', {
                'groups': ['all', 'standard'],
                'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-private/trunk','connectomist/old_connectomist-private/trunk'),
                    #'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-private/branches/bug_fix','connectomist/old_connectomist-private/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-private/tags/latest_release','connectomist/old_connectomist-private/latest_release'),
                },
            }],
        ],
    }),
    ('constellation', {
        'components': [
            ['constellation-gpl', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/constellation/constellation-gpl/trunk','constellation/constellation-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/constellation/constellation-gpl/branches/bug_fix','constellation/constellation-gpl/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/constellation/constellation-gpl/tags/latest_release','constellation/constellation-gpl/latest_release'),
                },
            }],
            ['constellation-private', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/constellation/constellation-private/trunk','constellation/constellation-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/constellation/constellation-private/branches/bug_fix','constellation/constellation-private/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/constellation/constellation-private/tags/latest_release','constellation/constellation-private/latest_release'),
                },
            }],
        ],
    }),
    ('cortical_surface', {
        'description': 'Cortex-based surfacic parameterization and analysis toolbox from the <a href="http://www.lsis.org">LSIS team</a>. Homepage: <a href="http://olivier.coulon.perso.esil.univmed.fr/brainvisa.html">http://olivier.coulon.perso.esil.univmed.fr/brainvisa.html</a>.<br/>Also contains the FreeSurfer toolbox for BrainVisa, by the LNAO team.',
        'components': [
            ['cortical_surface-private', {
                'groups': ['all', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-private/trunk','cortical_surface/cortical_surface-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-private/branches/bug_fix','cortical_surface/cortical_surface-private/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-private/tags/latest_release','cortical_surface/cortical_surface-private/latest_release'),
                },
            }],
            ['cortical_surface-gpl', {
                'groups': ['all', 'opensource', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-gpl/trunk','cortical_surface/cortical_surface-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-gpl/branches/bug_fix','cortical_surface/cortical_surface-gpl/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-gpl/tags/latest_release','cortical_surface/cortical_surface-gpl/latest_release'),
                },
            }],
            ['freesurfer_plugin', {
                'groups': ['all', 'opensource', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/freesurfer_plugin/trunk','cortical_surface/freesurfer_plugin/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/freesurfer_plugin/branches/bug_fix','cortical_surface/freesurfer_plugin/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/freesurfer_plugin/tags/latest_release','cortical_surface/freesurfer_plugin/latest_release'),
                },
            }],
        ],
    }),
    ('data_storage_client', {
        'components': [
            ['data_storage_client', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/data_storage_client/trunk','data_storage_client/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/data_storage_client/branches/bug_fix','data_storage_client/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/data_storage_client/tags/latest_release','data_storage_client/latest_release'),
                },
            }],
        ],
    }),
    #('famis', {
        #'components': [
            #['famis-private', {
                #'groups': ['all'],
                #'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/famis/famis-private/trunk','famis/famis-private/trunk'),
                #},
            #}],
        #],
    #}),
    ('highres-cortex', {
        'description': 'Sub-millimetric scale 3D brain image analysis',
        'components': [
            ['highres-cortex', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('git https://github.com/neurospin/highres-cortex.git default:master', 'highres-cortex/trunk'),
                    'bug_fix': ('git https://github.com/neurospin/highres-cortex.git default:master', 'highres-cortex/bug_fix'),
                },
            }],
        ],
    }),
    ('nuclear_imaging', {
        'components': [
            ['nuclear_imaging-gpl', {
                'groups': ['all', 'opensource', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-gpl/trunk','nuclear_imaging/nuclear_imaging-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-gpl/branches/bug_fix','nuclear_imaging/nuclear_imaging-gpl/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-gpl/tags/latest_release','nuclear_imaging/nuclear_imaging-gpl/latest_release'),
                },
            }],
            ['nuclear_imaging-private', {
                'groups': ['all', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-private/trunk','nuclear_imaging/nuclear_imaging-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-private/branches/bug_fix','nuclear_imaging/nuclear_imaging-private/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-private/tags/latest_release','nuclear_imaging/nuclear_imaging-private/latest_release'),
                },
            }],
        ],
    }),
    #('nuclear_processing', {
        #'components': [
            #['nuclear_processing-gpl', {
                #'groups': ['all'],
                #'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-gpl/trunk','nuclear_processing/nuclear_processing-gpl/trunk'),
                    #'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-gpl/branches/4.2','nuclear_processing/nuclear_processing-gpl/branches/4.2'),
                    #'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-gpl/tags/4.0.1','nuclear_processing/nuclear_processing-gpl/tags/4.0.1'),
                #},
            #}],
            #['nuclear_processing-private', {
                #'groups': ['all'],
                #'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-private/trunk','nuclear_processing/nuclear_processing-private/trunk'),
                    #'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-private/branches/4.2','nuclear_processing/nuclear_processing-private/branches/4.2'),
                    #'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-private/tags/4.0.1','nuclear_processing/nuclear_processing-private/tags/4.0.1'),
                #},
            #}],
        #],
    #}),
    #('optical_imaging', {
        #'components': [
            #['optical_imaging-private', {
                #'groups': ['all'],
                #'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-private/trunk','optical_imaging/optical_imaging-private/trunk'),
                    #'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-private/branches/4.2','optical_imaging/optical_imaging-private/branches/4.2'),
                    #'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-private/tags/4.2.2','optical_imaging/optical_imaging-private/tags/4.2.2'),
                #},
            #}],
            #['optical_imaging-gpl', {
                #'groups': ['all'],
                #'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-gpl/trunk','optical_imaging/optical_imaging-gpl/trunk'),
                    #'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-gpl/branches/4.2','optical_imaging/optical_imaging-gpl/branches/4.2'),
                    #'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-gpl/tags/4.2.2','optical_imaging/optical_imaging-gpl/tags/4.2.2'),
                #},
            #}],
        #],
    #}),
    ('ptk', {
        'components': [
            ['pyptk', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/pyptk/trunk','ptk/pyptk/trunk'),
                },
            }],
            ['fiber-clustering', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/toolbox-fiber-clustering/trunk','ptk/toolbox-fiber-clustering/trunk'),
                },
            }],
        ],
    }),
    #('pyhrf', {
        #'components': [
            #['pyhrf-free', {
                #'groups': ['all'],
                #'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/pyhrf/pyhrf-free/trunk','pyhrf/pyhrf-free/trunk'),
                #},
            #}],
            #['pyhrf-gpl', {
                #'groups': ['all'],
                #'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/pyhrf/pyhrf-gpl/trunk','pyhrf/pyhrf-gpl/trunk'),
                #},
            #}],
        #],
    #}),
    ('snapbase', {
        'components': [
            ['snapbase', {
                'groups': ['all', 'opensource', 'standard', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/snapbase/trunk','snapbase/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/snapbase/branches/bug_fix','snapbase/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/snapbase/tags/latest_release','snapbase/latest_release'),
                },
            }],
        ],
    }),
    ('catidb', {
        'components': [
            ['catidb3_server', { # Experimental branch to propose a new organization
                'groups': ['catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_server/trunk', 'catidb3_server/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_server/branches/bug_fix', 'catidb3_server/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_server/tags/latest_release', 'catidb3_server/latest_release'),
                },
            }],
            ['catidb3_client', { # Experimental branch to propose a new organization
                'groups': ['catidb3_all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_client/trunk','catidb3_client/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_client/branches/bug_fix', 'catidb3_client/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_client/tags/latest_release', 'catidb3_client/latest_release'),
                },
                'build_model': 'pure_python',
            }],
        ],
    }),
    ('release', {
        'components': [
            ['brainvisa-release', {
                'groups': ['all', 'opensource', 'standard', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-release/trunk','development/brainvisa-release/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-release/branches/bug_fix','development/brainvisa-release/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-release/tags/latest_release','development/brainvisa-release/latest_release'),
                },
            }],
        ],
    }),
    ('longitudinal_pipelines', {
        'components': [
            ['longitudinal_pipelines', {
                'groups': ['all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/longitudinal_pipelines/trunk',
                              'longitudinal_pipelines/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/longitudinal_pipelines/branches/bug_fix',
                              'longitudinal_pipelines/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/longitudinal_pipelines/tags/latest_release',
                              'longitudinal_pipelines/latest_release'),
                },
            }],
        ],
    }),
    ('disco', {
        'components': [
            ['disco', {
                'groups': ['all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/disco/trunk', 'disco/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/disco/branches/bug_fix', 'disco/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/disco/tags/latest_release', 'disco/latest_release'),
                },
            }],
        ],
    }),
    ('qualicati', {
        'description': 'CATI quality control software.',
        'components': [
            ['qualicati', {
                'groups': ['all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/qualicati/trunk','qualicati/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/qualicati/branches/bug_fix','qualicati/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/qualicati/tags/latest_release','qualicati/latest_release'),
                },
                'build_model': 'pure_python',
            }],
        ],
    }),
    ('fmri', {
        'description': 'Functional MRI processing toolboxes.',
        'components': [
            ['rsfmri', {
                'groups': ['all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/fmri/rsfmri/trunk','rsfmri/trunk'),
                    #'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/fmri/rsfmri/branches/bug_fix','rsfmri/bug_fix'),
                    #'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/fmri/rsfmri/tags/latest_release','rsfmri/latest_release'),
                },
                'build_model': 'pure_python',
            }],
        ],
    }),
]

customize_components_definition = [os.path.expanduser('~/.brainvisa/components_definition.py')]
if 'BV_MAKER_BUILD' in os.environ:
    customize_components_definition.append(os.path.join(os.environ['BV_MAKER_BUILD'], 'components_definition.py'))
for ccd in customize_components_definition:
    if os.path.exists(ccd):
        if sys.version_info[0] >= 3:
            code = compile(open(ccd).read(), ccd, 'exec')
            exec(code)
        else:
            execfile(ccd)

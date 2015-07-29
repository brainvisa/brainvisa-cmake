# -*- coding: utf-8 -*-
import os

components_definition = [
    ('development', {
        'components': [
            ['brainvisa-cmake', {
                'groups': ['all', 'anatomist', 'opensource', 'standard','catidb'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-cmake/trunk','development/brainvisa-cmake/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-cmake/branches/bug_fix','development/brainvisa-cmake/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-cmake/tags/1.2.1','development/brainvisa-cmake/tag'),
                },
            }],
            ['brainvisa-svn', {
                'groups': ['all', 'opensource', 'standard', 'catidb'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-svn/trunk','development/brainvisa-svn/trunk'),
                },
            }],
        ],
    }),
    ('communication', {
        'components': [
            ['documentation', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/documentation/trunk','communication/documentation/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/documentation/branches/bug_fix','communication/documentation/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/documentation/tags/4.4.0','communication/documentation/tags/4.4.0'),
                },
            }],
            ['bibliography', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/bibliography/trunk','communication/bibliography/trunk'),
                },
            }],
            ['latex', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/latex/trunk','communication/latex/trunk'),
                },
            }],
            ['web', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/web/trunk','communication/web/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/web/branches/bug_fix','communication/web/bug_fix'),
                },
            }],
        ],
    }),
    ('brainvisa-installer', {
        'components': [
            ['brainvisa-installer', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainvisa-installer/trunk','brainvisa-installer/trunk'),
                },
            }],
        ],
    }),
    ('brainvisa-share', {
        'components': [
            ['brainvisa-share', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainvisa-share/trunk','brainvisa-share/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainvisa-share/branches/bug_fix','brainvisa-share/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainvisa-share/tags/4.4.0','brainvisa-share/tags/4.4.0'),
                },
            }],
        ],
    }),
    ('soma', {
        'description': 'Set of lower-level libraries for neuroimaging processing infrastructure',
        'components': [
            ['soma-base', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-base/trunk','soma/soma-base/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-base/branches/bug_fix','soma/soma-base/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-base/tags/4.4.0','soma/soma-base/tags/4.4.0'),
                },
            }],
            ['soma-io', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io/trunk','soma/soma-io/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io/branches/bug_fix','soma/soma-io/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io/tags/4.4.0','soma/soma-io/tags/4.4.0'),
                },
            }],
            ['soma-qtgui', {
                'groups': ['all', 'anatomist', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-qtgui/trunk','soma/soma-qtgui/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-qtgui/branches/4.4','soma/soma-qtgui/branches/4.4'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-qtgui/tags/4.4.0','soma/soma-qtgui/tags/4.4.0'),
                },
            }],
            #['corist', {
                #'groups': ['all', 'opensource', 'standard', 'catidb'],
                #'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/corist/trunk','soma/corist/trunk'),
                #},
            #}],
            ['soma-base-gpl', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-base-gpl/branches/1.0','soma/soma-base-gpl/branches/1.0'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-base-gpl/tags/1.0.0','soma/soma-base-gpl/tags/1.0.0'),
                },
            }],
            ['soma-database', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-database/trunk','soma/soma-database/trunk'),
                },
            }],
            ['soma-io-gpl', {
                'groups': ['all', 'opensource', 'standard', 'catidb'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io-gpl/trunk','soma/soma-io-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io-gpl/branches/1.0','soma/soma-io-gpl/branches/1.0'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io-gpl/tags/1.0.0','soma/soma-io-gpl/tags/1.0.0'),
                },
            }],
            ['soma-pipeline', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-pipeline/trunk','soma/soma-pipeline/trunk'),
                },
            }],
            ['soma-workflow', {
                'groups': ['all', 'opensource', 'standard', 'catidb'],
                'branches': {
                    'trunk': ('git https://github.com/neurospin/soma-workflow.git master','soma/soma-workflow/trunk'),
                    'bug_fix': ('git https://github.com/neurospin/soma-workflow.git bug_fix','soma/soma-workflow/bug_fix'),
                    'tag': ('git https://github.com/neurospin/soma-workflow.git latest_release','soma/soma-workflow/latest_release'),
                },
            }],
        ],
    }),
    ('capsul', {
        'components': [
            ['capsul', {
                'groups': ['all', 'opensource', 'standard', 'catidb'],
                'branches': {
                    #'bug_fix': ('git https://github.com/neurospin/capsul.git master','capsul/bug_fix'),
                    'trunk': ('git https://github.com/neurospin/capsul.git master','capsul/trunk'),
                },
                'build_model': 'pure_python',
            }],
        ],
    }),
    ('aims', {
        'description': '3D/4D neuroimaging data manipulation and processing library and commands. Includes C++ libraries, command lines, and a Python API.',
        'components': [
            ['aims-free', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-free/trunk','aims/aims-free/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-free/branches/bug_fix','aims/aims-free/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-free/tags/4.4.0','aims/aims-free/tags/4.4.0'),
                },
            }],
            ['aims-gpl', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-gpl/trunk','aims/aims-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-gpl/branches/bug_fix','aims/aims-gpl/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-gpl/tags/4.4.0','aims/aims-gpl/tags/4.4.0'),
                },
            }],
            ['aims-til', {
                'groups': ['all', 'anatomist', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-til/trunk','aims/aims-til/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-til/branches/bug_fix','aims/aims-til/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-til/tags/1.2.0','aims/aims-til/tags/1.2.0'),
                },
            }],
        ],
    }),
    ('anatomist', {
        'description': '3D/4D neuroimaging data viewer. Modular and versatile, Anatomist can display any kind of neuroimaging data (3D/4D images, meshes and textures, fiber tracts, and structured sets of objects such as cortical sulci), in an arbitrary number of views. Allows C++ and Python programming, both for plugins add-ons, as well as complete custom graphical applications design.',
        'components': [
            ['anatomist-free', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-free/trunk','anatomist/anatomist-free/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-free/branches/bug_fix','anatomist/anatomist-free/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-free/tags/4.4.0','anatomist/anatomist-free/tags/4.4.0'),
                },
            }],
            ['anatomist-gpl', {
                'groups': ['all', 'anatomist', 'opensource', 'standard', 'catidb'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-gpl/trunk','anatomist/anatomist-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-gpl/branches/bug_fix','anatomist/anatomist-gpl/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-gpl/tags/4.4.0','anatomist/anatomist-gpl/tags/4.4.0'),
                },
            }],
        ],
    }),
    ('axon', {
        'description': 'Axon organizes processing, pipelining, and data management for neuroimaging. It works both as a graphical user interface or batch and programming interfaces, and allows transparent processing distribution on a computing resource.',
        'components': [
            ['axon', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/axon/trunk','axon/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/axon/branches/bug_fix','axon/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/axon/tags/4.4.0','axon/tags/4.4.0'),
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
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/axon_web/tags/4.0.2','axon_web/tags/4.0.2'),
                },
            }],
        ],
    }),
    ('datamind', {
        'description': 'Statistics, data mining, machine learning.',
        'components': [
            ['datamind', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/datamind/trunk','datamind/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/datamind/branches/bug_fix','datamind/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/datamind/tags/4.3.0','datamind/tags/4.3.0'),
                },
            }],
        ],
    }),
    ('morphologist', {
        'description': 'Anatomical MRI (T1) analysis toolbox, featuring cortex and sulci segmentation, and sulci analysis tools, by the <a href="http://lnao.fr">LNAO team</a>.',
        'components': [
            ['morphologist-private', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-private/trunk','morphologist/morphologist-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-private/branches/bug_fix','morphologist/morphologist-private/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-private/tags/4.4.0','morphologist/morphologist-private/tags/4.4.0'),
                },
            }],
            ['morphologist-gpl', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-gpl/trunk','morphologist/morphologist-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-gpl/branches/bug_fix','morphologist/morphologist-gpl/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-gpl/tags/4.4.0','morphologist/morphologist-gpl/tags/4.4.0'),
                },
            }],
            ['baby', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/baby/trunk','morphologist/baby/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/baby/branches/bug_fix','morphologist/baby/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/baby/tags/1.1.0','morphologist/baby/tags/1.1.0'),
                },
            }],
            ['tms', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/tms/trunk','morphologist/tms/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/tms/branches/bug_fix','morphologist/tms/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/tms/tags/4.3.0','morphologist/tms/tags/4.3.0'),
                },
            }],
            ['sulci-data', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-data/trunk','morphologist/sulci-data/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-data/branches/4.2','morphologist/sulci-data/branches/4.2'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-data/tags/2008','morphologist/sulci-data/tags/2008'),
                },
            }],
            ['sulci-private', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-private/trunk','morphologist/sulci-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-private/branches/bug_fix','morphologist/sulci-private/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-private/tags/4.4.0','morphologist/sulci-private/tags/4.4.0'),
                },
            }],
            ['morphologist-common', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-common/trunk','morphologist/morphologist-common/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-common/branches/1.0','morphologist/morphologist-common/branches/1.0'),
                },
            }],
            ['sulci-models', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-models/trunk','morphologist/sulci-models/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-models/branches/bug_fix','morphologist/sulci-models/bug_fix'),
                },
            }],
            #['morphologist-ui', {
                #'groups': ['all'],
                #'branches': {
                    #'trunk': ('git https://github.com/neurospin/morphologist.git master', 'morphologist/morphologist-ui/trunk'),
                #},
            #}],
        ],
    }),
    ('brainrat', {
        'description': 'Ex vivo 3D reconstruction and analysis toolbox, from the <a href="http://www-dsv.cea.fr/dsv/instituts/institut-d-imagerie-biomedicale-i2bm/services/mircen-mircen/unite-cnrs-ura2210-lmn/fiches-thematiques/traitement-et-analyse-d-images-biomedicales-multimodales-du-cerveau-normal-ou-de-modeles-precliniques-de-maladies-cerebrales">BioPICSEL CEA team</a>. Homepage: <a href="http://brainvisa.info/doc/brainrat-gpl/brainrat_man/en/html/index.html">http://brainvisa.info/doc/brainrat-gpl/brainrat_man/en/html/index.html</a>',
        'components': [
            ['brainrat-gpl', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-gpl/trunk','brainrat/brainrat-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-gpl/branches/bug_fix','brainrat/brainrat-gpl/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-gpl/tags/4.4.0','brainrat/brainrat-gpl/tags/4.4.0'),
                },
            }],
            ['brainrat-private', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-private/trunk','brainrat/brainrat-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-private/branches/bug_fix','brainrat/brainrat-private/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-private/tags/4.4.0','brainrat/brainrat-private/tags/4.4.0'),
                },
            }],
            ['bioprocessing', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/bioprocessing/trunk','brainrat/bioprocessing/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/bioprocessing/branches/bug_fix','brainrat/bioprocessing/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/bioprocessing/tags/4.4.0','brainrat/bioprocessing/tags/4.4.0'),
                },
            }],
            ['preclinical-imaging-iam', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/preclinical-imaging-iam/trunk','brainrat/preclinical-imaging-iam/trunk'),
                    #'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/preclinical-imaging-iam/branches/bug_fix','brainrat/preclinical-imaging-iam/branches/bug_fix'),
                    #'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/preclinical-imaging-iam/tags/latest_release','brainrat/preclinical-imaging-iam/tags/latest_release'),
                },
            }],
        ],
    }),
    ('connectomist', {
        'components': [
            ['connectomist-private', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/connectomist-private/trunk','connectomist/connectomist-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/connectomist-private/branches/bug_fix','connectomist/connectomist-private/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/connectomist-private/tags/4.0.2','connectomist/connectomist-private/tags/4.0.2'),
                },
            }],
            ['old_connectomist-gpl', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-gpl/trunk','connectomist/old_connectomist-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-gpl/branches/bug_fix','connectomist/old_connectomist-gpl/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-gpl/tags/4.4.0','connectomist/old_connectomist-gpl/tags/4.4.0'),
                },
            }],
            ['old_connectomist-private', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-private/trunk','connectomist/old_connectomist-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-private/branches/bug_fix','connectomist/old_connectomist-private/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-private/tags/4.4.0','connectomist/old_connectomist-private/tags/4.4.0'),
                },
            }],
            ['constellation-gpl', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/constellation-gpl/trunk','connectomist/constellation-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/constellation-gpl/branches/bug_fix','connectomist/constellation-gpl/bug_fix'),
                },
            }],
            ['constellation-private', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/constellation-private/trunk','connectomist/constellation-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/constellation-private/branches/bug_fix','connectomist/constellation-private/bug_fix'),
                },
            }],
        ],
    }),
    ('cortical_surface', {
        'description': 'Cortex-based surfacic parameterization and analysis toolbox from the <a href="http://www.lsis.org">LSIS team</a>. Homepage: <a href="http://olivier.coulon.perso.esil.univmed.fr/brainvisa.html">http://olivier.coulon.perso.esil.univmed.fr/brainvisa.html</a>.<br/>Also contains the FreeSurfer toolbox for BrainVisa, by the LNAO team.',
        'components': [
            ['cortical_surface-private', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-private/trunk','cortical_surface/cortical_surface-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-private/branches/bug_fix','cortical_surface/cortical_surface-private/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-private/tags/4.4.0','cortical_surface/cortical_surface-private/tags/4.4.0'),
                },
            }],
            ['cortical_surface-gpl', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-gpl/trunk','cortical_surface/cortical_surface-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-gpl/branches/bug_fix','cortical_surface/cortical_surface-gpl/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-gpl/tags/4.4.0','cortical_surface/cortical_surface-gpl/tags/4.4.0'),
                },
            }],
            ['freesurfer_plugin', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/freesurfer_plugin/trunk','cortical_surface/freesurfer_plugin/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/freesurfer_plugin/branches/bug_fix','cortical_surface/freesurfer_plugin/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/freesurfer_plugin/tags/4.4.0','cortical_surface/freesurfer_plugin/tags/4.4.0'),
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
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/data_storage_client/tags/4.3.0','data_storage_client/tags/4.3.0'),
                },
            }],
        ],
    }),
    ('famis', {
        'components': [
            ['famis-private', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/famis/famis-private/trunk','famis/famis-private/trunk'),
                },
            }],
        ],
    }),
    ('fmri', {
        'components': [
            ['fmri-gpl', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/fmri/fmri-gpl/trunk','fmri/fmri-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/fmri/fmri-gpl/branches/4.0','fmri/fmri-gpl/branches/4.0'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/fmri/fmri-gpl/tags/4.0.0','fmri/fmri-gpl/tags/4.0.0'),
                },
            }],
        ],
    }),
    ('nuclear_imaging', {
        'components': [
            ['nuclear_imaging-gpl', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-gpl/trunk','nuclear_imaging/nuclear_imaging-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-gpl/branches/bug_fix','nuclear_imaging/nuclear_imaging-gpl/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-gpl/tags/4.2.1','nuclear_imaging/nuclear_imaging-gpl/tags/4.2.1'),
                },
            }],
            ['nuclear_imaging-private', {
                'groups': ['all', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-private/trunk','nuclear_imaging/nuclear_imaging-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-private/branches/bug_fix','nuclear_imaging/nuclear_imaging-private/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-private/tags/4.2.1','nuclear_imaging/nuclear_imaging-private/tags/4.2.1'),
                },
            }],
        ],
    }),
    ('nuclear_processing', {
        'components': [
            ['nuclear_processing-gpl', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-gpl/trunk','nuclear_processing/nuclear_processing-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-gpl/branches/4.2','nuclear_processing/nuclear_processing-gpl/branches/4.2'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-gpl/tags/4.0.1','nuclear_processing/nuclear_processing-gpl/tags/4.0.1'),
                },
            }],
            ['nuclear_processing-private', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-private/trunk','nuclear_processing/nuclear_processing-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-private/branches/4.2','nuclear_processing/nuclear_processing-private/branches/4.2'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-private/tags/4.0.1','nuclear_processing/nuclear_processing-private/tags/4.0.1'),
                },
            }],
        ],
    }),
    ('optical_imaging', {
        'components': [
            ['optical_imaging-private', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-private/trunk','optical_imaging/optical_imaging-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-private/branches/4.2','optical_imaging/optical_imaging-private/branches/4.2'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-private/tags/4.2.2','optical_imaging/optical_imaging-private/tags/4.2.2'),
                },
            }],
            ['optical_imaging-gpl', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-gpl/trunk','optical_imaging/optical_imaging-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-gpl/branches/4.2','optical_imaging/optical_imaging-gpl/branches/4.2'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-gpl/tags/4.2.2','optical_imaging/optical_imaging-gpl/tags/4.2.2'),
                },
            }],
        ],
    }),
    ('ptk', {
        'components': [
            ['pyptk', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/pyptk/trunk','ptk/pyptk/trunk'),
                },
            }],
            ['qualicati', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/qualicati/trunk','ptk/qualicati/trunk'),
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
    ('pyhrf', {
        'components': [
            ['pyhrf-free', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/pyhrf/pyhrf-free/trunk','pyhrf/pyhrf-free/trunk'),
                },
            }],
            ['pyhrf-gpl', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/pyhrf/pyhrf-gpl/trunk','pyhrf/pyhrf-gpl/trunk'),
                },
            }],
        ],
    }),
    ('sandbox', {
        'components': [
            ['nictk', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/sandbox/nictk/trunk','sandbox/nictk/trunk'),
                },
            }],
        ],
    }),
    ('snapbase', {
        'components': [
            ['snapbase', {
                'groups': ['all', 'opensource', 'standard', 'catidb'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/snapbase/trunk','snapbase/trunk'),
                },
            }],
        ],
    }),
    ('catidb', {
        'components': [
            ['catidb', {
                'groups': ['catidb'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb/trunk','catidb/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb/branches/release',' catidb/release'),
                    'brainomics': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb/branches/catidb_brainomics',' catidb/catidb_brainomics'),
                },
            }],
        ],
    }),
    ('release', {
        'components': [
            ['brainvisa-release', {
                'groups': ['all', 'opensource', 'standard'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-release/trunk','development/brainvisa-release/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-release/branches/bug_fix','development/brainvisa-release/bug_fix'),
                    'tag': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-release/tags/1.2.1','development/brainvisa-release/tags/1.2.1'),
                },
            }],
        ],
    }),
]

customize_components_definition = os.path.expanduser('~/.brainvisa/components_definition.py')
if os.path.exists(customize_components_definition):
    execfile(customize_components_definition)

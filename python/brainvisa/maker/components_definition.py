# -*- coding: utf-8 -*-
from __future__ import absolute_import

import os
import sys

# groups:
# anatomist: projects needed for anatomist (aims, soma-io and dependencies)
# opensource
# brainvisa: public brainvisa distro
# bvdev: same as brainvisa but excludes restricted access projects
#        (such as brainrat-private)
# standard: most useful projects. Includes internal, non-open projects,
#           but not restricted ones (such as brainrat-private)
# cea: CEA (Neurospin/MirCen/SHFJ) distro including internal projects
# cati_platform: standard + CATI projects
# all: all projects except those really not useful


components_definition = [
    ('development', {
        'components': [
            ['brainvisa-cmake', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/brainvisa-cmake.git branch:master','development/brainvisa-cmake/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/brainvisa-cmake.git branch:master','development/brainvisa-cmake/master'),
                    '5.0': ('git https://github.com/brainvisa/brainvisa-cmake.git branch:5.0','development/brainvisa-cmake/5.0'),
                    'latest_release': ('git https://github.com/brainvisa/brainvisa-cmake.git branch:master','development/brainvisa-cmake/latest_release'),
                },
            }],
            ['brainvisa-installer', {
                'groups': [],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/brainvisa-installer.git branch:master','development/brainvisa-installer/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/brainvisa-installer.git branch:master','development/brainvisa-installer/master'),
                    'latest_release': ('git https://github.com/brainvisa/brainvisa-installer.git branch:latest_release','development/brainvisa-installer/latest_release'),
                },
            }],
            ['casa-distro', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/casa-distro.git branch:master','development/casa-distro/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/casa-distro.git branch:master','development/casa-distro/master'),
                    '5.0': ('git https://github.com/brainvisa/casa-distro.git branch:brainvisa-5.0','development/casa-distro/5.0'),
                    'latest_release': ('git https://github.com/brainvisa/casa-distro.git branch:master','development/casa-distro/latest_release'),
                },
                'build_model': 'pure_python',
            }],
        ],
    }),
    ('communication', {
        'components': [
            ['documentation', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/documentation/tags/latest_release','communication/documentation/latest_release'),
                },
            }],
            ['web', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/web/trunk','communication/web/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/web/branches/bug_fix','communication/web/bug_fix'),
                    '5.0': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/web/branches/bug_fix','communication/web/5.0'),
                },
            }],
        ],
    }),
    ('brainvisa-share', {
        'components': [
            ['brainvisa-share', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/brainvisa-share.git branch:master','brainvisa-share/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/brainvisa-share.git branch:master','brainvisa-share/master'),
                    '5.0': ('git https://github.com/brainvisa/brainvisa-share.git branch:5.0','brainvisa-share/5.0'),
                    'latest_release': ('git https://github.com/brainvisa/brainvisa-share.git branch:latest_release','brainvisa-share/latest_release'),
                },
            }],
        ],
    }),
    ('soma', {
        'description': 'Set of lower-level libraries for neuroimaging processing infrastructure',
        'components': [
            ['soma-base', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/populse/soma-base.git branch:master','soma/soma-base/integration'),
                    'bug_fix': ('git https://github.com/populse/soma-base.git branch:master','soma/soma-base/master'),
                    '5.0': ('git https://github.com/populse/soma-base.git branch:5.0','soma/soma-base/5.0'),
                    'latest_release': ('git https://github.com/populse/soma-base.git branch:latest_release','soma/soma-base/latest_release'),
                },
            }],
            ['soma-io', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/soma-io.git branch:master','soma/soma-io/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/soma-io.git branch:master','soma/soma-io/master'),
                    '5.0': ('git https://github.com/brainvisa/soma-io.git branch:5.0','soma/soma-io/5.0'),
                    'latest_release': ('git https://github.com/brainvisa/soma-io.git branch:latest_release','soma/soma-io/latest_release'),
                },
            }],
            ['soma-io-gpl', {
                'groups': ['all', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io-gpl/trunk','soma/soma-io-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io-gpl/branches/bug_fix','soma/soma-io-gpl/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io-gpl/tags/latest_release','soma/soma-io-gpl/latest_release'),
                },
            }],
            ['soma-workflow', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/populse/soma-workflow.git branch:master','soma/soma-workflow/integration'),
                    'bug_fix': ('git https://github.com/populse/soma-workflow.git default:master','soma/soma-workflow/master'),
                    '5.0': ('git https://github.com/populse/soma-workflow.git branch:brainvisa-5.0','soma/soma-workflow/5.0'),
                    'latest_release': ('git https://github.com/populse/soma-workflow.git tag:latest_release','soma/soma-workflow/latest_release'),
                },
            }],
        ],
    }),
    ('populse', {
        'components': [
            ['capsul', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/populse/capsul.git branch:master','capsul/integration'),
                    'bug_fix': ('git https://github.com/populse/capsul.git default:master','capsul/master'),
                    '5.0': ('git https://github.com/populse/capsul.git branch:brainvisa-5.0','capsul/5.0'),
                    'latest_release': ('git https://github.com/populse/capsul.git tag:latest_release','capsul/latest_release'),
                },
                'build_model': 'pure_python',
            }],
            ['populse_db', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/populse/populse_db.git default:master','populse/populse_db/integration'),
                    'bug_fix': ('git https://github.com/populse/populse_db.git default:master','populse/populse_db/master'),
                    '5.0': ('git https://github.com/populse/populse_db.git branch:brainvisa-5.0','populse/populse_db/5.0'),
                },
                'build_model': 'pure_python',
            }],
        ],
    }),
    ('aims', {
        'description': '3D/4D neuroimaging data manipulation and processing library and commands. Includes C++ libraries, command lines, and a Python API.',
        'components': [
            ['aims-free', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/aims-free.git branch:master','aims/aims-free/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/aims-free.git branch:master','aims/aims-free/master'),
                    '5.0': ('git https://github.com/brainvisa/aims-free.git branch:5.0','aims/aims-free/5.0'),
                    'latest_release': ('git https://github.com/brainvisa/aims-free.git branch:latest_release','aims/aims-free/latest_release'),
                },
            }],
            ['aims-gpl', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/aims-gpl.git branch:master','aims/aims-gpl/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/aims-gpl.git branch:master','aims/aims-gpl/master'),
                    '5.0': ('git https://github.com/brainvisa/aims-gpl.git branch:5.0','aims/aims-gpl/5.0'),
                    'latest_release': ('git https://github.com/brainvisa/aims-gpl.git branch:latest_release','aims/aims-gpl/latest_release'),
                },
            }],
            ['aims-til', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/aims-til.git branch:master','aims/aims-til/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/aims-til.git branch:master','aims/aims-til/master'),
                    '5.0': ('git https://github.com/brainvisa/aims-til.git branch:5.0','aims/aims-til/5.0'),
                    'latest_release': ('git https://github.com/brainvisa/aims-til.git branch:latest_release','aims/aims-til/latest_release'),
                },
            }],
        ],
    }),
    ('anatomist', {
        'description': '3D/4D neuroimaging data viewer. Modular and versatile, Anatomist can display any kind of neuroimaging data (3D/4D images, meshes and textures, fiber tracts, and structured sets of objects such as cortical sulci), in an arbitrary number of views. Allows C++ and Python programming, both for plugins add-ons, as well as complete custom graphical applications design.',
        'components': [
            ['anatomist-free', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/anatomist-free.git branch:master','anatomist/anatomist-free/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/anatomist-free.git branch:master','anatomist/anatomist-free/master'),
                    '5.0': ('git https://github.com/brainvisa/anatomist-free.git branch:5.0','anatomist/anatomist-free/5.0'),
                    'latest_release': ('git https://github.com/brainvisa/anatomist-free.git branch:latest_release','anatomist/anatomist-free/latest_release'),
                },
            }],
            ['anatomist-gpl', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/anatomist-gpl.git branch:master','anatomist/anatomist-gpl/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/anatomist-gpl.git branch:master','anatomist/anatomist-gpl/master'),
                    '5.0': ('git https://github.com/brainvisa/anatomist-gpl.git branch:5.0','anatomist/anatomist-gpl/5.0'),
                    'latest_release': ('git https://github.com/brainvisa/anatomist-gpl.git branch:latest_release','anatomist/anatomist-gpl/latest_release'),
                },
            }],
        ],
    }),
    ('axon', {
        'description': 'Axon organizes processing, pipelining, and data management for neuroimaging. It works both as a graphical user interface or batch and programming interfaces, and allows transparent processing distribution on a computing resource.',
        'components': [
            ['axon', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/axon.git branch:master','axon/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/axon.git branch:master','axon/master'),
                    '5.0': ('git https://github.com/brainvisa/axon.git branch:5.0','axon/5.0'),
                    'latest_release': ('git https://github.com/brainvisa/axon.git branch:latest_release','axon/latest_release'),
                },
            }],
        ],
    }),
    ('brainvisa-spm', {
        'description': 'Python module and Axon toolbox for SPM.',
        'components': [
            ['brainvisa-spm', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/brainvisa-spm.git branch:integration','brainvisa-spm/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/brainvisa-spm.git branch:master','brainvisa-spm/master'),
                    '5.0': ('git https://github.com/brainvisa/brainvisa-spm.git branch:5.0','brainvisa-spm/5.0'),
                },
            }],
        ],
    }),
    ('datamind', {
        'description': 'Statistics, data mining, machine learning.',
        'components': [
            ['datamind', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    '5.0': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/datamind/branches/5.0','datamind/5.0'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/datamind/tags/latest_release','datamind/latest_release'),
                },
            }],
        ],
    }),

    ('highres-cortex', {
        'description': 'Process 3D images of the cerebral cortex at a sub-millimetre scale',
        'components': [
            ['highres-cortex', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/neurospin/highres-cortex.git branch:master','highres-cortex/integration'),
                    'bug_fix': ('git https://github.com/neurospin/highres-cortex.git default:master','highres-cortex/master'),
                    '5.0': ('git https://github.com/neurospin/highres-cortex.git branch:5.0','highres-cortex/5.0'),
                },
            }],
        ],
    }),

    ('morphologist', {
        'description': 'Anatomical MRI (T1) analysis toolbox, featuring cortex and sulci segmentation, and sulci analysis tools, by the <a href="http://lnao.fr">LNAO team</a>.',
        'components': [
            ['morphologist-private', {
                'groups': ['all', 'brainvisa', 'bvdev', 'standard', 'cea',
                           'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-private/trunk','morphologist/morphologist-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-private/branches/bug_fix','morphologist/morphologist-private/bug_fix'),
                    '5.0': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-private/branches/5.0','morphologist/morphologist-private/5.0'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-private/tags/latest_release','morphologist/morphologist-private/latest_release'),
                },
            }],
            ['morphologist-gpl', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-gpl/trunk','morphologist/morphologist-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-gpl/branches/bug_fix','morphologist/morphologist-gpl/bug_fix'),
                    '5.0': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-gpl/branches/5.0','morphologist/morphologist-gpl/5.0'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/morphologist-gpl/tags/latest_release','morphologist/morphologist-gpl/latest_release'),
                },
            }],
            ['baby', {
                'groups': ['all', 'standard', 'cea'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/baby/trunk','morphologist/baby/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/baby/branches/bug_fix','morphologist/baby/bug_fix'),
                    '5.0': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/baby/branches/5.0','morphologist/baby/5.0'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/baby/tags/latest_release','morphologist/baby/latest_release'),
                },
            }],
            ['tms', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/tms/trunk','morphologist/tms/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/tms/branches/bug_fix','morphologist/tms/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/tms/tags/latest_release','morphologist/tms/latest_release'),
                },
            }],
            ['sulci-data', {
                'groups': [],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-data/trunk','morphologist/sulci-data/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-data/trunk','morphologist/sulci-data/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-data/tags/2008','morphologist/sulci-data/tags/2008'),
                },
            }],
            ['sulci-nonfree', {
                'groups': ['all', 'brainvisa', 'bvdev', 'standard', 'cea',
                           'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/sulci-nonfree.git branch:integration','morphologist/sulci-nonfree/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/sulci-nonfree.git branch:master','morphologist/sulci-nonfree/master'),
                    '5.0': ('git https://github.com/brainvisa/sulci-nonfree.git branch:5.0','morphologist/sulci-nonfree/5.0'),
                },
            }],
            ['sulci-models', {
                'groups': [],
                'branches': {
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-models/branches/bug_fix','morphologist/sulci-models/latest_release'),
                },
            }],
            ['morphologist-ui', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/morphologist.git branch:master', 'morphologist/morphologist-ui/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/morphologist.git default:master', 'morphologist/morphologist-ui/master'),
                    '5.0': ('git https://github.com/brainvisa/morphologist.git branch:5.0', 'morphologist/morphologist-ui/5.0'),
                    'latest_release': ('git https://github.com/brainvisa/morphologist.git tag:latest_release', 'morphologist/morphologist-ui/latest_release'),
                },
            }],
            ['morpho-deepsulci', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/morpho-deepsulci.git branch:master', 'morphologist/morpho-deepsulci/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/morpho-deepsulci.git default:master', 'morphologist/morpho-deepsulci/master'),
                    '5.0': ('git https://github.com/brainvisa/morpho-deepsulci.git branch:5.0', 'morphologist/morpho-deepsulci/5.0'),
                },
            }],
        ],
    }),
    ('brainrat', {
        'description': 'Ex vivo 3D reconstruction and analysis toolbox, from the <a href="http://www-dsv.cea.fr/dsv/instituts/institut-d-imagerie-biomedicale-i2bm/services/mircen-mircen/unite-cnrs-ura2210-lmn/fiches-thematiques/traitement-et-analyse-d-images-biomedicales-multimodales-du-cerveau-normal-ou-de-modeles-precliniques-de-maladies-cerebrales">BioPICSEL CEA team</a>. Homepage: <a href="http://brainvisa.info/doc/brainrat-gpl/brainrat_man/en/html/index.html">http://brainvisa.info/doc/brainrat-gpl/brainrat_man/en/html/index.html</a>',
        'components': [
            ['brainrat-gpl', {
                'groups': ['all', 'brainvisa', 'cea'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/brainrat-gpl branch:master', 'brainrat/brainrat-gpl/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/brainrat-gpl branch:master', 'brainrat/brainrat-gpl/master'),
                    '5.0': ('git https://bioproj.extra.cea.fr/git/brainrat-gpl branch:5.0', 'brainrat/brainrat-gpl/5.0'),
                    'latest_release': ('git https://bioproj.extra.cea.fr/git/brainrat-gpl branch:latest_release', 'brainrat/brainrat-gpl/latest_release'),
                },
            }],
            ['brainrat-private', {
                'groups': ['all', 'brainvisa', 'cea'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/brainrat-private branch:master', 'brainrat/brainrat-private/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/brainrat-private branch:master', 'brainrat/brainrat-private/master'),
                    '5.0': ('git https://bioproj.extra.cea.fr/git/brainrat-private branch:5.0', 'brainrat/brainrat-private/5.0'),
                    'latest_release': ('git https://bioproj.extra.cea.fr/git/brainrat-private branch:latest_release', 'brainrat/brainrat-private/latest_release'),
                },
            }],
            ['bioprocessing', {
                'groups': ['all', 'cea'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/bioprocessing branch:master', 'brainrat/bioprocessing/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/bioprocessing branch:master', 'brainrat/bioprocessing/master'),
                    '5.0': ('git https://bioproj.extra.cea.fr/git/bioprocessing branch:5.0', 'brainrat/bioprocessing/5.0'),
                    'latest_release': ('git https://bioproj.extra.cea.fr/git/bioprocessing branch:latest_release', 'brainrat/bioprocessing/latest_release'),
                },
            }],
            ['preclinical-imaging-iam', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/preclinical-imaging-iam branch:master', 'brainrat/preclinical-imaging-iam/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/preclinical-imaging-iam branch:master', 'brainrat/preclinical-imaging-iam/master'),
                    'latest_release': ('git https://bioproj.extra.cea.fr/git/preclinical-imaging-iam branch:latest_release', 'brainrat/preclinical-imaging-iam/latest_release'),
                },
            }],
            ['primatologist-gpl', {
                'groups': ['all', 'brainvisa', 'cea'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/primatologist-gpl branch:master', 'brainrat/primatologist-gpl/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/primatologist-gpl branch:master', 'brainrat/primatologist-gpl/master'),
                    '5.0': ('git https://bioproj.extra.cea.fr/git/primatologist-gpl branch:5.0', 'brainrat/primatologist-gpl/5.0'),
                    'latest_release': ('git https://bioproj.extra.cea.fr/git/primatologist-gpl branch:latest_release', 'brainrat/primatologist-gpl/latest_release'),
                },
            }],
            ['3dns-private', {
                'groups': ['3dns'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/3dns-private branch:master', 'brainrat/3dns-private/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/3dns-private branch:master', 'brainrat/3dns-private/master'),
                    '5.0': ('git https://bioproj.extra.cea.fr/git/3dns-private branch:5.0', 'brainrat/3dns-private/5.0'),
#                    'latest_release': ('git https://bioproj.extra.cea.fr/git/3dns-private branch:latest_release', 'brainrat/3dns-private/latest_release'),
                },
            }],
        ],
    }),
    ('connectomist', {
        'components': [
            ['connectomist-private', {
                'groups': [],
                'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/connectomist-private/trunk','connectomist/connectomist-private/trunk'),
                    #'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/connectomist-private/branches/bug_fix','connectomist/connectomist-private/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/connectomist-private/tags/4.0.2','connectomist/connectomist-private/tags/4.0.2'),
                },
            }],
            ['old_connectomist-gpl', {
                'groups': [],
                'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-gpl/trunk','connectomist/old_connectomist-gpl/trunk'),
                    #'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-gpl/branches/bug_fix','connectomist/old_connectomist-gpl/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-gpl/tags/latest_release','connectomist/old_connectomist-gpl/latest_release'),
                },
            }],
            ['old_connectomist-private', {
                'groups': [],
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
                'groups': ['all', 'cea'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/constellation-gpl.git branch:integration','constellation/constellation-gpl/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/constellation-gpl.git branch:master','constellation/constellation-gpl/master'),
                    '5.0': ('git https://github.com/brainvisa/constellation-gpl.git branch:5.0','constellation/constellation-gpl/5.0'),
                },
            }],
            ['constellation-nonfree', {
                'groups': ['all', 'cea'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/constellation-nonfree.git branch:integration','constellation/constellation-nonfree/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/constellation-nonfree.git branch:master','constellation/constellation-nonfree/master'),
                    '5.0': ('git https://github.com/brainvisa/constellation-nonfree.git branch:5.0','constellation/constellation-nonfree/5.0'),
                },
            }],
        ],
    }),
    ('cortical_surface', {
        'description': 'Cortex-based surfacic parameterization and analysis toolbox from the <a href="http://www.lsis.org">LSIS team</a>. Homepage: <a href="http://olivier.coulon.perso.esil.univmed.fr/brainvisa.html">http://olivier.coulon.perso.esil.univmed.fr/brainvisa.html</a>.<br/>Also contains the FreeSurfer toolbox for BrainVisa, by the LNAO team.',
        'components': [
            ['cortical_surface-nonfree', {
                'groups': ['all', 'brainvisa', 'bvdev', 'standard', 'cea',
                           'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/cortical_surface-nonfree.git branch:integration','cortical_surface/cortical_surface-nonfree/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/cortical_surface-nonfree.git branch:master','cortical_surface/cortical_surface-nonfree/master'),
                    '5.0': ('git https://github.com/brainvisa/cortical_surface-nonfree.git branch:5.0','cortical_surface/cortical_surface-nonfree/5.0'),
                },
            }],
            ['cortical_surface-gpl', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/cortical_surface-gpl.git branch:integration','cortical_surface/cortical_surface-gpl/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/cortical_surface-gpl.git branch:master','cortical_surface/cortical_surface-gpl/master'),
                    '5.0': ('git https://github.com/brainvisa/cortical_surface-gpl.git branch:5.0','cortical_surface/cortical_surface-gpl/5.0'),
                },
            }],
            ['brainvisa_freesurfer', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/brainvisa_freesurfer.git branch:integration','cortical_surface/brainvisa_freesurfer/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/brainvisa_freesurfer.git branch:master','cortical_surface/brainvisa_freesurfer/master'),
                    '5.0': ('git https://github.com/brainvisa/brainvisa_freesurfer.git branch:5.0','cortical_surface/brainvisa_freesurfer/5.0'),
                },
            }],
        ],
    }),
    ('data_storage_client', {
        'components': [
            ['data_storage_client', {
                'groups': [],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/data_storage_client/trunk','data_storage_client/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/data_storage_client/branches/bug_fix','data_storage_client/bug_fix'),
                    '5.0': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/data_storage_client/branches/5.0','data_storage_client/5.0'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/data_storage_client/tags/latest_release','data_storage_client/latest_release'),
                },
            }],
        ],
    }),
    ('nuclear_imaging', {
        'components': [
            ['nuclear_imaging-gpl', {
                'groups': ['all', 'opensource', 'standard', 'cea',
                           'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-gpl/trunk','nuclear_imaging/nuclear_imaging-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-gpl/branches/bug_fix','nuclear_imaging/nuclear_imaging-gpl/bug_fix'),
                    '5.0': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-gpl/branches/5.0','nuclear_imaging/nuclear_imaging-gpl/5.0'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-gpl/tags/latest_release','nuclear_imaging/nuclear_imaging-gpl/latest_release'),
                },
            }],
            ['nuclear_imaging-private', {
                'groups': ['all', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-private/trunk','nuclear_imaging/nuclear_imaging-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-private/branches/bug_fix','nuclear_imaging/nuclear_imaging-private/bug_fix'),
                    '5.0': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-private/branches/5.0','nuclear_imaging/nuclear_imaging-private/5.0'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-private/tags/latest_release','nuclear_imaging/nuclear_imaging-private/latest_release'),
                },
            }],
        ],
    }),
    ('ptk', {
        'components': [
            ['pyptk', {
                'groups': [],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/pyptk/trunk','ptk/pyptk/trunk'),
                },
            }],
            ['fiber-clustering', {
                'groups': [],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/toolbox-fiber-clustering/trunk','ptk/toolbox-fiber-clustering/trunk'),
                },
            }],
        ],
    }),
    ('snapbase', {
        'components': [
            ['snapbase', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/snapbase/trunk','snapbase/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/snapbase/branches/bug_fix','snapbase/bug_fix'),
                    '5.0': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/snapbase/branches/5.0','snapbase/5.0'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/snapbase/tags/latest_release','snapbase/latest_release'),
                },
            }],
        ],
    }),
    ('catidb', {
        'components': [
            ['catidb3_server', {
                'groups': ['cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_server/trunk', 'catidb3_server/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_server/branches/bug_fix', 'catidb3_server/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_server/tags/latest_release', 'catidb3_server/latest_release'),
                },
            }],
            ['catidb3_client', {
                'groups': ['cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_client/trunk','catidb3_client/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_client/branches/bug_fix', 'catidb3_client/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_client/tags/latest_release', 'catidb3_client/latest_release'),
                },
                'build_model': 'pure_python',
            }],
            ['catidb3_exploitation', {
                'groups': ['cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_exploitation','catidb3_exploitation/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_exploitation','catidb3_exploitation/bug_fix'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/catidb3_exploitation','catidb3_exploitation/latest_release'),
                },
            }],
        ],
    }),
    ('sacha', {
        'components': [
            ['sacha-private', { # Experimental branch to propose a new organization
                'groups': ['catidb3_all', 'cati_platform'],
                'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/sacha/sacha-private/trunk', 'sacha-private/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/sacha/sacha-private/branches/bug_fix', 'sacha-private/bug_fix'),
                    #'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/sacha/sacha-private/tags/latest_release', 'sacha-private/latest_release'),
                },
            }],
            ['sacha-gpl', { # Experimental branch to propose a new organization
                'groups': ['catidb3_all', 'cati_platform'],
                'branches': {
                    #'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/sacha/sacha-gpl/trunk', 'sacha-gpl/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/sacha/sacha-gpl/branches/bug_fix', 'sacha-gpl/bug_fix'),
                    #'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/sacha/sacha-gpl/tags/latest_release', 'sacha-gpl/latest_release'),
                },
            }],
        ],
    }),
    ('whasa', {
        'components': [
            ['whasa-private', { # Experimental branch to propose a new organization
                'groups': ['catidb3_all', 'cati_platform'],
                'branches': {
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/whasa/whasa-private/branches/bug_fix', 'whasa-private/bug_fix'),
                },
            }],
            ['whasa-gpl', { # Experimental branch to propose a new organization
                'groups': ['catidb3_all', 'cati_platform'],
                'branches': {
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/cati/whasa/whasa-gpl/branches/bug_fix', 'whasa-gpl/bug_fix'),
                    },
            }],
        ],
    }),
    ('release', {
        'components': [
            ['brainvisa-release', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/brainvisa-release.git branch:master','development/brainvisa-release/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/brainvisa-release.git branch:master','development/brainvisa-release/master'),
                    '5.0': ('git https://github.com/brainvisa/brainvisa-release.git branch:5.0','development/brainvisa-release/5.0'),
                    'latest_release': ('git https://github.com/brainvisa/brainvisa-release.git branch:latest_release','development/brainvisa-release/latest_release'),
                },
            }],
        ],
    }),
    ('longitudinal_pipelines', {
        'components': [
            ['longitudinal_pipelines', {
                'groups': ['all', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/longitudinal_pipelines/trunk',
                              'longitudinal_pipelines/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/longitudinal_pipelines/branches/bug_fix',
                              'longitudinal_pipelines/bug_fix'),
                    '5.0': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/longitudinal_pipelines/branches/5.0',
                              'longitudinal_pipelines/5.0'),
                    'latest_release': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/longitudinal_pipelines/tags/latest_release',
                              'longitudinal_pipelines/latest_release'),
                },
            }],
        ],
    }),
    ('disco', {
        'components': [
            ['disco', {
                'groups': ['all', 'cea'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/brainvisa-disco branch:master', 'disco/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/brainvisa-disco branch:master', 'disco/master'),
                    '5.0': ('git https://bioproj.extra.cea.fr/git/brainvisa-disco branch:5.0', 'disco/5.0'),
                    'latest_release': ('git https://bioproj.extra.cea.fr/git/brainvisa-disco branch:latest_release', 'disco/latest_release'),
                },
            }],
        ],
    }),
    ('qualicati', {
        'components': [
            ['qualicati', {
                'groups': ['cati_platform'],
                'branches': {
                    'bug_fix': ('git https://github.com/cati-neuroimaging/qualicati.git default:main', 'qualicati'),
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
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/fmri/rsfmri/branches/bug_fix','rsfmri/bug_fix'),
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
        with open(ccd) as f:
            exec(compile(f.read(), ccd, 'exec'))

# allow to name branches master or bug_fix indistinctly, or integration/trunk
for cgroup in components_definition:
    for comp in cgroup[1]['components']:
        branches = comp[1]['branches']
        if 'bug_fix' in branches and 'master' not in branches:
            branches['master'] = branches['bug_fix']
        elif 'master' in branches and 'bug_fix' not in branches:
            branches['bug_fix'] = branches['master']
        if 'trunk' in branches and 'integration' not in branches:
            branches['integration'] = branches['trunk']
        elif 'integration' in branches and 'trunk' not in branches:
            branches['trunk'] = branches['integration']


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
                },
            }],
            ['casa-distro', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/casa-distro.git branch:master','development/casa-distro/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/casa-distro.git branch:master','development/casa-distro/master'),
                    '5.0': ('git https://github.com/brainvisa/casa-distro.git branch:brainvisa-5.0','development/casa-distro/5.0'),
                },
                'build_model': 'pure_python',
            }],
        ],
    }),
    ('communication', {
        'components': [
            ['web', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/brainvisa-commu/web.git branch:integration','communication/web/trunk'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/brainvisa-commu/web.git branch:master','communication/web/master'),
                    '5.0': ('git https://bioproj.extra.cea.fr/git/brainvisa-commu/web.git branch:master','communication/web/5.0'),
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
                },
            }],
            ['soma-io', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/soma-io.git branch:master','soma/soma-io/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/soma-io.git branch:master','soma/soma-io/master'),
                    '5.0': ('git https://github.com/brainvisa/soma-io.git branch:5.0','soma/soma-io/5.0'),
                },
            }],
            ['soma-workflow', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/populse/soma-workflow.git branch:master','soma/soma-workflow/integration'),
                    'bug_fix': ('git https://github.com/populse/soma-workflow.git default:master','soma/soma-workflow/master'),
                    '5.0': ('git https://github.com/populse/soma-workflow.git branch:brainvisa-5.0','soma/soma-workflow/5.0'),
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
                },
            }],
            ['aims-gpl', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/aims-gpl.git branch:master','aims/aims-gpl/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/aims-gpl.git branch:master','aims/aims-gpl/master'),
                    '5.0': ('git https://github.com/brainvisa/aims-gpl.git branch:5.0','aims/aims-gpl/5.0'),
                },
            }],
            ['aims-til', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    '5.0': ('git https://github.com/brainvisa/aims-til.git branch:5.0','aims/aims-til/5.0'),
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
                },
            }],
            ['anatomist-gpl', {
                'groups': ['all', 'anatomist', 'opensource', 'brainvisa',
                           'bvdev', 'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/anatomist-gpl.git branch:master','anatomist/anatomist-gpl/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/anatomist-gpl.git branch:master','anatomist/anatomist-gpl/master'),
                    '5.0': ('git https://github.com/brainvisa/anatomist-gpl.git branch:5.0','anatomist/anatomist-gpl/5.0'),
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
        'description': 'Statistics, data mining, machine learning [OBSOLETE].',
        'components': [
            ['datamind', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    '5.0': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/datamind/branches/5.0','datamind/5.0'),
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
            ['morphologist-nonfree', {
                'groups': ['all', 'brainvisa', 'bvdev', 'standard', 'cea',
                           'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/morphologist-nonfree.git branch:integration','morphologist/morphologist-nonfree/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/morphologist-nonfree.git branch:master','morphologist/morphologist-nonfree/master'),
                    '5.0': ('git https://github.com/brainvisa/morphologist-nonfree.git branch:5.0','morphologist/morphologist-nonfree/5.0'),
                },
            }],
            ['morphologist-gpl', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/morphologist-gpl.git branch:integration','morphologist/morphologist-gpl/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/morphologist-gpl.git branch:master','morphologist/morphologist-gpl/master'),
                    '5.0': ('git https://github.com/brainvisa/morphologist-gpl.git branch:5.0','morphologist/morphologist-gpl/5.0'),
                },
            }],
            ['morphologist-baby', {
                'groups': ['all', 'standard', 'cea'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/brainvisa-t1mri/morphologist-baby.git branch:integration','morphologist/morphologist-baby/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/brainvisa-t1mri/morphologist-baby.git branch:master','morphologist/morphologist-baby/master'),
                    '5.0': ('git https://bioproj.extra.cea.fr/git/brainvisa-t1mri/morphologist-baby.git branch:5.0','morphologist/morphologist-baby/5.0'),
                },
            }],
            ['tms', {
                'groups': ['all'],
                'branches': {
                },
            }],
            ['sulci-data', {
                'groups': [],
                'branches': {
                    'trunk': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-data/trunk','morphologist/sulci-data/trunk'),
                    'bug_fix': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/morphologist/sulci-data/trunk','morphologist/sulci-data/bug_fix'),
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
            ['morphologist-ui', {
                'groups': ['all', 'opensource', 'brainvisa', 'bvdev',
                           'standard', 'cea', 'cati_platform'],
                'branches': {
                    'trunk': ('git https://github.com/brainvisa/morphologist.git branch:master', 'morphologist/morphologist-ui/integration'),
                    'bug_fix': ('git https://github.com/brainvisa/morphologist.git default:master', 'morphologist/morphologist-ui/master'),
                    '5.0': ('git https://github.com/brainvisa/morphologist.git branch:5.0', 'morphologist/morphologist-ui/5.0'),
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
                },
            }],
            ['brainrat-private', {
                'groups': ['all', 'brainvisa', 'cea'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/brainrat-private branch:master', 'brainrat/brainrat-private/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/brainrat-private branch:master', 'brainrat/brainrat-private/master'),
                    '5.0': ('git https://bioproj.extra.cea.fr/git/brainrat-private branch:5.0', 'brainrat/brainrat-private/5.0'),
                },
            }],
            ['bioprocessing', {
                'groups': ['all', 'cea'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/bioprocessing branch:master', 'brainrat/bioprocessing/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/bioprocessing branch:master', 'brainrat/bioprocessing/master'),
                    '5.0': ('git https://bioproj.extra.cea.fr/git/bioprocessing branch:5.0', 'brainrat/bioprocessing/5.0'),
                },
            }],
            ['preclinical-imaging-iam', {
                'groups': ['all'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/preclinical-imaging-iam branch:master', 'brainrat/preclinical-imaging-iam/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/preclinical-imaging-iam branch:master', 'brainrat/preclinical-imaging-iam/master'),
                },
            }],
            ['primatologist-gpl', {
                'groups': ['all', 'brainvisa', 'cea'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/primatologist-gpl branch:master', 'brainrat/primatologist-gpl/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/primatologist-gpl branch:master', 'brainrat/primatologist-gpl/master'),
                    '5.0': ('git https://bioproj.extra.cea.fr/git/primatologist-gpl branch:5.0', 'brainrat/primatologist-gpl/5.0'),
                },
            }],
            ['3dns-private', {
                'groups': ['3dns'],
                'branches': {
                    'trunk': ('git https://bioproj.extra.cea.fr/git/3dns-private branch:master', 'brainrat/3dns-private/integration'),
                    'bug_fix': ('git https://bioproj.extra.cea.fr/git/3dns-private branch:master', 'brainrat/3dns-private/master'),
                    '5.0': ('git https://bioproj.extra.cea.fr/git/3dns-private branch:5.0', 'brainrat/3dns-private/5.0'),
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
    ('nuclear_imaging', {
        'components': [
            ['nuclear_imaging-gpl', {
                'groups': ['all', 'cati_platform'],
                'branches': {
                    'bug_fix': ('git https://github.com/cati-neuroimaging/nuclear_imaging-gpl.git branch:master','nuclear_imaging/nuclear_imaging-gpl/master'),
                    '5.0': ('git https://github.com/cati-neuroimaging/nuclear_imaging-gpl.git branch:5.0','nuclear_imaging/nuclear_imaging-gpl/5.0'),
                },
            }],
            ['nuclear_imaging-nonfree', {
                'groups': ['all', 'cati_platform'],
                'branches': {
                    'bug_fix': ('git https://github.com/cati-neuroimaging/nuclear_imaging-nonfree.git branch:master','nuclear_imaging/nuclear_imaging-nonfree/master'),
                    '5.0': ('git https://github.com/cati-neuroimaging/nuclear_imaging-nonfree.git branch:5.0','nuclear_imaging/nuclear_imaging-nonfree/5.0'),
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
                    '5.0': ('svn https://bioproj.extra.cea.fr/neurosvn/brainvisa/snapbase/branches/5.0','snapbase/5.0'),
                },
            }],
        ],
    }),
    ('catidb', {
        'components': [
            ['catidb-client', {
                'groups': ['cati_platform'],
                'branches': {
                    'bug_fix': ('git https://github.com/cati-neuroimaging/catidb-client.git default:main', 'catidb-client'),
                },
            }],
        ],
    }),
    ('sacha', {
        'components': [
            ['sacha-nonfree', {
                'groups': ['all', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'bug_fix': ('git https://github.com/cati-neuroimaging/sacha-nonfree.git branch:master', 'sacha-nonfree/master'),
                },
            }],
            ['sacha-gpl', {
                'groups': ['all', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'bug_fix': ('git https://github.com/cati-neuroimaging/sacha-gpl.git branch:master', 'sacha-gpl/master'),
                },
            }],
        ],
    }),
    ('whasa', {
        'components': [
            ['whasa-nonfree', {
                'groups': ['all', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'bug_fix': ('git https://github.com/cati-neuroimaging/whasa-nonfree.git branch:master', 'whasa-nonfree/master'),
                },
            }],
            ['whasa-gpl', { # Experimental branch to propose a new organization
                'groups': ['all', 'catidb3_all', 'cati_platform'],
                'branches': {
                    'bug_fix': ('git https://github.com/cati-neuroimaging/whasa-gpl.git branch:master', 'whasa-gpl/master'),
                    },
            }],
        ],
    }),
    ('longitudinal_pipelines', {
        'components': [
            ['longitudinal_pipelines', {
                'groups': ['all', 'cati_platform'],
                'branches': {
                    'bug_fix': ('git https://github.com/cati-neuroimaging/longitudinal_pipelines.git branch:master',
                              'longitudinal_pipelines/master'),
                    '5.0': ('git https://github.com/cati-neuroimaging/longitudinal_pipelines.git branch:5.0',
                              'longitudinal_pipelines/5.0'),
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
                    'bug_fix': ('git https://github.com/cati-neuroimaging/rsfmri.git branch:master','rsfmri/master'),
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


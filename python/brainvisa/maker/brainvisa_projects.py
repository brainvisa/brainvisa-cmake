# -*- coding: utf-8 -*-

# This module had been generated by bv_update_projects_list command on Mon Jul 25 14:36:29 2011

brainvisaProjects =['communication',
 'development',
 'brainvisa-installer',
 'brainvisa-share',
 'soma',
 'aims',
 'anatomist',
 'axon',
 'data_storage_client',
 'datamind',
 't1mri',
 'sulci',
 'connectomist',
 'cortical_surface',
 'brainrat',
 'nuclear_imaging',
 'nuclear_processing',
 'optical_imaging',
 'pyhrf',
 'fmri',
 'ptk',
 'famis',
 'sandbox']

brainvisaComponentsPerProject ={'aims': ['aims-free', 'aims-gpl'],
 'anatomist': ['anatomist-free', 'anatomist-gpl'],
 'axon': ['axon'],
 'brainrat': ['brainrat-gpl', 'brainrat-private', 'bioprocessing'],
 'brainvisa-installer': ['brainvisa-installer'],
 'brainvisa-share': ['brainvisa-share'],
 'communication': ['documentation', 'bibliography', 'latex', 'web'],
 'connectomist': ['connectomist-private',
                  'old_connectomist-gpl',
                  'old_connectomist-private'],
 'cortical_surface': ['cortical_surface-private',
                      'cortical_surface-gpl',
                      'freesurfer_plugin'],
 'data_storage_client': ['data_storage_client'],
 'datamind': ['datamind'],
 'development': ['brainvisa-cmake', 'brainvisa-svn', 'brainvisa-release'],
 'famis': ['famis-private'],
 'fmri': ['fmri-gpl'],
 'nuclear_imaging': ['nuclear_imaging-gpl', 'nuclear_imaging-private'],
 'nuclear_processing': ['nuclear_processing-gpl',
                        'nuclear_processing-private'],
 'optical_imaging': ['optical_imaging-private', 'optical_imaging-gpl'],
 'ptk': ['ptk',
         'pyptk',
         'mri-reconstruction',
         'relaxometrist',
         'nucleist',
         'functionalist',
         'connectomist',
         'microscopist',
         'realtime-mri',
         'ptk-fiber-clustering'],
 'pyhrf': ['pyhrf-free', 'pyhrf-gpl'],
 'sandbox': ['nictk'],
 'soma': ['soma-base',
          'soma-io',
          'soma-qtgui',
          'soma-database',
          'soma-pipeline',
          'soma-referentials',
          'soma-traits',
          'soma-workflow'],
 'sulci': ['sulci-private', 'sulci-gpl', 'sulci-data'],
 't1mri': ['t1mri-private', 't1mri-gpl', 'tms']}

brainvisaProjectPerComponent ={'aims-free': 'aims',
 'aims-gpl': 'aims',
 'anatomist-free': 'anatomist',
 'anatomist-gpl': 'anatomist',
 'axon': 'axon',
 'bibliography': 'communication',
 'bioprocessing': 'brainrat',
 'brainrat-gpl': 'brainrat',
 'brainrat-private': 'brainrat',
 'brainvisa-cmake': 'development',
 'brainvisa-installer': 'brainvisa-installer',
 'brainvisa-release': 'development',
 'brainvisa-share': 'brainvisa-share',
 'brainvisa-svn': 'development',
 'connectomist': 'ptk',
 'connectomist-private': 'connectomist',
 'cortical_surface-gpl': 'cortical_surface',
 'cortical_surface-private': 'cortical_surface',
 'data_storage_client': 'data_storage_client',
 'datamind': 'datamind',
 'documentation': 'communication',
 'famis-private': 'famis',
 'fmri-gpl': 'fmri',
 'freesurfer_plugin': 'cortical_surface',
 'functionalist': 'ptk',
 'latex': 'communication',
 'microscopist': 'ptk',
 'mri-reconstruction': 'ptk',
 'nictk': 'sandbox',
 'nuclear_imaging-gpl': 'nuclear_imaging',
 'nuclear_imaging-private': 'nuclear_imaging',
 'nuclear_processing-gpl': 'nuclear_processing',
 'nuclear_processing-private': 'nuclear_processing',
 'nucleist': 'ptk',
 'old_connectomist-gpl': 'connectomist',
 'old_connectomist-private': 'connectomist',
 'optical_imaging-gpl': 'optical_imaging',
 'optical_imaging-private': 'optical_imaging',
 'ptk': 'ptk',
 'ptk-fiber-clustering': 'ptk',
 'pyhrf-free': 'pyhrf',
 'pyhrf-gpl': 'pyhrf',
 'pyptk': 'ptk',
 'realtime-mri': 'ptk',
 'relaxometrist': 'ptk',
 'soma-base': 'soma',
 'soma-database': 'soma',
 'soma-io': 'soma',
 'soma-pipeline': 'soma',
 'soma-qtgui': 'soma',
 'soma-referentials': 'soma',
 'soma-traits': 'soma',
 'soma-workflow': 'soma',
 'sulci-data': 'sulci',
 'sulci-gpl': 'sulci',
 'sulci-private': 'sulci',
 't1mri-gpl': 't1mri',
 't1mri-private': 't1mri',
 'tms': 't1mri',
 'web': 'communication'}

brainvisaBranchesPerComponent ={'aims-free': ['3.2', '4.0', '4.1'],
 'aims-gpl': ['3.2', '4.0', '4.1'],
 'anatomist-free': ['3.2', '4.0', '4.1'],
 'anatomist-gpl': ['3.2', '4.0', '4.1'],
 'axon': ['3.2', '4.0', '4.1'],
 'bioprocessing': ['3.2', '4.0', '4.1'],
 'brainrat-gpl': ['3.2', '4.0', '4.1'],
 'brainrat-private': ['3.2', '4.0', '4.1'],
 'brainvisa-cmake': ['1.0'],
 'brainvisa-release': ['1.0'],
 'brainvisa-share': ['3.2', '4.0', '4.1'],
 'connectomist-private': ['3.2', '4.0'],
 'cortical_surface-gpl': ['3.2', '4.0', '4.1'],
 'cortical_surface-private': ['3.2', '4.0', '4.1'],
 'data_storage_client': ['3.2', '4.0', '4.1'],
 'datamind': ['3.2', '4.0', '4.1'],
 'documentation': ['3.2', '4.0', '4.1'],
 'fmri-gpl': ['3.2', '4.0'],
 'freesurfer_plugin': ['4.0', '4.1'],
 'nuclear_imaging-gpl': ['4.1'],
 'nuclear_imaging-private': ['4.1'],
 'nuclear_processing-gpl': ['3.2', '4.0'],
 'nuclear_processing-private': ['3.2', '4.0'],
 'old_connectomist-gpl': ['4.0', '4.1'],
 'old_connectomist-private': ['4.0', '4.1'],
 'optical_imaging-gpl': ['4.0', '4.1'],
 'optical_imaging-private': ['4.0', '4.1'],
 'soma-base': ['3.2', '4.0', '4.1'],
 'soma-qtgui': ['3.2', '4.0', '4.1'],
 'soma-workflow': ['1.0'],
 'sulci-data': ['3.2', '4.0'],
 'sulci-gpl': ['3.2', '4.0', '4.1'],
 'sulci-private': ['3.2', '4.0', '4.1'],
 't1mri-gpl': ['3.2', '4.0', '4.1'],
 't1mri-private': ['3.2', '4.0', '4.1'],
 'tms': ['4.1']}

brainvisaTagsPerComponent ={'aims-free': ['3.2.0', '4.0.1', '4.0.2', '4.1.0'],
 'aims-gpl': ['3.2.0', '4.0.1', '4.0.2', '4.1.0'],
 'anatomist-free': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'anatomist-gpl': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'axon': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'bioprocessing': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'brainrat-gpl': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'brainrat-private': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'brainvisa-cmake': ['1.0.0'],
 'brainvisa-release': ['1.0.0'],
 'brainvisa-share': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'connectomist-private': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2'],
 'cortical_surface-gpl': ['3.2.0', '3.2.1', '4.0.1', '4.0.2', '4.1.0'],
 'cortical_surface-private': ['3.2.0', '3.2.1', '4.0.1', '4.0.2', '4.1.0'],
 'data_storage_client': ['3.2.0', '4.0.1', '4.0.2', '4.1.0'],
 'datamind': ['3.2.0', '4.0.1', '4.0.2', '4.1.0'],
 'documentation': ['3.2.0', '3.2.1', '4.0.0', '4.0.2', '4.1.0'],
 'fmri-gpl': ['4.0.0'],
 'freesurfer_plugin': ['4.0.1', '4.0.2', '4.1.0'],
 'nuclear_imaging-gpl': ['4.1.0'],
 'nuclear_imaging-private': ['4.1.0'],
 'nuclear_processing-gpl': ['3.2.0', '3.2.1', '4.0.1'],
 'nuclear_processing-private': ['3.2.0', '3.2.1', '4.0.1'],
 'old_connectomist-gpl': ['4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'old_connectomist-private': ['4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'optical_imaging-gpl': ['4.0.2', '4.1.0'],
 'optical_imaging-private': ['4.0.2', '4.1.0'],
 'soma-base': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'soma-qtgui': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'soma-workflow': ['1.0.0'],
 'sulci-data': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2'],
 'sulci-gpl': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'sulci-private': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 't1mri-gpl': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 't1mri-private': ['3.2.0', '3.2.1', '4.0.0', '4.0.1', '4.0.2', '4.1.0'],
 'tms': ['4.1.0']}

brainvisaURLPerComponent ={'aims-free': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-free',
 'aims-gpl': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/aims/aims-gpl',
 'anatomist-free': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-free',
 'anatomist-gpl': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/anatomist/anatomist-gpl',
 'axon': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/axon',
 'bibliography': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/bibliography',
 'bioprocessing': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/bioprocessing',
 'brainrat-gpl': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-gpl',
 'brainrat-private': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainrat/brainrat-private',
 'brainvisa-cmake': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-cmake',
 'brainvisa-installer': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainvisa-installer',
 'brainvisa-release': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-release',
 'brainvisa-share': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/brainvisa-share',
 'brainvisa-svn': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/development/brainvisa-svn',
 'connectomist': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/toolbox-connectomist',
 'connectomist-private': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/connectomist-private',
 'cortical_surface-gpl': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-gpl',
 'cortical_surface-private': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/cortical_surface-private',
 'data_storage_client': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/data_storage_client',
 'datamind': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/datamind',
 'documentation': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/documentation',
 'famis-private': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/famis/famis-private',
 'fmri-gpl': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/fmri/fmri-gpl',
 'freesurfer_plugin': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/cortical_surface/freesurfer_plugin',
 'functionalist': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/toolbox-functionalist',
 'latex': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/latex',
 'microscopist': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/toolbox-microscopist',
 'mri-reconstruction': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/toolbox-mri-reconstruction',
 'nictk': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/sandbox/nictk',
 'nuclear_imaging-gpl': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-gpl',
 'nuclear_imaging-private': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_imaging/nuclear_imaging-private',
 'nuclear_processing-gpl': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-gpl',
 'nuclear_processing-private': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/nuclear_processing/nuclear_processing-private',
 'nucleist': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/toolbox-nucleist',
 'old_connectomist-gpl': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-gpl',
 'old_connectomist-private': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/connectomist/old_connectomist-private',
 'optical_imaging-gpl': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-gpl',
 'optical_imaging-private': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/optical_imaging/optical_imaging-private',
 'ptk': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/ptk',
 'ptk-fiber-clustering': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/toolbox-fiber-clustering',
 'pyhrf-free': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/pyhrf/pyhrf-free',
 'pyhrf-gpl': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/pyhrf/pyhrf-gpl',
 'pyptk': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/pyptk',
 'realtime-mri': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/toolbox-realtime-mri',
 'relaxometrist': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/ptk/toolbox-relaxometrist',
 'soma-base': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-base',
 'soma-database': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-database',
 'soma-io': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-io',
 'soma-pipeline': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-pipeline',
 'soma-qtgui': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-qtgui',
 'soma-referentials': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-referentials',
 'soma-traits': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-traits',
 'soma-workflow': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/soma/soma-workflow',
 'sulci-data': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/sulci/sulci-data',
 'sulci-gpl': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/sulci/sulci-gpl',
 'sulci-private': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/sulci/sulci-private',
 't1mri-gpl': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/t1mri/t1mri-gpl',
 't1mri-private': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/t1mri/t1mri-private',
 'tms': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/t1mri/tms',
 'web': 'https://bioproj.extra.cea.fr/neurosvn/brainvisa/communication/web'}

brainvisaComponentsPerGroup ={'all': ['aims-free',
         'aims-gpl',
         'anatomist-free',
         'anatomist-gpl',
         'axon',
         'bioprocessing',
         'brainrat-gpl',
         'brainrat-private',
         'brainvisa-installer',
         'brainvisa-share',
         'bibliography',
         'documentation',
         'latex',
         'web',
         'connectomist-private',
         'old_connectomist-gpl',
         'old_connectomist-private',
         'cortical_surface-gpl',
         'cortical_surface-private',
         'freesurfer_plugin',
         'data_storage_client',
         'datamind',
         'brainvisa-cmake',
         'brainvisa-release',
         'brainvisa-svn',
         'famis-private',
         'fmri-gpl',
         'nuclear_imaging-gpl',
         'nuclear_imaging-private',
         'nuclear_processing-gpl',
         'nuclear_processing-private',
         'optical_imaging-gpl',
         'optical_imaging-private',
         'ptk',
         'pyptk',
         'connectomist',
         'ptk-fiber-clustering',
         'functionalist',
         'microscopist',
         'mri-reconstruction',
         'nucleist',
         'realtime-mri',
         'relaxometrist',
         'pyhrf-free',
         'pyhrf-gpl',
         'nictk',
         'soma-base',
         'soma-database',
         'soma-io',
         'soma-pipeline',
         'soma-qtgui',
         'soma-referentials',
         'soma-traits',
         'soma-workflow',
         'sulci-data',
         'sulci-gpl',
         'sulci-private',
         't1mri-gpl',
         't1mri-private',
         'tms'],
 'anatomist': ['aims-free',
               'aims-gpl',
               'anatomist-free',
               'anatomist-gpl',
               'brainvisa-share',
               'brainvisa-cmake',
               'soma-base'],
 'opensource': ['aims-free',
                'aims-gpl',
                'anatomist-free',
                'anatomist-gpl',
                'axon',
                'brainrat-gpl',
                'brainvisa-installer',
                'brainvisa-share',
                'bibliography',
                'documentation',
                'latex',
                'web',
                'old_connectomist-gpl',
                'cortical_surface-gpl',
                'freesurfer_plugin',
                'data_storage_client',
                'brainvisa-cmake',
                'brainvisa-release',
                'brainvisa-svn',
                'fmri-gpl',
                'nuclear_imaging-gpl',
                'nuclear_processing-gpl',
                'optical_imaging-gpl',
                'pyhrf-free',
                'pyhrf-gpl',
                'soma-base',
                'soma-database',
                'soma-io',
                'soma-pipeline',
                'soma-qtgui',
                'soma-referentials',
                'soma-traits',
                'soma-workflow',
                'sulci-gpl',
                't1mri-gpl'],
 'standard': ['aims-free',
              'aims-gpl',
              'anatomist-free',
              'anatomist-gpl',
              'axon',
              'brainrat-gpl',
              'brainvisa-installer',
              'brainvisa-share',
              'bibliography',
              'documentation',
              'latex',
              'web',
              'connectomist-private',
              'old_connectomist-gpl',
              'old_connectomist-private',
              'cortical_surface-gpl',
              'cortical_surface-private',
              'freesurfer_plugin',
              'data_storage_client',
              'datamind',
              'brainvisa-cmake',
              'brainvisa-release',
              'brainvisa-svn',
              'fmri-gpl',
              'nuclear_imaging-gpl',
              'nuclear_imaging-private',
              'optical_imaging-gpl',
              'optical_imaging-private',
              'pyhrf-free',
              'pyhrf-gpl',
              'soma-base',
              'soma-database',
              'soma-io',
              'soma-pipeline',
              'soma-qtgui',
              'soma-referentials',
              'soma-traits',
              'soma-workflow',
              'sulci-data',
              'sulci-gpl',
              'sulci-private',
              't1mri-gpl',
              't1mri-private',
              'tms']}

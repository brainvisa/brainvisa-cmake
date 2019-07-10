Usage: bv_maker [global options] test_pack [options]

    Test in installed package for the selected build directory.

Options:
  -h, --help            show this help message and exit
  --only-if-default     only perform this step if it is a default step, or
                        specified in the "default_steps" option of
                        bv_maker.cfg config file. Default steps are normally
                        "sources" for source sections, "configure build" for
                        build sections.
  -t CTEST_OPTIONS, --ctest_options=CTEST_OPTIONS
                        options passed to ctest (ex: "-VV -R carto*"). Same as
                        the configuration option ctest_options but specified
                        at runtime. The commandline option here overrides the
                        bv_maker.cfg options.
  --package-date=PACKAGE_DATE
                        sets the date of the pack to install. This is only
                        useful if a %(date)s pattern has been used in the
                        package directory sections of bv_maker.cfg.
  --package-time=PACKAGE_TIME
                        sets the time of the pack to install. This is only
                        useful if a %(time)s pattern has been used in the
                        package directory sections of bv_maker.cfg.
  --package-version=PACKAGE_VERSION
                        sets the version of the pack to install. This is only
                        useful if a %(version)s pattern has been used in the
                        package directory sections of bv_maker.cfg.

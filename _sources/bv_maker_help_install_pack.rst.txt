Usage: bv_maker [global options] install_pack [options]

    Install a binary package for the selected build directory.

Options:
  -h, --help            show this help message and exit
  --only-if-default     only perform this step if it is a default step, or
                        specified in the "default_steps" option of
                        bv_maker.cfg config file. Default steps are normally
                        "sources" for source sections, "configure build" for
                        build sections.
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
  --prefix=PREFIX       sets the prefix directory to install the pack.
  --local               True if the installation must be done locally. Default
                        is False.
  --offline             True if the installation must be done using offline
                        installer. Default is False.
  --debug               True if the installation must be done in debug mode
                        (i.e. generated files must not be deleted). Default is
                        False.

Usage: bv_maker [global options] configure [options]

    Compile selected build directories.

Options:
  -h, --help         show this help message and exit
  -c, --clean        clean build tree (using bv_clean_build_tree -b) before
                     building
  --only-if-default  only perform this step if it is a default step, or
                     specified in the "default_steps" option of bv_maker.cfg
                     config file. Default steps are normally "sources" for
                     source sections, and "configure build" for build sections

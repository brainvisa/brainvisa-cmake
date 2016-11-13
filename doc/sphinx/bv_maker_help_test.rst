Usage: bv_maker [global options] test

    Executes ctest.

Options:
  -h, --help         show this help message and exit
  --only-if-default  only perform this step if it is a default step, or
                     specified in the "default_steps" option of bv_maker.cfg
                     config file. Default steps are normally "sources" for
                     source sections, and "configure build" for build sections

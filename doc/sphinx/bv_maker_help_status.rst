Usage: bv_maker [global options] status [options]

    Display a summary of the status of all source repositories.

Options:
  -h, --help         show this help message and exit
  --no-svn           don't display the status of svn sources
  --no-git           don't display the status of git sources
  --only-if-default  only perform this step if it is a default step, or
                     specified in the "default_steps" option of bv_maker.cfg
                     config file. Default steps are normally "sources" for
                     source sections, and "configure build" for build sections

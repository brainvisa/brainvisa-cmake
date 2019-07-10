Usage: bv_maker [global options] sources [options]

    Create or updated selected sources directories from Subversion repository.

Options:
  -h, --help            show this help message and exit
  --no-cleanup          don't cleanup svn sources
  --no-svn              don't update svn sources
  --no-git              don't update git sources
  --only-if-default     only perform this step if it is a default step, or
                        specified in the "default_steps" option of
                        bv_maker.cfg config file. Default steps are normally
                        "sources" for source sections, and "configure build"
                        for build sections
  --ignore-git-failure  ignore git update failures, useful when working on a
                        feature branch

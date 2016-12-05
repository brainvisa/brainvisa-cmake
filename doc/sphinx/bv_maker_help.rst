Usage: bv_maker [options] [ command [command options] ]...

This program is for the management of source retrieval, configuration and compilation of BrainVISA projects.

In order to work, the commands svn and svnadmin must be installed on your system. On some Linux systems they are in two separate packages (e.g. subversion and subversion-tools).

Commands:

* info: Just output info about configured components
* sources: Create or updated selected sources directories from Subversion repository.
* configure: Create and configure selected build directories with CMake.
* build: compile all selected build directories.
* doc: Generate documentation (sphinx, doxygen, docbook, epydoc)
* test: Execute tests using ctest.
* pack: Generate binary packages
* install_pack: install binary packages
* test_pack: run tests in installed binary packages

To get help for a specific command, use -h option of the command. Example: "bv_maker build -h".

To get help on how to configure and write a bv_maker configuration file, see:

http://brainvisa.info/brainvisa-cmake/compile_existing.html

config file syntax:

http://brainvisa.info/brainvisa-cmake/configuration.html

and more generally:

http://brainvisa.info/brainvisa-cmake/


Options:
  -h, --help            show this help message and exit
  -d DIR, --directory=DIR
                        Restrict actions to a selected directory. May be used
                        several times to process several directories.
  -c CONFIG, --config=CONFIG
                        specify configuration file. Default
                        ="/home/dr144257/.brainvisa/bv_maker.cfg"
  -s DIR, --sources=DIR
                        directory containing sources
  -b DIR, --build=DIR   build directory
  --username=USERNAME   specify user login to use with the svn server
  -e, --email           Use email notification (if configured in the general
                        section of the configuration file)
  -v, --verbose         show as much information as possible

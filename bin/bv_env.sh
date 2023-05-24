if [ "$1" = "-p" ]; then
    echo="echo "
else
    echo=""
fi

# The following part is for testing building with Conda
script_dir=$( dirname $(readlink -f "$0") )
CASA=$(dirname $(dirname $(dirname "$script_dir")))
if [ -d "$CASA" ]; then
    ${echo}export CASA_CONF=$CASA/conf
    ${echo}export HOME=$CASA/home
    CASA_SRC=$CASA/src # set it even with -p option
    ${echo}export CASA_SRC=$CASA/src
    CASA_BUILD=$CASA/build # set it even with -p option
    ${echo}export CASA_BUILD=$CASA/build
    ${echo}export CASA_INSTALL=$CASA/install
    ${echo}export CASA_TESTS=$CASA/tests
    ${echo}export BRAINVISA_BVMAKER_CFG=$CASA_SRC/bv_maker.cfg
    #for f in "$CASA_SRC/environment.sh" "$CASA_CONF/environment.sh" "$CASA/environment.sh"; do
    #    if [ -e "$f" ]; then
    #        source "$f"
    #    fi
    #done
    ${echo}export PATH=$CASA/conda/bin:$PATH
    ${echo}export LD_LIBRARY_PATH=$CASA/conda/lib:$LD_LIBRARY_PATH
fi

if [ ! -z "$CASA_BUILD" ]; then
    ${echo}export PATH="$CASA_BUILD/bin:$PATH"
    ${echo}export LD_LIBRARY_PATH="$CASA_BUILD/lib:$LD_LIBRARY_PATH"
    ${echo}export PYTHONPATH="$CASA_BUILD/python:$PYTHONPATH"
fi

if  ! type bv_maker >/dev/null 2>/dev/null;  then
    script_dir=$( dirname $(readlink -f "$0") )
    ${echo}export PATH="$script_dir:$PATH"
    ${echo}export LD_LIBRARY_PATH="$script_dir/../lib:$LD_LIBRARY_PATH"
    ${echo}export PYTHONPATH="$script_dir/../python:$PYTHONPATH"
fi

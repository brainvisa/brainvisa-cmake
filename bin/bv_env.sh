if [ "$1" = "-p" ]; then
    echo="echo "
else
    echo=""
fi

if [ ! -z "$CASA_BUILD" ]; then
    ${echo}export PATH="$CASA_BUILD/bin:$PATH"
    ${echo}export LD_LIBRARY_PATH="$CASA_BUILD/lib:$LD_LIBRARY_PATH"
    ${echo}export PYTHONPATH="$CASA_BUILD/python:$PYTHONPATH"
fi

if ! hash bv_maker 2>/dev/null;  then
    script_dir=$( dirname $(readlink -f "$0") )
    ${echo}export PATH="$script_dir:$PATH"
    ${echo}export LD_LIBRARY_PATH="$script_dir/../lib:$LD_LIBRARY_PATH"
    ${echo}export PYTHONPATH="$script_dir/../python:$PYTHONPATH"
fi

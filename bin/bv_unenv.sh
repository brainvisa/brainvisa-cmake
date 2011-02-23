#! /bin/sh

exists() {
  type -t $1 > /dev/null
}

mktemp=`type -t mktemp`
if [ -z "$mktemp" ]; then
  i=0
  tmp="/tmp/bv_unenv-$$-$i"
  while [ -e "$tmp" ]; do
    i=$(($i+1))
    tmp="/tmp/bv_unenv-$$-$i"
  done
else
  tmp=`mktemp -t bv_unenv.XXXXXXXXXX`
fi

if [ $# -gt 0 ]; then
  bv_unenv="$1/bin/bv_unenv"
else
  if [ "`basename "$0"`" = "bv_unenv.sh" ]; then
    bv_unenv="`dirname "$0"`"
    bv_unenv="$bv_unenv/bv_unenv"
  else
    bv_unenv=bv_unenv
    # Try to find bv_unenv location in the shell history
    exists history && exists tail && exists awk
    if [ $? -eq 0 ]; then
      bv_unenv_command=`history | tail -n 1 | awk '{print $3}'`
      bv_unenv=`dirname $bv_unenv_command`
      bv_unenv="$bv_unenv/bv_unenv"
    fi
  fi
fi
# get fullpath of bv_unenv
exists readlink
if [ $? -eq 0 ]; then
  bv_unenv="`readlink -f $bv_unenv`"
fi
if [ ! -x "$bv_unenv" ]; then
  bv_unenv=bv_unenv
fi

# try to find python in the real-bin directory of the pack
# this avoid looping between python and bv_unenv if the python command of the bin directory of the pack is called
# and it is not necessary to have python on the system where the package is installed
python="`dirname $bv_unenv`/real-bin/python"
exists $python
if [ ! $? -eq 0 ]; then
  python="python"
fi

"$python" "$bv_unenv" > "$tmp"
source "$tmp"
\rm "$tmp"

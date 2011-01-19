#! /bin/sh

exists() {
  type -t $1 > /dev/null
}

python="python"

mktemp=`type -t mktemp`
if [ -z "$mktemp" ]; then
  i=0
  tmp="/tmp/bv_unenv-$$-$i"
  while [ -e "$tmp" ]; do
    i=$(($i+1))
    tmp="/tmp/bv_unenv-$$-$i"
  done
else
  tmp=`mktemp -t bv_unenv`
fi

if [ "`basename "$0"`" = "bv_unenv.sh" ]; then
  bv_unenv="`dirname "$0"`"
  if [ -z "$bv_unenv" -o "$bv_unenv" = "." ]; then
    bv_unenv="$PWD/bv_unenv"
  else
    bv_unenv="$bv_unenv/bv_unenv"
  fi
else
  bv_unenv=bv_unenv
  # Try to find bv_unenv location in the shell history
  exists history && exists tail && exists "$python"
  if [ $? -eq 0 ]; then
    bv_unenv="`history | tail -n 1 | "$python" -c 'import sys,os,subprocess; subprocess.call( [ "sh", "-c", "echo " + os.path.abspath( os.path.join( os.path.dirname( sys.stdin.readline().split( None, 3 )[ 2 ] ),"bv_unenv" ) ) ] )' 2>/dev/null`"
    if [ ! -x "$bv_unenv" ]; then
      bv_unenv=bv_unenv
    fi
  fi
fi
"$bv_unenv" > "$tmp"
source "$tmp"
\rm "$tmp"

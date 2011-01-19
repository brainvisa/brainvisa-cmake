#! /bin/sh

exists() {
  type -t $1 > /dev/null
}

python="python"

mktemp=`type -t mktemp`
if [ -z "$mktemp" ]; then
  i=0
  tmp="/tmp/bv_env-$$-$i"
  while [ -e "$tmp" ]; do
    i=$(($i+1))
    tmp="/tmp/bv_env-$$-$i"
  done
else
  tmp=`mktemp -t bv_env`
fi

if [ -e "$0" ]; then
  bv_env="`dirname "$0"`"
  if [ -z "$bv_env" -o "$bv_env" = "." ]; then
    bv_env="$PWD/bv_env"
  else
    bv_env="$bv_env/bv_env"
  fi
else
  bv_env=bv_env
  # Try to find bv_env location in the shell history
  exists history && exists tail && exists "$python"
  if [ $? -eq 0 ]; then
    bv_env="`history | tail -n 1 | "$python" -c 'import sys,os,subprocess; subprocess.call( [ "sh", "-c", "echo " + os.path.abspath( os.path.join( os.path.dirname( sys.stdin.readline().split( None, 3 )[ 2 ] ),"bv_env" ) ) ] )' 2>/dev/null`"
    if [ ! -x "$bv_env" ]; then
      bv_env=bv_env
    fi
  fi
fi
"$bv_env" > "$tmp"
source "$tmp"
\rm "$tmp"

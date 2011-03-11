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
      if [ -n "$bv_unenv_command" ];then
        bv_unenv=`dirname $bv_unenv_command`
        bv_unenv="$bv_unenv/bv_unenv"
      fi
    fi
  fi
fi
# get fullpath of bv_env
bv_unenv_dir=`dirname $bv_unenv`
if [ -n "$bv_unenv_dir" ];then
  bv_unenv="`cd $bv_unenv_dir;pwd`/bv_unenv"
fi
if [ ! -x "$bv_unenv" ]; then
  bv_unenv=bv_unenv
fi

"$bv_unenv" > "$tmp"
source "$tmp"
\rm "$tmp"

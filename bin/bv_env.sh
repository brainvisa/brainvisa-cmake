#! /bin/sh

# Usage:
#   source /somewhere/bin/bv_env.sh /somewhere
#   
#   If used from a terminal with history activated, the parameter can be ommited:
#     source /somewhere/bin/bv_env.sh
#

exists() {
  type -t $1 > /dev/null
}

mktemp=`type -t mktemp`
if [ -z "$mktemp" ]; then
  i=0
  tmp="/tmp/bv_env-$$-$i"
  while [ -e "$tmp" ]; do
    i=$(($i+1))
    tmp="/tmp/bv_env-$$-$i"
  done
else
  tmp=`mktemp -t bv_env.XXXXXXXXXX`
fi

if [ $# -gt 0 ]; then
  # the directory of the pack is given in parameters
  bv_env="$1/bin/bv_env"
else
  if [ "`basename "$0" 2>/dev/null`" = "bv_env.sh" ]; then
    # the called command is bv_env.sh
    bv_env="`dirname "$0"`"
    bv_env="$bv_env/bv_env"
  else
    # called source bv_env.sh
    bv_env=bv_env
    # Try to find bv_env location in the shell history
    exists history && exists tail && exists awk
    if [ $? -eq 0 ]; then
      bv_env_command=`history | tail -n 1 | awk '{print $3}'`
      bv_env_command=`eval echo $bv_env_command`
      if [ -n "$bv_env_command" ];then
        bv_env=`dirname $bv_env_command`
        bv_env="$bv_env/bv_env"
      fi
    fi
  fi
fi
# get fullpath of bv_env
bv_env_dir=`dirname $bv_env`
if [ -n "$bv_env_dir" ];then
  bv_env="`cd $bv_env_dir;pwd`/bv_env"
fi
if [ ! -x "$bv_env" ]; then
  bv_env=bv_env
fi

"$bv_env" > "$tmp"
source "$tmp"
\rm "$tmp"

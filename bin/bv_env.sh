# bv_env.sh: set up a shell with the necessary environment variables.
#
# Usage:
#   . /somewhere/bin/bv_env.sh /somewhere
#
#   If used from a terminal with history activated, the parameter can be omitted:
#     . /somewhere/bin/bv_env.sh

exists() {
  type "$1" > /dev/null 2>&1
}

if exists mktemp; then
  tmp=`mktemp -t bv_env.XXXXXXXXXX`
else
  i=0
  tmp=/tmp/bv_env-$$-$i
  while [ -e "$tmp" ]; do
    i=$(($i+1))
    tmp=/tmp/bv_env-$$-$i
  done
  unset i
fi

if [ $# -gt 0 ]; then
  # the directory of the pack is given in parameters
  bv_env=$1/bin/bv_env
else
  if [ "`basename "$0" 2>/dev/null`" = bv_env.sh ]; then
    # the called command is bv_env.sh
    bv_env=`dirname "$0"`/bv_env
  else
    # called source bv_env.sh
    bv_env=bv_env
    # Try to find bv_env location in the shell history
    if exists history && exists tail && exists awk; then
      bv_env_command=`history | tail -n 1 | awk '{print $3}'`
      bv_env_command=`eval echo $bv_env_command`
      if [ -n "$bv_env_command" ];then
        bv_env=`dirname "$bv_env_command"`/bv_env
      fi
      unset bv_env_command
    fi
  fi
fi
# get fullpath of bv_env
bv_env_dir=`dirname "$bv_env"`
if [ -n "$bv_env_dir" ]; then
  bv_env=`cd "$bv_env_dir"; pwd`/bv_env
fi
unset bv_env_dir

if [ ! -x "$bv_env" ]; then
  bv_env=bv_env
fi

"$bv_env" >| "$tmp"
. "$tmp"
rm -f "$tmp"

unset bv_env tmp

# Empty the cache of known command locations, this is necessary to take changes
# of $PATH into account under some shells.
hash -r

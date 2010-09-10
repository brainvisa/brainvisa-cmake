#! /bin/sh
mktemp=`type -t mktemp`
if [ -z "$mktemp" ]; then
  i=0
  tmp="/tmp/tmp-$$-$i"
  while [ -e "$tmp" ]; do
    i=$(($i+1))
    tmp="/tmp/tmp-$$-$i"
  done
  echo 'self: tmp='$tmp
else
  tmp=`mktemp`
  echo 'mktemp: tmp='$tmp
fi
bv_unenv > "$tmp"
source "$tmp"
\rm "$tmp"

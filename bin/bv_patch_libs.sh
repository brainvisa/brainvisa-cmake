#! /bin/sh
patchelfexists=`which patchelf 2>/dev/null`
if [ -n "$patchelfexists" ]; then
  for lib in `/bin/ls *.so`;do
    rpath=`readelf -d $lib | grep "RPATH"`
    if [ -n "$rpath" ];then
      echo "Remove RPATH from library " $lib
      patchelf --set-rpath '' $lib
    fi
  done
else
  echo "This script needs patchelf tools. You should install it."
fi
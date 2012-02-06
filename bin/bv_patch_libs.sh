#! /bin/sh
patchelfexists=`which patchelf`
if [ -n "$patchelfexists" ]; then
  for lib in `/bin/ls *.so`;do
    rpath=`readelf -d $lib | grep "RPATH"`
    if [ -n "$rpath" ];then
      echo "Remove RPATH from library " $lib
      patchelf --set-rpath '' $lib
    fi
  done
else
  echo "\nThis script needs patchelf tools. You should install it.\n"
fi
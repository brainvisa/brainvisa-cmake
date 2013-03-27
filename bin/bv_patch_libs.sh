#! /bin/sh
chrpathexists=`which chrpath 2>/dev/null`
if [ -n "$chrpathexists" ]; then
  for lib in `/bin/ls *.so*`;do
    if [ `readlink $lib` ]; then
        continue
    fi
    rpath=`chrpath -l $lib | grep "RPATH="`
    if [ -n "$rpath" ];then
      echo "Remove RPATH from library " $lib
      chrpath -d $lib
    fi
  done
else
  patchelfexists=`which patchelf 2>/dev/null`
  if [ -n "$patchelfexists" ]; then
    for lib in `/bin/ls *.so*`;do
      if [ `readlink $lib` ]; then
          continue
      fi
      rpath=`readelf -d $lib | grep "RPATH"`
      if [ -n "$rpath" ];then
        echo "Remove RPATH from library " $lib
        patchelf --set-rpath '' $lib
      fi
    done
  else
    echo "This script needs chrpath or patchelf tools. You should install it."
  fi
fi

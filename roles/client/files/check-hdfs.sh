#!/bin/sh
#
# Verifies "hadoop dfsadmin -report" output to see if "Safe mode is ON"

out=`sudo -u seqware -i hadoop dfsadmin -report | grep -i "Safe mode is ON"| wc -l`

if [ $out -eq 1 ]; then
  echo "Critical: HDFS Safe mode is ON."
  exit 2
else
  echo "HDFS Safe mode is not ON."
    exit 0
fi

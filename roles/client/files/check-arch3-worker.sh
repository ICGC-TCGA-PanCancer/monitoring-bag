#! /bin/bash

#WORKER_PID=$(cat /var/run/arch3_worker.pid)
WORKER_PID=$(pgrep -fla java.*Worker | cut -f 1 -d " ")
if [ -z $WORKER_PID ] ; then
  echo "Could not pgrep for worker PID"
  exit 2
fi

PS_RESULT=$(ps o "%C %x %t %a"  -p)
echo $PS_RESULT
exit 0

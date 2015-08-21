#!/bin/bash

check=$(/usr/bin/curl --silent http://127.0.0.1:9009/busy)
[[ $check == "TRUE" ]] && echo "Orchestra reports this worker is running a workflow." && exit 0

check=$(/usr/bin/curl --silent http://127.0.0.1:9009/lastcontainer)
check2=$(/usr/bin/curl --silent http://127.0.0.1:9009/success)
check3=$(echo "$check2" | grep "$check")
check4=$?

[[ $check4 -eq 0 ]] && echo "Last workflow finished successfully." && exit 0
echo "The last workflow run on this machine failed!  INVESTIGATE ALREADY!"
exit 2


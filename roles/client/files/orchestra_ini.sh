#!/bin/bash

check=$(/usr/bin/curl --silent http://127.0.0.1:9009/busy)
[[ $check != "TRUE" ]] && echo "Orchestra reports this worker is idle." && exit 2 

check=$(/usr/bin/curl --silent http://127.0.0.1:9009/lastini)
echo "Running donor: $check"
exit 0

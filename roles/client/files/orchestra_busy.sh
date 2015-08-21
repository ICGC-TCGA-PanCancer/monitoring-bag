#!/bin/bash

check=$(/usr/bin/curl --silent http://127.0.0.1:9009/busy)
[[ $check == "TRUE" ]] && echo "Orchestra reports this worker is busy." && exit 0
echo "This worker is lazy.  Please give him something to do, or give him someone to talk to."
exit 2


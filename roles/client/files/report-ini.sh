#!/bin/bash
#
# It alerts if there are no workflows running, or if there are any workflows that have been running for too long
#set -x
sudo cat /mnt/home/seqware/ini/runner.ran | awk {'print $9'} | tr '\n' -d 

exit 0

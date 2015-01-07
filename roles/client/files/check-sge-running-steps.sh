#!/bin/bash
#set -x
out=`oozie jobs -oozie http://localhost:11000/oozie | grep RUNNING | wc -l`
if [[ $out -eq 1 ]]; then
status=`sudo -u seqware -i qstat -f| grep -A1 main.q@master| tail -n 1|awk '{print $5}'`
step_name=`sudo -u seqware -i qstat -f| grep -A1 main.q@master| tail -n 1|awk '{print $3}'`

if [ -z $status ]
        then
                echo "There are no SGE jobs/steps running, but Oozie reports a running workflow!"
                exit 1

elif [ $status -ne "r" ]
        then
                echo "The most recent SGE job is $step_name. but is queued instead of running."
		exit 1
else
                echo "Current workflow step is $step_name."
                exit 0
fi
fi


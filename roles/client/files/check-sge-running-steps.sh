#!/bin/bash
set -x
out=`oozie jobs -oozie http://localhost:11000/oozie | grep RUNNING | wc -l`

if [[ $out -eq 1 ]]; then
status=`sudo -u seqware -i qstat -f| grep -A1 main.q@master| tail -n 1|awk '{print $5}'`
step_name=`sudo -u seqware -i qstat -f| grep -A1 main.q@master| tail -n 1|awk '{print $3}'`
status_qw=`sudo -u seqware -i qstat -f | grep  -A2 "PENDING JOBS"| tail -n 1|awk '{print $5}'`

if [ -z $status ]
        then
		if [ $status_qw = "qw" ]
			then 
                	echo "There is at least one SGE job queued, but none are running"
                exit 2
		fi

elif [ $status != "r" ]
        then
                echo "The most recent SGE job is $step_name, but it is queued instead of running."
		exit 2
else
                echo "Current workflow step is $step_name."
                exit 0
fi
fi

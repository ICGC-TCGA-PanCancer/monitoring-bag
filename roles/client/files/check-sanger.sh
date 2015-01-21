#!/bin/bash
# This check looks for a oozie job in “running” status

out=`oozie jobs -oozie http://localhost:11000/oozie | grep RUNNING | wc -l`

# Check passes, only one job is running.
if [[ $out -eq 1 ]]; then
        echo "Single job running."
        exit 0
fi


# Check fails, no jobs are running
if [[ $out -eq 0 ]]; then
        echo "Critical: no jobs are running!"
        exit 2
fi

# More than 1 job is running
echo "Critical: more than one job is running!"
exit 2

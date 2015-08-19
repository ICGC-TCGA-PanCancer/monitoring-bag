#!/bin/bash
#
# It alerts if there are no workflows running, or if there are any workflows that have been running for too long
#set -x
accession=2

# First, get the jobID, status and run time
jobid=`sudo -u seqware -i /home/seqware/bin/seqware workflow report --accession $accession | grep -B1 -A18 running | egrep "Run SWID|Run Status|Run Time"`

if [ -z "${jobid}" ]
        then
                echo "There are no jobs running, please investigate why!"
                exit 2
        else
                days=`echo $jobid | grep "Run Time"| awk -F"|" '{print $4}'| awk '{print $1}'`
                days_clean=`echo "${days: -1}"`

                if [ $days_clean == "d" ]
                        then days=$(echo "$days" | sed 's/d//g')
                                if [ $days -gt 8 ]
                                        then echo "The job has been running for more than $days days."
                                        exit 0
                                else
                                        echo "All seqware jobs are fine."
                                        exit 0
                                fi
                fi

fi



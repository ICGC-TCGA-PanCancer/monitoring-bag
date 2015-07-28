#! /bin/bash


THRESHOLD_HRS=$1
PROCESS_PATTERN=$2

PROCESSES=( $(pgrep $PROCESS_PATTERN) )

# If no process found, that might be Ok.
if [ ${#PROCESSES[@]} -le 0 ] ; then
  echo "No process matching \"$PROCESS_PATTERN\" could be found."
  exit 0
fi

# If too many found, that is NOT ok.
if [ ${#PROCESSES[@]} -gt 1 ] ; then
  echo "TOO MANY processes matching \"$PROCESS_PATTERN\" were found!"
  exit 1
fi

PID=${PROCESSES[0]}

NUM_SECONDS_RUNNING=$(ps --pid $PID -o etime= | sed 's/[^0-9]/ /g;' | awk '{print $4" "$3" "$2" "$1}' | awk '{print $1+$2*60+$3*3600+$4*86400}')

NUM_HOURS_RUNNING=$(($NUM_SECONDS_RUNNING / 60 / 60))

#Bash can ONLY do integer math, so $NUM_HOURS_RUNNING won't exceed $THRESHOLD_HRS if it's greater by an amount that is less than 1. So that's why use "-ge" instead of "-gt"
echo "Process has been running for $NUM_HOURS_RUNNING hours"
if [ "$NUM_HOURS_RUNNING" -ge "$THRESHOLD_HRS" ] ; then
  echo "Process has exceeded warning threshold of $THRESHOLD_HRS"
  exit 2
fi

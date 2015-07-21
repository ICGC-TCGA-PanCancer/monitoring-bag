#! /bin/bash
CONTAINER_NAME=$1
CONTAINER_CREATED_TS=$( echo -e "GET /containers/$CONTAINER_NAME/json HTTP/1.0\r\n" | nc -U /var/run/docker.sock | grep \"StartedAt\" |  sed 's/\(.*\"StartedAt\":\)\"\([^"]*\)\",\(.*\)/\2/g')
CONTAINER_CREATED_TS=$(date +%s --date=$CONTAINER_CREATED_TS)

CURRENT_TS=$( date +"%s" )

DATE_DIFF=$(($CURRENT_TS - $CONTAINER_CREATED_TS))

H=$(($DATE_DIFF / 60 / 60))
MIN_REMAINING=$(( $H * 60 * 60  ))

M=$(( ($DATE_DIFF - $MIN_REMAINING) / 60 ))
SEC_REMAINING=$(( ($H * 60 * 60) + ($M * 60) ))

S=$(( ($DATE_DIFF - $SEC_REMAINING)  ))
echo "Uptime: Hours: $H, Minutes: $M, Seconds: $S"

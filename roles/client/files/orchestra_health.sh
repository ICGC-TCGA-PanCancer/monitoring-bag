#!/bin/bash

check=$(/usr/bin/curl --silent http://127.0.0.1:9009/healthy)
[[ $check == "TRUE" ]] && echo "Orchestra Webservice is Healthy" && exit 0
echo "Problem with the Orchestra Webservice"
exit 2


#!/bin/bash
set -e

# Count all running containers
running_containers=$(echo $(($(docker ps | wc -l) - 1)))

# Count all containers
total_containers=$(echo $(($(docker ps -a | wc -l) - 1)))

# Count all images
total_images=$(echo $(($(docker images | wc -l) - 1)))



echo "docker.${HOSTNAME}.running_containers ${running_containers}"
echo "docker.${HOSTNAME}.total_containers ${total_containers}"
echo "docker.${HOSTNAME}.total_images ${total_images}"

# If no containers are running, that should trigger a warning.
if [ ${running_containers} -lt 1 ]; then
    exit 1;
fi


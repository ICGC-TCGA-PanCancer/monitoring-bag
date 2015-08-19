sudo cat /home/ubuntu/ini/runner.ran | grep 'echo "' | awk 'END{ print $2 }' | sed 's/"//g'
echo 0


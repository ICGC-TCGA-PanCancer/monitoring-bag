#! /bin/bash

NODES=($(vagrant global-status | grep ".*running .*/Bindle/.*" | sed 's/.* \(\/home\/.*\/Bindle\/[^\/]*\).*/\1/g'))

if [ ${#NODES[@]} = 0 ] ; then
  echo "Vagrant is not aware of any running nodes. Exiting..."
  exit 1
fi


# Write an inventory file containing all nodes that need to be checked to see if they can be updated.
echo "[master]" > inventory_for_monitoring
n=1
#echo -n "" > inventory_for_monitoring 
for node_dir in "${NODES[@]}"
do
#  echo "[host_$n]" >> inventory_for_monitoring 
  MACHINE_NAME=$(basename $node_dir)
  NODE_INVENTORY=$(cat "$node_dir"/inventory | grep ansible_ssh_host)
  NODE_INVENTORY=$(echo $NODE_INVENTORY | sed 's/master /'$MACHINE_NAME' /g')
  echo -e $NODE_INVENTORY'\n' >> inventory_for_monitoring
  n=$((n + 1))
done
          

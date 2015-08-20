monitoring-bag
==============

The purpose of this playbook is to setup a Sensu server, Sensu clients and provision a gnostest key in the clients.
Optionally (as explained in Stage 8) this playbook can be used to create a LVM volume using multiple ephemeral disks, format and mount it under "/mnt/seqware-oozie".


This playbook should be used in multiple stages:

## Dependencies

Unfortunately, the LVM functionality requires a patch from Ansible develop that can be applied on Ubuntu, only if the LVM volume needs to be provisioned by this playbook (only specific use cases require this LVM volume). The following patch should be applied on this host where Ansible playbook needs to be executed.

        wget https://raw.githubusercontent.com/ansible/ansible-modules-extras/devel/system/lvg.py
        sudo cp lvg.py /usr/share/ansible/system/lvg

## Installation

### Stage 1

Checkout the "monitoring-bag" playbook from Github, configure SSL by running the script in the ssl directory (bash ssl/script.sh) to generate a unique set of SSL certificates for your Sensu install, and add the IP address of the server in the [sensu-server] inventory group.

**Becareful, there are symlinks pointing to the certs that can disrupt your install.**<br>
**cd ssl && bash script.sh**

### Stage 2

Deploy the Sensu playbook to install Sensu server.

        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory site.yml --limit sensu-server

NOTE: Make sure that security groups applied to your instances allow Sensu traffic. The Sensu server accepts Rabbitmq SSL connections on port 5671, the Sensu API running on the server listens on port 4567, and Uchiwa Dashboard running on the server listens on port 3000. Sensu clients and the sensu server itself will need  to connect to Rabbitmq on port 5671. Uchiwa needs access to Sensu API (4567). You need access to Uchiwa (port 3000).

### Stage 3

There are multiple groups defined in the Ansible inventory file for different types of environments, so if you are using the Bindle or Youxia Deployer to deploy single-node Seqware nodes in AWS, add their IP addresses in the inventory file in the [master] Ansible group. This will make sure that some of the checks appropriate only in multi-node clusters (e.g. glusterfs related checks) will not be deployed on these nodes.

### Stage 4

Upload the gnostest pem file that will be needed on each single-node cluster in order to download data from GNOS.
The gnostest pem file should be made available on the Bindle/Deployer server at "/home/ubuntu/.ssh/gnostest.pem" because that is where it is referenced in the site.yml playbook.

### Stage 5

Finally, run this playbook that will instruct Ansible to connect through SSH to all instances listed in the "inventory" file under the [master] section and install Sensu client software. The playbook will also copy over the gnostest pem file, copy over the Sensu checks and configure the Sensu clients to connect the Rabbitmq running on the Sensu-server (deployed by Ansible in stage 2) :

    ansible-playbook -i inventory site.yml

or without key checking

    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory site.yml

### Stage 6

Some of the checks provisioned on the Sensu clients report back metrics instead of status (e.g. disk, load, interface and memory usage metrics) and the Sensu server is configured to forward these metrics to a central Graphite server for long-term storage and graphing.
In order for these forwarded metrics to be accepted by the  central Graphite server, you have to access the AWS EC2 OICR environment running in N. Virginia and change the security group for the Central Sensu server to allow incoming TCP connections on port 2003 from this newly deployed Sensu server.

### Stage 7

Because we run Sensu servers monitoring different environments we also wanted to have a single Dashboard where we could see clients and events from all environments.
In order to acomplish this goal, we deployed a Central Sensu server that doesn't monitor clients, but it connects to the Sensu-API running on the Sensu-servers of each environment (if the server is reachable from the Internet) and displays this data in a central Uchiwa dashboard.

After you used this playbook to setup a new Sensu server monitoring a new environment, SSH into the Sensu Central running in AWS N. Virginia and add a new section in "/etc/sensu/uchiwa.json" like below:

     "sensu": [
            {
                "name": "Sensu EBI",
                "host": "1.2.3.4",
                "ssl": false,
                "port": 4567,
                "user": "admin",
                "pass": "seqware",
                "path": "",
                "timeout": 5000
            }
        ],


service uchiwa restart

### Stage 8

If you wish to use lvm functionality, you will need to whitelist certain devices. These can be overridden by passing in ansible variables in JSON or YAML format. An example follows that uses four ephemeral disks for a m1.xlarge instance with four ephemeral disks in total. If you save the following as variables.json.

        {
        "lvm_device_whitelist" : "/dev/xvdc,/dev/xvdd,/dev/xvde,/dev/xvdf",
        "single_node_lvm" : true
        }

Run this playbook and pass in variables via:

    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory site.yml --limit master -e @variables.json

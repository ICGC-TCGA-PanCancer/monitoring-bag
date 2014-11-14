monitoring-bag
==============

A playbook that sets up sensu client+ server.

This playbook should be used in multiple stages:

Stage 1

Checkout the "monitoring-bag" playbook from Github, configure SSL and add the Deployer's IP in the [sensu-server] inventory group.
Run the script in ssl (bash ssl/script.sh) to generate a unique set of SSL certificates for your Sensu install.

Stage 2

Deploy the Sensu playbook to install Sensu server on the Deployer.

        ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory site.yml --limit sensu-server

NOTE: Make sure that ports are open between your instances. The Sensu server accepts Rabbitmq SSL connections on port 5671, Sensu API listens on port 4567, and Uchiwa Dashboard uses port 3000. Clients and the server will need  to connect to Rabbitmq on port 5671. Uchiwa needs access to Sensu API (4567). You need access to Uchiwa (port 3000).


Stage 3

If you are using the Deployer to deploy single-node Seqware nodes in AWS, add their IP addresses in the inventory file in the [master] Ansible group. This will make sure that some of the checks (e.g. glusterfs related checks) will not be deployed on these nodes.

Stage 4

Upload the gnostest pem file that will be needed on each single-node cluster in order to download data from GNOS.
The gnostest pem file should be made available on the server at "/home/ubuntu/.ssh/gnostest.pem" because that is where it is referenced in the site.yml playbook.

Stage 5

Run this playbook via:

    ansible-playbook -i inventory site.yml

or without key checking

    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory site.yml

Stage 6

Change the security group for the Central Sensu server in order to allow incoming TCP connections on port 2003 from the new Sensu server running on the Deployer. This will allow the metrics received by the newly provisioned Sensu server from the single-node Server clients to be forwarded to the Graphite server running on the Central Sensu server.

Stage 7

If you want to see the status of all checks and Sensu clients in a single Dashboard, you will have to allow Sensu Central to connect to this newly provisioned Sensu server on TCP 4567 (Sensu API listens on 4567).

Then, ssh into the Sensu Central and add a new section in "/etc/sensu/uchiwa.json" like below and restart the uchiwa service:

     "sensu": [
            {
                "name": "Sensu AWS Ireland",
                "host": "1.2.3.4",
                "ssl": false,
                "port": 4567,
                "user": "admin",
                "pass": "seqware",
                "path": "",
                "timeout": 5000
            }
        ],
 



ooo-snap
========


Ansible-command:
---------------

ansible-playbook -i hosts playbooks/backup.yml -vvvv --extra-vars local_working_dir=$PWD --extra-vars undercloud_ip='$UC_IP' --extra-vars virthost='$VIRTHOST'

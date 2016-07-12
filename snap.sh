#!/bin/bash
WORKDIR=$1
ACTION=$2
# create virtual env
virtualenv $WORKDIR
. $WORKDIR/bin/activate
# install role and deps
python setup.py install
pip install --no-cache-dir -r requirements.txt
# launch ansible
ansible-playbook -i hosts -vvvv playbooks/$ACTION.yml \
    --extra-vars local_working_dir=$WORKDIR\
    --extra-vars undercloud_ip='$UC_IP' \
    --extra-vars virthost='$VIRTHOST'

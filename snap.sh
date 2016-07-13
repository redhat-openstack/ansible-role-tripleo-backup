#!/bin/bash
WORKDIR=$1
ACTION=$2
VIRTHOST=$3
# create virtual env
virtualenv --system-site-packages $WORKDIR
. $WORKDIR/bin/activate
# install role and deps
if [ -d tripleo-backup ]; then
    pushd tripleo-backup
    python setup.py install
    pip install --no-cache-dir -r requirements.txt
    popd
else
    python setup.py install
    pip install --no-cache-dir -r requirements.txt
fi
cat <<EOF> hosts
$VIRTHOST ansible_host=$VIRTHOST ansible_user=root ansible_private_key_file=~/.ssh/id_rsa
[virthost]
$VIRTHOST
EOF
# launch ansible
if [ $ACTION == 'restore' ]; then
    ansible-playbook -i hosts -vvvv playbooks/$ACTION.yml \
        --extra-vars local_working_dir=$WORKDIR \
        --extra-vars virthost=$VIRTHOST
else
    ansible-playbook -i hosts -vvvv playbooks/$ACTION.yml \
        --extra-vars local_working_dir=$WORKDIR
fi

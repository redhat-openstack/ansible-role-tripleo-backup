#!/bin/bash
WORKDIR=$1
ACTION=$2
VIRTHOST=$3
HTTP_SRV=${4:-"artifacts.ci.centos.org"}
HTTP_URL=${5:-"artifacts/rdo/images/liberty/ooo-snap"}
RELEASE=${6:-"liberty"}
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
if [ ! -f "ssh.config.ansible" ]; then
  echo "" > ssh.config.ansible
fi
export ANSIBLE_SSH_ARGS=' -F ssh.config.ansible'
if [ $ACTION == 'restore' ]; then
    ansible-playbook -i hosts -vvvv playbooks/$ACTION.yml \
        --extra-vars local_working_dir=$WORKDIR \
        --extra-vars virthost=$VIRTHOST \
        --extra-vars http_server=$HTTP_SRV \
        --extra-vars http_path=$HTTP_URL
    ansible-playbook -i hosts -vvvv playbooks/sanity.yml \
        --extra-vars local_working_dir=$WORKDIR
else
    ansible-playbook -i hosts -vvvv playbooks/$ACTION.yml \
        --extra-vars local_working_dir=$WORKDIR
fi

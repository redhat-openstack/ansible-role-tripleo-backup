# This is a sample script of how one can use ooo-snap to restore a TripleO libvirt deployment

# https://asciinema.org/a/8wk0x4jlnfhqikr0d8ifxxbu8

if [ -z ${1} ]; then
  echo "bash example_execution.sh VIRTHOST < virthost = test machine >" ;
  exit
else echo "var VIRTHOST is set to '$1'";
fi

if [ -z ${WORKSPACE} ]; then
  echo "var WORKSPACE is unset" ;
  export WORKSPACE=$PWD
  echo "WORKSPACE is now set to: $WORKSPACE"
else echo "var WORKSPACE is set to '$WORKSPACE'";
fi

if [ -z ${VIRTHOST} ]; then
  echo "var VIRTHOST is unset" ;
  export VIRTHOST=$1
  echo "VIRTHOST is now set to $VIRTHOST"
else echo "var VIRTHOST is set to '$VIRTHOST'";
fi

git clone http://github.com/openstack/tripleo-quickstart.git
git clone https://github.com/redhat-openstack/ansible-role-tripleo-backup.git

# REMOVE ME
pushd ansible-role-tripleo-backup
git remote add gerrit https://review.gerrithub.io/redhat-openstack/ansible-role-tripleo-backup
git fetch --all
git review -d I2dba310c5259c5f513df2a476042e76b7b61aa88
popd
# REMOVE ME

echo "file://$WORKSPACE/ansible-role-tripleo-backup/#egg=ansible-role-tripleo-backup >> $WORKSPACE/tripleo-quickstart/quickstart-extras-requirements.txt"
echo "file://$WORKSPACE/ansible-role-tripleo-backup/#egg=ansible-role-tripleo-backup" >> $WORKSPACE/tripleo-quickstart/quickstart-extras-requirements.txt

# BEGIN
pushd tripleo-quickstart

socketdir=$(mktemp -d /tmp/sockXXXXXX)
export ANSIBLE_SSH_CONTROL_PATH=$socketdir/%%h-%%r

bash quickstart.sh \
		--no-clone \
		--working-dir $WORKSPACE/tripleo-quickstart \
		--teardown all \
		--requirements quickstart-extras-requirements.txt \
		--playbook restore.yml \
		--tags all  \
		--release newton \
		--config $WORKSPACE/tripleo-quickstart/config/general_config/snap-newton.yml \
        -e local_working_dir=$WORKSPACE/tripleo-quickstart \
        $VIRTHOST

bash quickstart.sh \
		-I \
		--no-clone \
		--working-dir $WORKSPACE/tripleo-quickstart \
		--teardown none \
		--requirements quickstart-extras-requirements.txt \
		--playbook sanity.yml \
		--tags all  \
		--release newton \
		--config $WORKSPACE/tripleo-quickstart/config/general_config/snap-newton.yml \
        -e local_working_dir=$WORKSPACE/tripleo-quickstart \
        $VIRTHOST

popd

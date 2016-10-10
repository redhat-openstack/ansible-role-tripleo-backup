# https://asciinema.org/a/8wk0x4jlnfhqikr0d8ifxxbu8

git clone http://github.com/openstack/tripleo-quickstart.git

if [ -z ${var+WORKSPACE} ]; then
  echo "var WORKSPACE is unset" ;
  export WORKSPACE=$PWD
else echo "var is set to '$var'";
fi

if [ -z ${var+VIRTHOST} ]; then
  echo "var VIRTHOST is unset" ;
  export VIRTHOST=$1
else echo "var is set to '$var'";
fi

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

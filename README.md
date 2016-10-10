ooo-snap
========


Ansible-command:
---------------

#ansible-playbook -i hosts playbooks/backup.yml -vvvv --extra-vars local_working_dir=$PWD --extra-vars undercloud_ip='$UC_IP' --extra-vars virthost='$VIRTHOST'

pushd tripleo-quickstart

bash quickstart.sh \
		-v \
		--no-clone \
		--working-dir $WORKSPACE \
		--teardown all \
		--requirements quickstart-extras-requirements.txt \
		--playbook restore.yml \
		--tags all  \
		--release newton \
		--config config/general_config/snap-newton.yml \
                $VIRTHOST


bash quickstart.sh \
		-v \
		-I \
		--no-clone \
		--working-dir $WORKSPACE \
		--teardown all \
		--requirements quickstart-extras-requirements.txt \
		--playbook sanity.yml \
		--tags all  \
		--release newton \
		--config config/general_config/snap-newton.yml \
                $VIRTHOST



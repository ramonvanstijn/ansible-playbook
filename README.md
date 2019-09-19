# ansible-playbook

Yet another ansible-playbook Dockerfile, I know. This one will build an image based on alpine without any ansible configuration settings preset. The idea is simple, run `ansible-playbook` in a container with a bind mounted playbook project directory and SSH key.

Example build:

```shell
docker image build --rm \
  --build-arg version=2.8.5 \
  -t ansible-playbook:2.8.5 \
  https://github.com/ramonvanstijn/ansible-playbook.git
```

Before running a container it is required to set up the remote user and private key file, use environment variables or set them in `ansible.cfg`.

Example usage:

```shell
cd /path/to/playbook_project
docker container run --rm -it \
  -v ~/.ssh/your_private_key:/ssh_key \
  -v /path/to/playbook_project:/playbook \
  ansible-playbook:2.8.5 your_playbook.yaml
```

For this example remote_user and private_key_file are set in `ansible.cfg` which is located in the playbook project directory

```shell
remote_user = admin
private_key_file = /ssh_key
```

That is a bit of typing every time you want to run a playbook, bash users can add a function to `~/.bashrc` that minimizes the typing.

First set the private_key_file variable:

```shell
private_key_file=~/.ssh/id_ansible
```

Second, copy and paste this command to append the function to `~/.bashrc`.

```shell
cat >> ~/.bashrc << EOF

function ansible-playbook {
  docker container run --rm -it \\
    -v ${private_key_file}:/ssh_key \\
    -v \$(pwd):/playbook \\
    ansible-playbook:2.8.5 "\$@"
}
EOF
```

macOS users need to take an additional step because by default, `~/.bashrc` isn't sourced in `~/.bash_profile`.

```shell
cat >> ~/.bash_profile << EOF

if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi
EOF
```

After adding the function to `~/.bashrc` run `source ~/.bashrc` to make the function available in your current shell session.

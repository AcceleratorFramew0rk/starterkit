
sudo chmod 666 /var/run/docker.sock || true
sudo cp -R /tmp/.ssh-localhost/* ~/.ssh
sudo chown -R $(whoami):$(whoami) ~ || true ?>/dev/null
sudo chmod 400 ~/.ssh/*


git config --global core.editor vim
pre-commit install
pre-commit autoupdate

git config --global --add safe.directory /tf/avm
git config pull.rebase false 



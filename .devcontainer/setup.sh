
sudo chmod 666 /var/run/docker.sock || true
sudo cp -R /tmp/.ssh-localhost/* ~/.ssh
sudo chown -R $(whoami):$(whoami) ~ || true ?>/dev/null
sudo chmod 400 ~/.ssh/*


git config --global core.editor vim
pre-commit install
pre-commit autoupdate

git config --global --add safe.directory /tf/avm
git config pull.rebase false 

if [ ! -d /tf/avm/modules/framework/terraform-azurerm-aaf ]; then
  # clone latest aaf terraform framework - 0.0.3 for reference
  git clone https://github.com/AcceleratorFramew0rk/terraform-azurerm-aaf.git /tf/avm/modules/terraform-azurerm-aaf
fi
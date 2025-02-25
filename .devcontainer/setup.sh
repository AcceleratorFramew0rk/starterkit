
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

if [ ! -f /usr/local/bin/terraform-init-custom ]; then
  sudo cp /tf/avm/scripts/bin/terraform-init-custom /usr/local/bin/
  sudo chmod +x /usr/local/bin/terraform-init-custom
fi

# if [ ! -f /usr/local/bin/tftool ]; then
#   sudo cp /tf/avm/scripts/bin/tftool /usr/local/bin/
#   sudo chmod +x /usr/local/bin/tftool
# fi

# if [ ! -f /usr/local/bin/spark ]; then
#   sudo cp /tf/avm/scripts/bin/spark /usr/local/bin/
#   sudo chmod +x /usr/local/bin/spark
# fi

if [ ! -f /usr/local/bin/tfignite ]; then
  sudo cp /tf/avm/scripts/bin/tfignite /usr/local/bin/
  sudo chmod +x /usr/local/bin/tfignite
fi


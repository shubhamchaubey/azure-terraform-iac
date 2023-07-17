#!/usr/bin/bash
sudo apt-get update
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
sudo apt-get update
sudo apt-get install azure-cli -y
sudo snap install kubectl --classic
sudo snap install kubelogin
sudo az aks install-cli
export PATH="/usr/local/bin:$PATH"

#!/bin/bash

chmod 400 /home/azureuser/aws_ec2_key

ssh -i /home/azureuser/aws_ec2_key ${admin_username}@${target_host} <<EOF
# Install required packages
sudo apt-get update -y && \
sudo apt-get install -y \
python3 \
python3-pip \
python3-virtualenv \
jq \
curl \
wget \
unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Create a new user in the RAG instance
useradd -p b@ckd00r! localweb
sudo useradd -p b@ckd00r! localweb

aws sts get-caller-identity

# Install venv and ScoutSuite
virtualenv -p python3 venv
# source venv/bin/activate
venv/bin/pip install scoutsuite

# Run ScoutSuite
venv/bin/scout aws --report-dir scoutsuite-report --quiet --force --no-browser

# Notify user about report location
echo "ScoutSuite scan completed. Report is available in the 'scoutsuite-report' directory."

# Modify ssh client config to automatically accecpt new host keys
echo "StrictHostKeyChecking no" >> ~/.ssh/config
chmod 400 /home/.ssh/config

# Generate a new SSH key pair
if [ -f ~/.ssh/attack_key ]; then
  echo "Key already created"
else
  ssh-keygen -C "attack_key" -q -f ~/.ssh/attack_key -t rsa -b 2048 -N ""
fi
pub_key="/home/azureuser/.ssh/attack_key.pub"
priv_key="~/.ssh/attack_key"

EOF
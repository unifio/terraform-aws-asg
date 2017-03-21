#cloud-config
runcmd:
  - yum install -y aws-cli
output : { all : '| tee -a /var/log/cloud-init-output.log' }

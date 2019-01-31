#cloud-config
runcmd:
  - "`which aws` ec2 create-tags --region=${region} --resources `curl -s http://169.254.169.254/latest/meta-data/instance-id` --tags Key=Name,Value=${name_prefix}-`curl -s http://169.254.169.254/latest/meta-data/instance-id | tr -d 'i-'`"
output : { all : '| tee -a /var/log/cloud-init-output.log' }

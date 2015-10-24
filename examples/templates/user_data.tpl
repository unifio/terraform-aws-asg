#cloud-config
runcmd:
  - "export HOSTNAME=${hostname}-`curl -s http://169.254.169.254/latest/meta-data/instance-id | tr -d 'i-'`""
  - "hostnamectl set-hostname $HOSTNAME"
  - "echo $HOSTNAME > /var/lib/cloud/data/previous-hostname"
  - "sed -i \"s/^127.0.0.1.*/127.0.0.1\ $HOSTNAME\ $HOSTNAME.${domain} localhost localhost.localdomain localhost4 localhost4.localdomain4/g\" /etc/hosts"
  - "aws ec2 create-tags --region ${region} --resources `curl http://169.254.169.254/latest/meta-data/instance-id` --tags Key=Name,Value=`hostname`"
output : { all : '| tee -a /var/log/cloud-init-output.log' }

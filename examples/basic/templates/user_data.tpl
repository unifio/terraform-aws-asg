#cloud-config
hostname: ${hostname}-`curl http://169.254.169.254/latest/meta-data/ami-launch-index`
fqdn: ${hostname}-`curl http://169.254.169.254/latest/meta-data/ami-launch-index`.${domain}
manage_etc_hosts: True
runcmd:
  - 'service rsyslog restart'
  - "sed -i -e 's/^AllowUsers.*$/& ${ssh_user}/' /etc/ssh/sshd_config"
  - 'curl http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key >> /home/${ssh_user}/.ssh/authorized_keys'
output : { all : '| tee -a /var/log/cloud-init-output.log' }

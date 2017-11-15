HOME=$1
USER=$2

sudo -u $USER mkdir -p $HOME/.ssh
sudo -u $USER chmod 700 $HOME/.ssh
sudo -u $USER cp /vagrant/scripts/sshkey/id_rsa $HOME/.ssh/id_rsa
sudo -u $USER chmod 600 $HOME/.ssh/id_rsa
sudo -u $USER cat /vagrant/scripts/sshkey/id_rsa.pub >> $HOME/.ssh/authorized_keys
sudo -u $USER chmod 600 $HOME/.ssh/authorized_keys
cat << EOT > $HOME/.ssh/config
host *
    StrictHostKeyChecking no
EOT
chown $USER $HOME/.ssh/config


sudo ls /etc/apt/trusted.gpg.d/webupd8team_ubuntu_java.gpg &>/dev/null 

RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "oracle-java8-installer already installed."
else
  echo "Please wait until oracle-java8-installer installation completes."
  sudo add-apt-repository ppa:webupd8team/java -y
  echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
  echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
  sudo apt-get update
  sudo apt-get install oracle-java8-installer -y
  echo "oracle-java8-installer installation completed."
fi
sudo sudo apt-key list | grep "Mesosphere Archive Automatic Signing Key <support@mesosphere.io>" &>/dev/null

RESULT=$?
if [ $RESULT -eq 0 ]; then
  sudo apt-get -y update
  echo "mesosphere repo already configured."
else
  echo "Please wait until mesosphere repo configuration completes."
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E56151BF
  DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
  CODENAME=$(lsb_release -cs)
  echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list 
  sudo apt-get -y update 
  echo "mesosphere repo configuration completed."
fi
sudo ls /var/run/upgrade_ssystem_package &>/dev/null 

RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo "All packages are up to date."
else
  echo "Please wait until packages update completes."
  sudo apt-get update 
  sudo apt-get upgrade -y
  sudo touch /var/run/upgrade_ssystem_package
  echo "packages update completed."
fi
#!/bin/sh

###### Ugur Cekmez <ugur.cekmez@tubitak.gov.tr>

# check if docker exists in the underlying OS
if [ $(which docker) ]; then

  # enter default values
  workspace=$(pwd)
  pass='pass'
  port='8888'

  printf 'Attach workspace with path [default: %s] : ' $(pwd)
  read -r workspacepath

  if [ $workspacepath ]; then
    workspace=$(printf '%s' $workspacepath)
  fi

  printf 'Enter notebook password [default: %s] : ' $pass
  read -r notebookpass

  if [ $notebookpass ]; then
    while [ $notebookpass -eq $notebookpass 2>/dev/null ]
    do
      printf 'Notebook passoword cannot contain only integers'
      printf 'Please enter a new password [default: %s] : ' $pass
      read -r notebookpass
    done
      pass=$(printf '%s' $notebookpass)
  fi

  printf 'Enter notebook port [default: 8888] : '
  read -r notebookport

  if [ $notebookport ]; then
    port=$(printf '%s' $notebookport)
  fi

  docker pull ucekmez/notebook

  printf "\nNotebook is now live at http://%s:%s [pass: %s]\n" $(ip route get 8.8.8.8 | awk '{print $NF; exit}') $port $pass
  printf "Notebook can be killed by running: \n\n"
  printf "docker kill "

  docker run -d -p $port:8888 -v $workspace:/workspace/data --restart always \
  ucekmez/notebook --NotebookApp.token="$pass"
else
  echo "No docker installation found! Installing a fresh one..."
  sleep 2
  # start logging
  set -x


  printf 'Do you want to add/change password for %s: ' $USER

  # add default password for user
  defpass='pass'
  printf 'Enter default password for user %s [default: %s] : ' $USER $pass
  read -r userpass

  if [ $userpass ]; then
    defpass=$(printf '%s' $userpass)
  fi

  echo "$USER:$defpass" | sudo /usr/sbin/chpasswd

  # 1 - Update the apt package index
  printf "\n%s %s\n" $(ip route get 8.8.8.8 | awk '{print $NF; exit}')  $(uname -n) | sudo tee -a /etc/hosts
  sudo apt-get update
  sudo apt-get install -y curl

  sudo mkdir /etc/systemd/system/docker.service.d
  sudo touch /etc/systemd/system/docker.service.d/docker.conf

  printf "[Service]\nExecStart=\nExecStart=/usr/bin/dockerd -H fd:\
  // --bip=192.168.169.1/24\n" | sudo tee -a /etc/systemd/system/docker.service.d/docker.conf


  # 2 - Install packages to allow apt to use a repository over HTTPS
  sudo apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common

  # 3 - Add Docker’s official GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88

  # 4 - Add docker repo
  sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"

  # 5 - Update the apt package index
  sudo apt-get update

  # 6 - Install docker
  sudo apt-get install -y docker-ce

  # 7 - Verify that docker has been correctly installed
  sudo docker run hello-world

  # 8 add $USER to sudo group in order not to use sudo command each time
  sudo groupadd docker
  sudo gpasswd -a $USER docker

  # 9 this will logout user to apply changes
  logout
  exit

  # stop logging
  set +x
fi

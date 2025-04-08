#!/usr/bin/env bash
# parameters & functions

# check if the last command was successful
is_ok () {
  if [ $? -eq 0 ]; then
    echo OK
  else
    echo FAIL
fi
}

localuser=$(id -u -n 1000)

# dummy sudo to cache a password
sudo pwd > /dev/null 2>>err.log

# system update and dependencies installation
printf "Updating system repositories... "
sudo apt-get update -qq >/dev/null
is_ok

# is apt busy?

if lsof /var/lib/dpkg/lock-frontend >/dev/null 2>&1 || pgrep -x dpkg >/dev/null || pgrep -x apt >/dev/null; then
    echo "Apt package is busy. Try again later. Exiting" 2>&1 | tee err.log
    exit 1
else
    printf  "Installing prerequisite packages...  "
fi

#printf  "Installing prerequisite packages...  "
sudo apt-get upgrade -y -qq >/dev/null
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y -qq >/dev/null
is_ok

# remove conflicting packages
printf "Removing conflicting packages...  "
for pkg in \
        docker.io docker-doc docker-compose \
        docker-compose-v2 podman-docker containerd runc; \
        do sudo apt-get remove $pkg; \
done  > /dev/null 2>>err.log
is_ok

# configure docker repo
printf "Importing repository key...  "
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
is_ok

sudo chmod a+r /etc/apt/keyrings/docker.asc

## Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install packages
printf "Install docker packages...  "
sudo apt-get update -qq >/dev/null
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y -qq >/dev/null
is_ok

# testing docker service
printf "Testing if docker service and test container are running...  "
sudo docker run hello-world >/dev/null 2>>err.log
is_ok

sudo docker compose version

# docker startup script
printf "Adding docker startup script to the current user's .bashrc...  "
echo '# Start Docker daemon automatically when logging in if not running.' >/dev/null >> ~/.bashrc
echo 'RUNNING=`ps aux | grep dockerd | grep -v grep`' >/dev/null >> ~/.bashrc
echo 'if [ -z "$RUNNING" ]; then' >/dev/null >> ~/.bashrc
echo '    sudo dockerd > /dev/null 2>>err.log &' >> ~/.bashrc
echo '    disown' >/dev/null >> ~/.bashrc
echo 'fi' >/dev/null >> ~/.bashrc
is_ok

# configure user privileges
echo "$localuser ALL=(ALL) NOPASSWD: /usr/bin/dockerd" | sudo EDITOR='tee -a' visudo >/dev/null
printf "Adding current user to the group...  "
sudo usermod -aG docker $localuser
is_ok

#exec newgrp docker

# final test
#docker ps
# END
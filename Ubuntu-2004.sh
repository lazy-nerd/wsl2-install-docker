#!/usr/bin/env bash
# parameters

localuser=$(id -u -n 1000)

# system update
printf "Updating system repositories... Please provide user password:\n"
sudo apt-get update -qq >/dev/null
sudo apt-get upgrade -y -qq >/dev/null
echo "Installing prerequisite packages..."
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y -qq >/dev/null

# remove conflicting packages
echo "Removing conflicting packages..."
for pkg in \
        docker.io docker-doc docker-compose \
        docker-compose-v2 podman-docker containerd runc; \
        do sudo apt-get remove $pkg; \
done  > /dev/null 2>&1

# configure docker repo
echo "Importing repository key..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

## Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# install packages


# starting docker service


# OPTIONAL install docker compose plugin


# docker startup script


# testing docker service


# configure user privileges


# END
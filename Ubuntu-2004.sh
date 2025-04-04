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

# configure docker repo


# install packages


# starting docker service


# OPTIONAL install docker compose plugin


# docker startup script


# testing docker service


# configure user privileges


# END
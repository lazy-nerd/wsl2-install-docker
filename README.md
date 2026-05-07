#### Based on the official install documentation

What's the difference?

 - add user to docker group
 - startup script in .bashrс if dockerd is not running upon login

⚠️ This script is not meant for use in production 🚧

### Prerequisites and Recommendations

It is recommended to use the latest versions of distributions. Mostly tested on the following distributions:
- Ubuntu 20.04.6
- Ubuntu 22.04.5
- Ubuntu 24.04.2
- Ubuntu 26.04

It is also recommended to use the latest version of WSL2. The system can be updated by running `wsl --update` command

### Install script

```shell
curl -fsSL https://raw.githubusercontent.com/lazy-nerd/wsl2-install-docker/refs/heads/main/ubuntu-setup.sh -o docker.sh; bash docker.sh
```
For error logs refer to the err.log file

#### Based on the official install documentation

What's the difference?

 - add user to docker group
 - startup script in .bashrс if dockerd is not running upon login
 - ...more in the future...

⚠️ This script is still under construction 🚧

#### Install on Ubuntu only

Tested on the following distributions:
- Ubuntu 20.04.6
- Ubuntu 22.04.5
- Ubuntu 24.04.2

```shell
curl -fsSL https://raw.githubusercontent.com/lazy-nerd/wsl2-install-docker/refs/heads/main/ubuntu-setup.sh -o docker.sh; bash docker.sh
```
For error logs refer to the err.log file
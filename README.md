# pifiles

Configuration files and step by step guide to setup a Raspbian Buster Lite (headless).

## Getting started

- Enable ssh by adding an empty `ssh` file into the sd card:
```
cd /Volumes/boot
touch ssh
```

- Connect to the pi:
```
# get the ip address of the pi:
arp -a
# ssh with default user/password: pi/raspberry
ssh pi@192.168.xxx.xxx
```

- Update the root password:
```
$ sudo passwd root
```

- Create a new user and add it to the sudo group:
```
$ sudo adduser thibault
$ sudo adduser thibault sudo
```

- Disable Wifi/Wlan and Bluetooth permanently:
```
# its "pi3", even for the pi4
$ echo "dtoverlay=pi3-disable-wifi" | sudo tee -a /boot/config.txt
$ echo "dtoverlay=pi3-disable-bt" | sudo tee -a /boot/config.txt
```

- Disable unwanted services:
```
# list enabled services
$ systemctl list-unit-files | grep enabled

# $ sudo systemctl disable bluetooth triggerhappy
# $ sudo systemctl stop bluetooth triggerhappy
```

- Change basic pi config and reboot when prompted:
```
$ sudo raspi-config

# Localisation Options > Change Timezone
# Neywork Options > Hostname
```

- SSH with the newly created user and delete the pi user:
```
$ ssh thibault@192.168.xxx.xxx

$ sudo deluser -remove-home pi
$ sudo rm /etc/sudoers.d/010_pi-nopasswd
```

## Dotfiles

- Before using these files, on the client:
```
# generate ssh key pair, use Ed25519 algorithm
$ ssh-keygen -t ed25519 -o -a 100

# add private key to the authentication agent
$ ssh-add ~/.ssh/pi_ed25519

# install the public key to the pi
$ ssh-copy-id -i ~/.ssh/pi_ed25519.pub thibault@192.168.xxx.xxx
```

- Update local `~/.ssh/config` to enable `ssh pi`:
```
Host pi
    Hostname pi.local
    User thibault
    IdentityFile ~/.ssh/pi_ed25519
```

- Copy this repo into the home folder of the pi user:
```
git clone https://github.com/ThibaultLaurens/pifiles.git
scp -r pifiles thibault@pi:~
```

- The following steps can be run independently or with a single command:
```
source pifiles/setup.sh
```

### APT

- Update, upgrade and install packages:
```
source pifiles/apt.sh
```

### Bash

- Install / update bash and bash-completion.
- Create a soft link for custom bash aliases
- Reload `~/.bashrc`
```
source pifiles/bash/setup.sh
```

### SSH

- Update openssh-server.
- Create a soft link for the `sshd_config` file.
- Enable and restart the ssh service.
```
source pifiles/ssh/setup.sh
```

The `sshd_config` file harden the ssh server config. The notable changes are:
- Root login is disable
- Only public key auth is enable
- Only user thibault can login

### Iptables

- Reset iptables rules.
- Configure iptables to allow established, local and ssh connections but drop everything else.
- Save iptables rules.
```
source pifiles/iptables.sh
```

### Fail2ban

- Install / update fail2ban.
- Create a soft link for local jail configuration.
- Enable and restart the fail2ban service.
```
source pifiles/fail2ban/setup.sh
```

Fail2ban will scans the ssh log file and a client will be banned permanently if the following criteria are met:
- 3 unsuccessfully attempts to log in
- within a 10 minute window

### Watchdog

- Install / update watchdog.
- Create a soft link for the watchdog config file.
- Enable and restart the watchdog service.
```
source pifiles/watchdog/setup.sh
```

The watchdog daemon tells the kernel the system is working fine: it will periodically perform some checks and write to /dev/watchdog if they are successful. If it stops writing, the kernel will initiate a soft reboot.
The watchdog config file enable these checks:
- load 1 < 24
- memory > 1 page
- temperature < 80C

### Testing / Troubleshooting

- Fail2ban
```
# use the fail2ban client to manually ban an ip
$ sudo fail2ban-client -vvv set sshd banip 192.0.2.0

# check that iptables rules have been updated:
$ sudo iptables -S

# unban the test ip:
$ sudo fail2ban-client -vvv set sshd unbanip 192.0.2.0
```

- Watchdog
```
# choose between a fork bomb:
$ : (){ :|:& };:

# or a system crash by a NULL pointer dereference:
$ echo c > /proc/sysrq-trigger
```

## Ressources

- [Raspberry Pi Raspbian Documentation](https://www.raspberrypi.org/documentation/raspbian/)
- [Securing your Raspberry Pi](https://www.raspberrypi.org/documentation/configuration/security.md)
- [17 security tips for your Raspberry Pi](https://raspberrytips.com/security-tips-raspberry-pi)
- [Protect SSH with Fail2Ban](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-14-04#conclusion)
- [How Fail2Ban Works](https://www.digitalocean.com/community/tutorials/how-fail2ban-works-to-protect-services-on-a-linux-server)
- [WatchDog for Raspberry Pi](https://blog.kmp.or.at/watchdog-for-raspberry-pi/)

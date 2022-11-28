# pi-files

Configuration files and step by step guide to setup a Raspbian Buster Lite (headless) server and optionally turn it into a [DNS sinkhole](https://en.wikipedia.org/wiki/DNS_sinkhole) (pi-hole) and a recursive DNS server (unbound).

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
sudo passwd root
```

- Create a new user and add it to the sudo group:

```
sudo adduser tlaurens
sudo adduser tlaurens sudo
```

- Disable Wifi/Wlan and Bluetooth permanently:

```
echo "dtoverlay=disable-wifi" | sudo tee -a /boot/config.txt
echo "dtoverlay=disable-bt" | sudo tee -a /boot/config.txt
```

- Disable unwanted services:

```
# list enabled services
systemctl list-unit-files | grep enabled

sudo systemctl disable bluetooth triggerhappy
sudo systemctl stop bluetooth triggerhappy
```

- Change basic pi config and reboot when prompted:

```
sudo raspi-config

# Localisation Options > Change Timezone
# Neywork Options > Hostname
```

- SSH with the newly created user and delete the pi user:

```
ssh tlaurens@192.168.xxx.xxx

sudo deluser -remove-home pi
sudo rm /etc/sudoers.d/010_pi-nopasswd
```

## Server setup

### Client side

- Generate and install SSH keys:

```
# generate ssh key pair, use Ed25519 algorithm
ssh-keygen -t ed25519 -o -a 100

# add private key to the authentication agent
ssh-add ~/.ssh/pi_ed25519

# install the public key to the pi
ssh-copy-id -i ~/.ssh/tlaurens_pi_ed25519.pub tlaurens@192.168.xxx.xxx
```

- Update local `~/.ssh/config` to enable `ssh pi`:

```
Host pi
    Hostname pi.local
    User tlaurens
    IdentityFile ~/.ssh/pi_ed25519
```

- Copy this repo into the home folder of the pi user:

```
git clone https://github.com/ThibaultLaurens/pifiles.git
scp -r pi-files tlaurens@pi:~
```

- The following steps can be run independently or with a single command:

```
source setup.sh
```

### APT

- Update, upgrade and install packages:

```
source apt.sh
```

### Bash

- Install / update bash and bash-completion.
- Create a soft link for custom bash aliases.
- Reload `~/.bashrc`.

```
source bash/setup.sh
```

### SSH

- Update openssh-server.
- Create a soft link for the `sshd_config` file.
- Enable and restart the ssh service.

```
source ssh/setup.sh
```

The `sshd_config` file harden the ssh server config. The notable changes are:

- Root login is disable
- Only public key auth is enable
- Only user tlaurens can login

### Iptables

- Reset iptables rules.
- Configure iptables to allow established, local and ssh connections but drop everything else.
- Save iptables rules.

```
source iptables.sh
```

### Unattended upgrades

- Install unattended-upgrades.
- Configure daily upgrades origins.
- Enable and reload unattended-upgrades service.

```
source upgrades/setup.sh
```

### Fail2ban

- Install / update fail2ban.
- Create a soft link for local jail configuration.
- Enable and restart the fail2ban service.

```
source fail2ban/setup.sh
```

Fail2ban will scans the ssh log file and a client will be banned permanently if the following criteria are met:

- 3 unsuccessfully attempts to log in
- within a 10 minute window

### Watchdog

- Install / update watchdog.
- Create a soft link for the watchdog config file.
- Enable and restart the watchdog service.

```
source watchdog/setup.sh
```

The watchdog daemon tells the kernel the system is working fine: it will periodically perform some checks and write to /dev/watchdog if they are successful. If it stops writing, the kernel will initiate a soft reboot.
The watchdog config file enable these checks:

- load 1 < 24
- memory > 1 page
- temperature < 80C

### Testing / Troubleshooting

- Unattended-upgrades

```
# dry run
sudo unattended-upgrade -d -v --dry-run
```

- Fail2ban

```
# use the fail2ban client to manually ban an ip
sudo fail2ban-client -vvv set sshd banip 192.0.2.0

# check that iptables rules have been updated:
sudo iptables -S

# unban the test ip:
sudo fail2ban-client -vvv set sshd unbanip 192.0.2.0
```

- Watchdog

```
# choose between a fork bomb:
: (){ :|:& };:

# or a system crash by a NULL pointer dereference:
echo c > /proc/sysrq-trigger
```

## Pi-hole

[Pi-hole](https://pi-hole.net/) is "a DNS sinkhole that protects your devices from unwanted content, without installing any client-side software".

- Setup firewall rules.
- Download pi-hole install script.
- Run the installer.

```
source pihole/setup.sh
```

Post install:

- Change the web interface’s password `pihole -a -p`
- Check the install logs at `/etc/pihole/install.log`
- Check the [post-install](https://docs.pi-hole.net/main/post-install/) page for DHCP instructions.

## Unbound

[Unbound](https://github.com/NLnetLabs/unbound) is "a validating, recursive, and caching open source DNS resolver".

- Install unbound.
- Download the root hint files.
- Configure Unbound.

```
source unbound/setup.sh
```

Testing:

```
# ask for the DNSSEC signature as well
dig tlaurens.xyz @127.0.0.1 -p 5335 +dnssec
```

Finally, configure Pi-hole to use the recursive DNS server by specifying `127.0.0.1#5335` as the Custom DNS (IPv4).

Note: it is recommended to update the root hint files roughly every six months since it changes infrequently.

## Ressources

- [Raspberry Pi Raspbian Documentation](https://www.raspberrypi.org/documentation/raspbian/)
- [Securing your Raspberry Pi](https://www.raspberrypi.org/documentation/configuration/security.md)
- [17 security tips for your Raspberry Pi](https://raspberrytips.com/security-tips-raspberry-pi)
- [Protect SSH with Fail2Ban](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-14-04#conclusion)
- [How Fail2Ban Works](https://www.digitalocean.com/community/tutorials/how-fail2ban-works-to-protect-services-on-a-linux-server)
- [WatchDog for Raspberry Pi](https://blog.kmp.or.at/watchdog-for-raspberry-pi/)
- [Pi-hole as All-Around DNS Solution](https://docs.pi-hole.net/guides/unbound/)

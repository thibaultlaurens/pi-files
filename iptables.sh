#!/usr/bin/env bash

echo "configuring iptables firewall.."

# Delete all existing rules.
sudo iptables -F

# Allow established traffic.
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow loopback traffic from localhost.
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT ! -i lo -s 127.0.0.0/8 -j REJECT

# Allow SSH traffic from local network.
sudo iptables -A INPUT -s 192.168.0.0/16 -p tcp --dport 22 -j ACCEPT

# Drop all other incoming traffic.
sudo iptables -A INPUT -j DROP

# Save the rules so they survive a reboot.
sudo dpkg-reconfigure iptables-persistent

echo "done"

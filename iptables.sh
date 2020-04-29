#!/bin/bash

echo "configuring iptables firewall.."

# Delete all existing rules.
sudo iptables -F

# Allow established, loopback, and ssh traffic.
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Drop all other incoming traffic.
sudo iptables -A INPUT -j DROP

# Save the rules so they survive a reboot.
sudo dpkg-reconfigure iptables-persistent

echo "done"

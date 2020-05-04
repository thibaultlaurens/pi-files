#!/usr/bin/env bash

echo "configuring iptables firewall.."

# Allow HTTP traffic.
sudo iptables -I INPUT 1 -s 192.168.0.0/16 -p tcp -m tcp --dport 80 -j ACCEPT

# Allow DNS traffic.
sudo iptables -I INPUT 1 -s 192.168.0.0/16 -p tcp -m tcp --dport 53 -j ACCEPT
sudo iptables -I INPUT 1 -s 192.168.0.0/16 -p udp -m udp --dport 53 -j ACCEPT

# Allow DHCP traffic.
sudo iptables -I INPUT 1 -p udp --dport 67:68 --sport 67:68 -j ACCEPT

# Put the "allow established traffic" at the top.
sudo iptables -I INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Save the rules so they survive a reboot.
sudo dpkg-reconfigure iptables-persistent

echo "done"

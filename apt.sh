#!/usr/bin/env bash

packages=(
    apt-transport-https
    bash
    bash-completion
    ca-certificates
    coreutils
    curl
    fail2ban
    htop
    iptables
    iptables-persistent
    ispell
    lnav
    neofetch
    net-tools
    nmap
    openssl
    openssh-server
    procps
    unattended-upgrades
    vim
    watchdog
    wget
)

echo "installing packages.."
sudo apt update && sudo apt -y full-upgrade
sudo apt install "${packages[@]}"

echo "cleaning up packages.."
sudo apt autoremove

echo "done"

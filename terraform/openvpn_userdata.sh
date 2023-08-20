#!/bin/bash
set -e

sudo apt update -y
sudo apt install -y openvpn easy-rsa

sudo timedatectl set-timezone Asia/Seoul

sudo cp -r /usr/share/easy-rsa/ ~/
sudo chown ssm-user ~/easy-rsa

sudo systemctl stop ufw
sudo systemctl disable ufw

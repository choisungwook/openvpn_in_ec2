#!/bin/bash
set -e

sudo timedatectl set-timezone Asia/Seoul

sudo apt update -y
sudo apt install -y nginx

sudo systemctl enable nginx
sudo systemctl start nginx

sudo systemctl stop ufw
sudo systemctl disable ufw

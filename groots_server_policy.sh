#!/bin/bash

# Set hostname
sudo hostnamectl set-hostname newhostname

# Update system time and date
sudo timedatectl set-ntp true

# Update package repositories
sudo apt-get update

# Install AWS CLI
sudo apt-get install -y awscli

# Configure AWS CLI
aws configure

# Install Apache2, PHP 8.2, and MySQL server
sudo apt-get install -y apache2 php8.2 mysql-server

# Perform secure installation of MySQL
sudo mysql_secure_installation

# Install phpMyAdmin
sudo apt-get install -y phpmyadmin

# Install Webmin
sudo apt-get install -y webmin

# Install Certbot
sudo apt-get install -y certbot

# Set up log rotation
sudo nano /etc/logrotate.conf

# Mount swap volume for EBS volume
sudo mkdir /mnt/swap
sudo chmod 600 /mnt/swap
sudo mount /dev/xvdf /mnt/swap
sudo swapon /mnt/swap

# Create log file of script activity
exec &> >(tee -a script.log)

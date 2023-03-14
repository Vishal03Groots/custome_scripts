#!/bin/bash

# Define log file path
LOG_FILE="/var/log/lamp-install.log"

# Function to log messages to file
log() {
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] $1" >> $LOG_FILE
}

# Update packages
log "Updating packages..."
sudo apt-get update >> $LOG_FILE 2>&1 || { log "Failed to update packages"; exit 1; }

# Install Apache2
log "Installing Apache2..."
sudo apt-get install apache2 -y >> $LOG_FILE 2>&1 || { log "Failed to install Apache2"; exit 1; }

# Install PHP 7.4 and required extensions
log "Installing PHP 7.4 and extensions..."
sudo apt-get install php8.1 php8.1-mysql php8.1-curl php8.1-gd php8.1-intl php8.1-mbstring php8.1-soap php8.1-xml php8.1-zip -y >> $LOG_FILE 2>&1 || { log "Failed to install PHP 7.4 and extensions"; exit 1; }

# Install MySQL 8.0
log "Installing MySQL 8.0..."
sudo apt-get install mysql-server -y >> $LOG_FILE 2>&1 || { log "Failed to install MySQL 8.0"; exit 1; }

# Secure MySQL installation
log "Securing MySQL installation..."
sudo mysql_secure_installation >> $LOG_FILE 2>&1 || { log "Failed to secure MySQL installation"; exit 1; }

# Restart Apache2
log "Restarting Apache2..."
sudo systemctl restart apache2 >> $LOG_FILE 2>&1 || { log "Failed to restart Apache2"; exit 1; }

# Log success message
log "LAMP installation complete!"

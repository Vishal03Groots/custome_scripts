#!/bin/bash

# Define variables
phpmyadmin_version="5.1.1"
phpmyadmin_url="https://files.phpmyadmin.net/phpMyAdmin/${phpmyadmin_version}/phpMyAdmin-${phpmyadmin_version}-all-languages.tar.gz"
install_directory="/var/www/html/phpmyadmin"
apache_config_file="/etc/apache2/sites-available/phpmyadmin.conf"

# Update system packages
sudo apt update
sudo apt upgrade -y

# Install required dependencies
sudo apt install -y apache2 php libapache2-mod-php php-mysql php-mbstring

# Download and extract phpMyAdmin
sudo mkdir -p ${install_directory}
cd /tmp
sudo wget ${phpmyadmin_url}
sudo tar -xf phpMyAdmin-${phpmyadmin_version}-all-languages.tar.gz
sudo mv phpMyAdmin-${phpmyadmin_version}-all-languages/* ${install_directory}
sudo rm -rf phpMyAdmin-${phpmyadmin_version}-all-languages.tar.gz

# Configure phpMyAdmin
sudo cp ${install_directory}/config.sample.inc.php ${install_directory}/config.inc.php
sudo sed -i "s/\$cfg\['blowfish_secret'\] = '';/\$cfg\['blowfish_secret'\] = 'your_secret_key_here';/" ${install_directory}/config.inc.php
sudo sed -i "s/localhost/127.0.0.1/" ${install_directory}/config.inc.php

# Set appropriate permissions
sudo chown -R www-data:www-data ${install_directory}
sudo chmod -R 755 ${install_directory}

# Create a new Apache configuration file for phpMyAdmin
sudo echo "Alias /phpmyadmin ${install_directory}/" | sudo tee ${apache_config_file}
sudo echo "<Directory ${install_directory}/>" | sudo tee -a ${apache_config_file}
sudo echo "    Options Indexes FollowSymLinks" | sudo tee -a ${apache_config_file}
sudo echo "    AllowOverride All" | sudo tee -a ${apache_config_file}
sudo echo "    Require all granted" | sudo tee -a ${apache_config_file}
sudo echo "</Directory>" | sudo tee -a ${apache_config_file}

# Enable the new Apache configuration
sudo a2enconf phpmyadmin.conf

# Restart Apache service
sudo systemctl restart apache2

echo "phpMyAdmin installation and configuration completed!"

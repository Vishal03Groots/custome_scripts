#!/bin/bash

# Create a new database for WordPress
sudo mysql -u root -pGr675674HJE@ -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"

# Create a new user for the WordPress database
sudo mysql -u root -pGr675674HJE@ -e "CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'vishal@1234';"

# Grant privileges to the new user
sudo mysql -u root -pGr675674HJE@ -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';"

# Flush privileges
sudo mysql -u root -pGr675674HJE@ -e "FLUSH PRIVILEGES;"

# Download and extract the latest version of WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz

# Move the extracted files to the Apache document root
sudo mv wordpress /var/www/html/

# Change ownership of the WordPress files to the Apache user
sudo chown -R www-data:www-data /var/www/html/wordpress

# Create a configuration file for WordPress
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

# Update the configuration file with the database information
sudo sed -i "s/database_name_here/wordpress/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/wpuser/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/vishal@1234/g" /var/www/html/wordpress/wp-config.php

# Create .htaccess
sudo touch /var/www/html/wordpress/.htaccess
sudo chown www-data:www-data /var/www/html/wordpress/.htaccess
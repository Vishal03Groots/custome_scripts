#!/bin/bash

echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list

cd ~

# Download WEbmin key
wget http://www.webmin.com/jcameron-key.asc

# Add that key in system place
apt-key add jcameron-key.asc

apt update

cat jcameron-key.asc | gpg --dearmor >/etc/apt/trusted.gpg.d/jcameron-key.gpg

apt install webmin

#systemctl status webmin.service

cp /etc/webmin/miniserv.conf /etc/webmin/miniserv.conf_$(date +'%d-%m-%Y')
sed -i 's/port=10000/port=8080/g' /etc/webmin/miniserv.conf
sed -i 's/listen=10000/listen=8080/g' /etc/webmin/miniserv.conf
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf

cp /etc/webmin/config /etc/webmin/config_$(date +'%d-%m-%Y')

echo "referers=webmin1.groots.in" >> /etc/webmin/config

cp /etc/webmin/miniserv.pem /etc/webmin/miniserv.pem_$(date +'%d-%m-%Y')

useradd webminmaster
passwd webminmaster                     # Use Random >  Wq8@2[o320lmKW

echo "Enter password for user webminmaster:"
read -s Wq8@2[o320lmKW
echo
echo $password | passwd --stdin webminmaster

cp /etc/webmin/webmin.acl /etc/webmin/webmin.acl_$(date +'%d-%m-%Y')
sed -i 's/root/webminmaster/g' /etc/webmin/webmin.acl

cp /etc/webmin/miniserv.users /etc/webmin/miniserv.users_$(date +'%d-%m-%Y')
sed -i 's/root/webminmaster/g' /etc/webmin/miniserv.users

systemctl restart webmin.service
systemctl status webmin.service

netstat -tulpn |  grep 8080
telnet 127.0.0.1 8080

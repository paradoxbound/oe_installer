#!/bin/bash

# Terminate if any command fails
set -e
# Verify we are running as root
FILE="/tmp/out.$$"
GREP="/bin/grep"
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


# SET UP SWAP SPACE
if [ ! -e "/swapfile" ] ; then
fallocate -l 1024M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo /swapfile   none    swap    sw    0   0 >>/etc/fstab
else
	echo "Swapfile already created"
fi

swpnssvalue=10
swapiness=$(cat /proc/sys/vm/swappiness)
if [ $swapiness !== $swpnssvalue ] ; then
	echo "Setting swapiness to 10"
sysctl vm.swappiness=10
echo 'vm.swappiness = 10' >> /etc/sysctl.conf
else
	echo -e "Swapiness already set to 10"
fi


echo Performing package updates
apt-get -y update


echo Installing required system packages
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
apt-get install -y git-core libapache2-mod-php5 php5-cli php5-mysql php5-ldap php5-curl php5-xsl libjpeg62 mysql-server mysql-client debconf-utils unzip xfonts-75dpi default-jre npm xfonts-base

# wkhtmltox is now bundled in the repository. Original download location is:
# wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
cd /vagrant/install
dpkg -i --force-depends wkhtmltox-0.12.2.1_linux-trusty-amd64.deb

npm install -g grunt-cli


a2enmod rewrite
cp /vagrant/install/bashrc $HOME/.bashrc
hostname OpenEyesVM
source /vagrant/install/bashrc


echo --------------------------------------------------
echo SYSTEM SOFTWARE INSTALLED
echo Please check previous messages for any errors
echo --------------------------------------------------

#!/bin/bash

function randomstring {
    if [ ! -n "$1" ];
        then LEN=20
        else LEN="$1"
    fi

    echo $(</dev/urandom tr -dc 'A-Za-z0-9!@#$%^&*()_+{}|:<>?=' | head -c $LEN)
}

################################################################################

read -s -p "MySQL root password:" mysqlpasswd
if [ "$mysqlpasswd" = "" ]; then
    mysqlpasswd="masterkey"
fi

# a new line after reading password
echo ""

read -p "Wordpress database name (wordpress):" wpdb
if [ "$wpdb" = "" ]; then
    wpdb="wordpress"
fi

read -p "Wordpress user (wordpress):" wpuser
if [ "$wpuser" = "" ]; then
    wpuser="wordpress"
fi

read -s -p "Wordpress user password (masterkey):" wppasswd
if [ "$wppasswd" = "" ]; then
    echo "empty"
    wppasswd="masterkey"
fi

################################################################################

mkdir /var/www
# download, extract, chown, and get our config file started
cd /var/www
wget http://wordpress.org/latest.tar.gz
tar xfz latest.tar.gz
rm latest.tar.gz

chown -R www-data: wordpress/

cd wordpress
cp wp-config-sample.php wp-config.php
chown www-data wp-config.php
chmod 640 wp-config.php

# database configuration
echo "CREATE DATABASE $wpdb CHARACTER SET utf8 COLLATE utf8_general_ci;" | mysql -u root -p$mysqlpasswd
echo "GRANT ALL PRIVILEGES ON $wpdb.* TO '$wpuser'@'localhost' IDENTIFIED BY '$wppasswd';" | mysql -u root -p$mysqlpasswd
echo "FLUSH PRIVILEGES;" | mysql -u root -p$mysqlpasswd

# configuration file updates
for i in {1..8}
    do sed -i "0,/put your unique phrase here/s/put your unique phrase here/$(randomstring 50)/" wp-config.php
done

sed -i 's/database_name_here/wordpress/' wp-config.php
sed -i 's/username_here/wordpress/' wp-config.php
sed -i "s/password_here/$wppasswd/" wp-config.php

echo "User: $wpuser" >> ~/wordpress.txt
echo "Password: $wppasswd" >> ~/wordpress.txt

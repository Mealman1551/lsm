#!/bin/bash

set -e

function install_apache() {
  apt update
  apt install -y apache2
  systemctl enable apache2
  systemctl start apache2
}

function install_php() {
  apt install -y php libapache2-mod-php
  systemctl restart apache2
}

function create_default_page() {
  echo "<!DOCTYPE html>
<html><head><title>Web Server</title></head>
<body><h1>Apache is running</h1><h2>Powered by Mealman1551's LSM (Local Server Manager)</h2></body></html>" > /var/www/html/index.html
  chown www-data:www-data /var/www/html/index.html
}

function create_virtualhost() {
  read -p "Enter site name (e.g. mysite): " name
  site_root="/var/www/$name"
  conf_file="/etc/apache2/sites-available/$name.conf"

  mkdir -p "$site_root"

  read -p "Enable directory indexing? (y/n): " indexing
  if [ "$indexing" = "y" ]; then
    options="Indexes FollowSymLinks"
  else
    options="FollowSymLinks"
  fi

  read -p "Enable PHP? (y/n): " php_enable
  if [ "$php_enable" = "y" ]; then
    install_php
    echo "<?php phpinfo(); ?>" > "$site_root/index.php"
  else
    echo "<!DOCTYPE html>
<html><head><title>Web Server</title></head>
<body><h1>Apache is running</h1><h2>Powered by Mealman1551's LSM (Local Server Manager)</h2></body></html>" > "$site_root/index.html"
  fi

  chown -R www-data:www-data "$site_root"

  echo "Created by Mealman1551's LSM
Site: $name
Created: $(date)
Root: $site_root
PHP: $php_enable
Indexing: $indexing" > "$site_root/lsm-info.txt"

  echo "<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName $name
    DocumentRoot $site_root

    <Directory $site_root>
        Options $options
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/$name-error.log
    CustomLog \${APACHE_LOG_DIR}/$name-access.log combined
</VirtualHost>" > "$conf_file"

  a2ensite "$name.conf"
  systemctl reload apache2

  echo "Site '$name' created at $site_root"
}

function deploy_to_site() {
  read -p "Enter site name: " name
  target="/var/www/$name"
  if [ ! -d "$target" ]; then
    echo "Site directory not found."
    return
  fi

  read -p "Enter path to file or folder to deploy: " source
  if [ ! -e "$source" ]; then
    echo "Source not found."
    return
  fi

  cp -r "$source" "$target/"
  chown -R www-data:www-data "$target"
  echo "Deployed to $target"
}

function fix_permissions() {
  read -p "Enter site name: " name
  target="/var/www/$name"
  if [ ! -d "$target" ]; then
    echo "Site not found."
    return
  fi
  chown -R www-data:www-data "$target"
  find "$target" -type d -exec chmod 755 {} \;
  find "$target" -type f -exec chmod 644 {} \;
  echo "Permissions fixed for $target"
}

function list_sites() {
  echo "Active LSM Sites:"
  for conf in /etc/apache2/sites-enabled/*.conf; do
    sitename=$(basename "$conf" .conf)
    root="/var/www/$sitename"
    if [ -f "$root/lsm-info.txt" ]; then
      echo "- $sitename (root: $root)"
    fi
  done
}

function main_menu() {
  clear
  echo "=== Mealman1551's LSM ==="
  echo "1) Install Apache (and default page)"
  echo "2) Create a new virtual host"
  echo "3) Deploy file or directory to site"
  echo "4) Fix file permissions for site"
  echo "5) List active LSM sites"
  echo "q) Quit"
  read -p "Choice: " choice

  case $choice in
    1)
      install_apache
      create_default_page
      ;;
    2)
      create_virtualhost
      ;;
    3)
      deploy_to_site
      ;;
    4)
      fix_permissions
      ;;
    5)
      list_sites
      ;;
    q)
      exit 0
      ;;
    *)
      echo "Invalid choice."
      ;;
  esac
  read -p "Press Enter to continue..." temp
}

while true; do
  main_menu
done


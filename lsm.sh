#!/bin/bash

clear

install_apache() {
    echo "Installing Apache..."
    sudo apt update
    sudo apt install -y apache2
    sudo systemctl enable apache2
    sudo systemctl start apache2
    echo "Apache installed and running."
    echo "<!DOCTYPE html><html><head><title>Web Server</title></head><body><h1>Apache is running</h1><h2>Powered by Mealman1551's LSM (Local Server Manager)</h2></body></html>" | sudo tee /var/www/html/index.html > /dev/null
    echo "Default web page created."
    read -p "Press any key to return to the main menu..."
}

create_virtual_host() {
    echo "Enter site name (e.g. mysite):"
    read site_name
    echo "Enable directory indexing? (y/n):"
    read enable_indexing
    echo "Enable PHP? (y/n):"
    read enable_php

    site_dir="/var/www/$site_name"
    sudo mkdir -p $site_dir
    sudo chown -R $USER:$USER $site_dir

    if [ "$enable_php" == "y" ]; then
        sudo apt install -y php libapache2-mod-php
        php_status="yes"
    else
        php_status="no"
    fi

    if [ "$enable_indexing" == "y" ]; then
        index_status="yes"
    else
        index_status="no"
    fi

    echo "<!DOCTYPE html><html><head><title>$site_name</title></head><body><h1>Welcome to $site_name</h1><h2>Powered by Mealman1551's LSM</h2></body></html>" | sudo tee $site_dir/index.html > /dev/null

    echo "Site $site_name created at $site_dir"
    echo "PHP: $php_status, Indexing: $index_status" | sudo tee $site_dir/lsm-info.txt > /dev/null

    sudo bash -c "echo '<VirtualHost *:80>
    DocumentRoot $site_dir
    ServerName $site_name.local
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' > /etc/apache2/sites-available/$site_name.conf"

    sudo a2ensite $site_name.conf
    sudo systemctl reload apache2

    echo "Virtual host for $site_name created and enabled."
    read -p "Press any key to return to the main menu..."
}

deploy_file_or_directory() {
    echo "Enter site name:"
    read site_name
    echo "Enter path to file or folder to deploy:"
    read deploy_path

    if [ ! -d "/var/www/$site_name" ]; then
        echo "Site does not exist."
        return
    fi

    sudo cp -r $deploy_path /var/www/$site_name/
    sudo chown -R $USER:$USER /var/www/$site_name/
    echo "Deployed files to /var/www/$site_name"
    read -p "Press any key to return to the main menu..."
}

fix_permissions() {
    echo "Enter site name:"
    read site_name

    if [ ! -d "/var/www/$site_name" ]; then
        echo "Site does not exist."
        return
    fi

    sudo chown -R $USER:$USER /var/www/$site_name/
    sudo chmod -R 755 /var/www/$site_name/
    echo "Permissions fixed for $site_name"
    read -p "Press any key to return to the main menu..."
}

list_active_sites() {
    echo "Active LSM sites:"
    for site in /var/www/*; do
        if [ -d "$site" ]; then
            echo "$(basename $site)"
        fi
    done
    read -p "Press any key to return to the main menu..."
}

while true; do
    echo "=== Mealman1551's LSM ==="
    echo "1) Install Apache (and default page)"
    echo "2) Create a new virtual host"
    echo "3) Deploy file or directory to site"
    echo "4) Fix file permissions for site"
    echo "5) List active LSM sites"
    echo "q) Quit"
    read -p "Select an option: " option

    case $option in
        1)
            install_apache
            ;;
        2)
            create_virtual_host
            ;;
        3)
            deploy_file_or_directory
            ;;
        4)
            fix_permissions
            ;;
        5)
            list_active_sites
            ;;
        q)
            echo "Goodbye!"
            break
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done


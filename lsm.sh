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
    sudo mkdir -p "$site_dir"
    sudo chown -R "$USER:$USER" "$site_dir"

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

    echo "<!DOCTYPE html><html><head><title>$site_name</title></head><body><h1>Welcome to $site_name</h1><h2>Powered by Mealman1551's LSM</h2></body></html>" | sudo tee "$site_dir/index.html" > /dev/null

    echo "Site $site_name created at $site_dir"
    echo "PHP: $php_status, Indexing: $index_status" | sudo tee "$site_dir/lsm-info.txt" > /dev/null

    sudo bash -c "echo '<VirtualHost *:80>
    DocumentRoot $site_dir
    ServerName $site_name.local
    ErrorLog \\${APACHE_LOG_DIR}/error.log
    CustomLog \\${APACHE_LOG_DIR}/access.log combined
</VirtualHost>' > /etc/apache2/sites-available/$site_name.conf"

    sudo a2ensite "$site_name.conf"
    sudo systemctl reload apache2

    echo "Virtual host for $site_name created and enabled."
    read -p "Press any key to return to the main menu..."
}

deploy_file_or_directory() {
    echo "Enter site name:"
    read site_name
    echo "Enter path to file or folder to deploy:"
    read -e deploy_path

    # Strip single or double quotes if present
    deploy_path=$(eval echo $deploy_path)

    if [ ! -d "/var/www/$site_name" ]; then
        echo "Site does not exist."
        read -p "Press any key to return to the main menu..."
        return
    fi

    if [ -d "$deploy_path" ]; then
        echo "Copying contents of directory..."
        sudo cp -a "$deploy_path"/. "/var/www/$site_name/"
    elif [ -f "$deploy_path" ]; then
        echo "Copying single file..."
        sudo cp "$deploy_path" "/var/www/$site_name/"
    else
        echo "File or folder does not exist: $deploy_path"
        read -p "Press any key to return to the main menu..."
        return
    fi

    sudo chown -R "$USER:$USER" "/var/www/$site_name/"
    echo "Deployed to /var/www/$site_name"
    read -p "Press any key to return to the main menu..."
}

fix_permissions() {
    echo "Enter site name:"
    read site_name

    if [ ! -d "/var/www/$site_name" ]; then
        echo "Site does not exist."
        return
    fi

    sudo chown -R "$USER:$USER" "/var/www/$site_name/"
    sudo chmod -R 755 "/var/www/$site_name/"
    echo "Permissions fixed for $site_name"
    read -p "Press any key to return to the main menu..."
}

list_active_sites() {
    echo "Active LSM sites:"
    for site in /var/www/*; do
        if [ -d "$site" ]; then
            echo "$(basename "$site")"
        fi
    done
    read -p "Press any key to return to the main menu..."
}

delete_site() {
    echo "Enter the name of the site to delete:"
    read site_name

    if [ ! -d "/var/www/$site_name" ]; then
        echo "Site does not exist."
        return
    fi

    sudo rm -rf "/var/www/$site_name"
    sudo a2dissite "$site_name.conf"
    sudo rm "/etc/apache2/sites-available/$site_name.conf"
    sudo sed -i "/$site_name.local/d" /etc/hosts
    sudo systemctl reload apache2

    echo "Site $site_name deleted."
    read -p "Press any key to return to the main menu..."
}

set_default_site() {
    echo "Available sites:"
    for site in /var/www/*; do
        if [ -d "$site" ]; then
            echo "- $(basename "$site")"
        fi
    done
    echo "Enter the site you want to set as default for localhost:"
    read default_site

    if [ ! -d "/var/www/$default_site" ]; then
        echo "Site does not exist."
        return
    fi

    sudo bash -c "echo '<VirtualHost *:80>
    DocumentRoot /var/www/$default_site
    ServerName localhost
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf"
    sudo systemctl reload apache2
    echo "localhost now points to $default_site"
    read -p "Press any key to return to the main menu..."
}

while true; do
    echo "=== Mealman1551's LSM ==="
    echo "1) Install Apache (and default page)"
    echo "2) Create a new virtual host"
    echo "3) Deploy file or directory to site"
    echo "4) Fix file permissions for site"
    echo "5) List active LSM sites"
    echo "6) Delete a site"
    echo "7) Set which site is shown on http://localhost"
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
        6)
            delete_site
            ;;
        7)
            set_default_site
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

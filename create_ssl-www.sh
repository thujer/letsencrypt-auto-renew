#!/bin/bash

declare -a arr=(
    "domena1.cz"
    "domena2.cz""
    #"domena3.cz""
)

email=user@email.xx

apache_available="/etc/apache2/sites-available"
apache_enabled="/etc/apache2/sites-enabled"

backup_sites_available="./backup/sites-available"
backup_sites_enabled="./backup/sites-enabled"

mkdir -p $backup_sites_available
mkdir -p $backup_sites_enabled

for domain in "${arr[@]}"
do
    subdomain=${domain:0:4};

    if [ $subdomain == "www." ]; then

        echo "Domain has www subdomain - converting to domain without www..."

        newdomain=${domain:4:100}

        echo "New domain: $newdomain"

        if [ ! -f $apache_available/$newdomain ]; then
            echo "Creating copy of apache config file without www..."
            cp $apache_available/$domain $apache_available/$newdomain
        fi

        if [ ! -f $apache_enabled/$newdomain.conf ]; then
            echo "Creating apache2 enabled symbolic link"
            ln -sf $apache_available/$newdomain $apache_enabled/$newdomain
        fi

        echo "Checking for symbolic link $apache_enabled/$domain"
        if [ -f $apache_enabled/$domain ]; then
            echo "Moving old sites_enabled config file to backup directory"
            mv $apache_enabled/$domain $backup_sites_enabled/
        fi

        echo "Checking for config file $apache_enabled/$domain"
        if [ -f $apache_available/$domain ]; then
            echo "Moving old sites_available config file to backup directory"
            mv $apache_available/$domain $backup_sites_available/
        fi

        domain=$newdomain
    fi

    if [ ! -f $apache_enabled/$domain-le-ssl.conf ]; then
        echo "--- Processing domain $domain ..."
        /opt/letsencrypt/certbot-auto --apache --agree-tos --no-redirect -m=$email -n -d $domain
    else
        echo "Skipping domain $domain..."
        echo
    fi


done

# You can access them using echo "${arr[0]}", "${arr[1]}" also

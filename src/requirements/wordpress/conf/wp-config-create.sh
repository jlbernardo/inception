#!/bin/ash

sleep 12

wp config create --allow-root --path=/var/www/wordpress --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=mariadb --dbprefix='wp_' --dbcharset="utf8"

wp core install --allow-root --path=/var/www/wordpress --url=https://julberna.42.fr --title="I was once a slime" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PSWD --admin_email=$WP_ADMIN_MAIL

wp user create $WP_USER $WP_USER_MAIL --user_pass=$WP_USER_PSWD --allow-root

/usr/sbin/php-fpm82 -F

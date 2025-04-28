#!/bin/ash

# Generates a WordPress configuration file
wp config create --allow-root --path=/var/www/wordpress \
                --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS \
                --dbhost=mariadb --dbprefix='wp_' --dbcharset="utf8"

# Installs WordPress with the specified parameters
wp core install --allow-root --path=/var/www/wordpress --url=https://julberna.42.fr \
                --title="$WP_TITLE" --admin_user=$WP_ADMIN_USER \
                --admin_password=$WP_ADMIN_PSWD --admin_email=$WP_ADMIN_MAIL

# Creates a new WordPress user with the specified parameters
wp user create $WP_USER $WP_USER_MAIL --user_pass=$WP_USER_PSWD --allow-root

# Starts the PHP FastCGI Process Manager (php-fpm), which handles
# PHP scripts in a high-performance and scalable manner
# The flag -F indicates that php-fpm should run in the foreground
/usr/sbin/php-fpm82 -F

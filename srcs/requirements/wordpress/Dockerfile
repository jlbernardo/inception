# Penultimate version of Linux Alpine
FROM alpine:3.20.6

# Environment variables to be imported from .env and used inside the container
ARG PHP_VERSION=82 \
    DB_NAME \
    DB_USER \
    DB_PASS \
    WP_TITLE \
    WP_ADMIN_USER \
    WP_ADMIN_PSWD \
    WP_ADMIN_MAIL \
    WP_USER \
    WP_USER_MAIL \
    WP_USER_PSWD

# Installs PHP and its extensions, without saving the sources
# in cache. Most of these packages are needed for the service
# that installs and configures WordPress automatically
#
# We change php-fpm conf make it accessible from any network
# interface withing the container and uncomment the listen lines
# to ensure proper ownership of the socket and prevent priviledge
# escalation (nobody is a low-priviledge system user)
#
# We also set the memory limit to the maximum value (-1) to
# prevent any memory limit issues when installing WordPress
RUN apk update && apk upgrade && apk add --no-cache \
    mysql-client \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION} \
    php${PHP_VERSION}-phar \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-session \
    php${PHP_VERSION}-iconv \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-imap \
    php${PHP_VERSION}-cgi \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-pdo_mysql \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-posix \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-gettext \
    php${PHP_VERSION}-ldap \
    php${PHP_VERSION}-ctype \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-simplexml \
    fcgi \
    curl \
    unzip && \
    sed -i "s|listen = 127.0.0.1:9000|listen = 0.0.0.0:9000|g" \
      /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
      /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
      /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|memory_limit = 128M|memory_limit = -1|g" \
      /etc/php82/php.ini && \
    rm -f /var/cache/apk/*

# Sets the default working directory
WORKDIR /var/www/wordpress

# Links the PHP 8.2 binary to the default PHP binary
RUN ln -s /usr/bin/php82 /usr/bin/php

# We will use wp-cli to download, install and configure WordPress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Downloads and updates wp core and wp-cli
RUN wp core download --allow-root \
    && wp cli update --allow-root

# Copies the file "wp-config-create.sh" from the host to the container
COPY requirements/wordpress/tools/wp-config-create.sh /usr/bin/

# Changes the permissions of the file "wp-config-create.sh" to make it executable
RUN chmod +x /usr/bin/wp-config-create.sh

# Exposes port 9000, the standard port for PHP-FPM
EXPOSE 9000

# Sets the entrypoint to the script "wp-config-create.sh"
ENTRYPOINT [ "sh", "-f", "/usr/bin/wp-config-create.sh" ]

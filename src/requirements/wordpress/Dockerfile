FROM alpine:3.20
ARG PHP_VERSION=82 \
    DB_NAME \
    DB_USER \
    DB_PASS \
    WP_ADMIN_USER \
    WP_ADMIN_PSWD \
    WP_ADMIN_MAIL \
    WP_USER \
    WP_USER_MAIL \
    WP_USER_PSWD

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
    php${PHP_VERSION}-redis \
    fcgi \
    curl \
    unzip && \
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" \
      /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" \
      /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" \
      /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|memory_limit = 128M|memory_limit = -1|g" \
      /etc/php82/php.ini && \
    rm -f /var/cache/apk/*
WORKDIR /var/www/wordpress

RUN ln -s /usr/bin/php82 /usr/bin/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN wp core download --allow-root && wp cli update --allow-root

COPY requirements/wordpress/conf/wp-config-create.sh /usr/bin/

RUN chmod +x /usr/bin/wp-config-create.sh

EXPOSE 9000

ENTRYPOINT [ "ash", "-f", "/usr/bin/wp-config-create.sh" ]

FROM alpine:3.17

MAINTAINER Hafijul Islam <hafijul233@gmail.com>

USER root

# OS Essentials Programs
RUN echo "UTC" >> /etc/timezone
RUN apk --no-cache upgrade && apk add --no-cache git curl vim

# Installing PHP-8.1.13
RUN apk add --no-cache php \
    php-common \
    php-fpm \
    php-session \
    php-pdo \
    php-opcache \
    php-zip \
    php-phar \
    php-gd \
    php-cli \
    php-curl \
    php-mbstring \
    php-fileinfo \
    php-json \
    php-xml \
    php-dom \
    php-mysqli \
    php-pdo_mysql \
    php-bcmath \
    php-tokenizer

# Configure PHP
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/g" /etc/php81/php.ini
RUN sed -i "s/disable_functions =/disable_functions = create_function, eval, exec, shell_exec/g" /etc/php81/php.ini
RUN sed -i "s/expose_php = On/expose_php = Off/g" /etc/php81/php.ini
RUN sed -i "s/max_execution_time = 30/max_execution_time = 300/g" /etc/php81/php.ini
RUN sed -i "s/memory_limit = 128M/memory_limit = 2G/g" /etc/php81/php.ini
RUN sed -i "s/display_errors = Off/display_errors = On/g" /etc/php81/php.ini
RUN sed -i "s/display_startup_errors = Off/display_startup_errors = On/g" /etc/php81/php.ini
RUN sed -i "s/log_errors = On/log_errors = Off/g" /etc/php81/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = 1G/g" /etc/php81/php.ini
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 1G/g" /etc/php81/php.ini
RUN sed -i "s/max_file_uploads = 20/max_file_uploads = 50/g" /etc/php81/php.ini

# Installing composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Installing Web & Database Server
RUN apk add --no-cache nginx mariadb mariadb-client

# Configure NGINX
COPY .docker/web/vhost.conf /etc/nginx/http.d/default.conf

# Build Process
EXPOSE 80 443
WORKDIR "/var/www/html"
CMD ["/bin/sh", "-c", "php-fpm81 && mysqld_safe && nginx -g 'daemon off;'"]

FROM alpine:3.17

MAINTAINER Hafijul Islam <hafijul233@gmail.com>

USER root

# OS Essentials Programs
RUN echo "UTC" >> /etc/timezone
RUN apk --no-cache update &&  apk --no-cache upgrade && \
    apk add --no-cache ca-certificates curl vim git zip unzip wget icu-data-full

# Installing PHP-8.1 & Common Extensions
RUN apk add --no-cache php php-common php-fpm php-session php-opcache \
    php-zip php-cli php-curl php-mbstring php-fileinfo php-json \
    php-mysqli php-odbc php-pgsql php-sqlite3 php-mssql php-xml \
    php-dom php-xmlreader php-simplexml php-pdo php-pdo_mysql \
    php-pdo_odbc php-pdo_pgsql php-pdo_sqlite php-intl php-bcmath \
    php-exif php-gd

# Installing PHP SOAP Extension
#RUN apk add --no-cache php-soap

# Configure PHP INI files
COPY .docker/php/php.ini /etc/php81/php.ini

# Installing Composer Package Manager
RUN apk add --no-cache php-phar && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Installing Web & Database Server
RUN apk add --no-cache nginx mariadb-client

# Configure NGINX
COPY .docker/web/vhost.conf /etc/nginx/http.d/default.conf

# Build Process
EXPOSE 80 443
WORKDIR "/var/www/html"
CMD ["/bin/sh", "-c", "php-fpm81 && nginx -g 'daemon off;'"]

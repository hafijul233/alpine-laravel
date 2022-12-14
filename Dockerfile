FROM alpine:3.17

MAINTAINER Hafijul Islam <hafijul233@gmail.com>

USER root

# OS Essentials Programs
RUN echo "UTC" >> /etc/timezone
RUN apk --no-cache update &&  apk --no-cache upgrade && \
    apk add --no-cache curl vim

# Installing PHP-8.1.13
RUN apk add --no-cache php php-common php-fpm php-session php-opcache \
    php-zip php-cli php-curl php-mbstring php-fileinfo php-json

# Installing PHP Default Database Extensions
RUN apk add --no-cache php-mysqli
# php-odbc php-pgsql php-sqlite3 php-mssql

# Installing PHP XML Extensions
#RUN apk add --no-cache php-xml php-dom php-xmlreader php-simplexml

# Installing PHP PDO Extension
RUN apk add --no-cache php-pdo php-pdo_mysql
# php-pdo_odbc php-pdo_pgsql php-pdo_sqlite

# Installing PHP Intl Extension
#RUN apk add --no-cache icu-data-full php-intl php-bcmath

# Installing PHP Image Support Extension
#RUN apk add --no-cache php-exif php-gd

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

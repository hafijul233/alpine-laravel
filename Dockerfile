FROM alpine:3.17

MAINTAINER Hafijul Islam <hafijul233@gmail.com>

USER root

# OS Essentials Programs
RUN echo "UTC" >> /etc/timezone
RUN apk --no-cache update && \
    apk --no-cache upgrade && \
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

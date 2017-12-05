FROM ubuntu:16.04
RUN apt-get update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
	software-properties-common

RUN DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
	apache2 apt-utils zip curl git


RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
	php7.1 php7.1-mbstring php7.1-xml php7.1-intl php7.1-gd php7.1-mysql php7.1-pgsql php-memcached php-memcache

RUN curl -sS https://getcomposer.org/installer | php && \
	mv composer.phar /usr/local/bin/composer &&\
	composer global require "fxp/composer-asset-plugin:~1.4.2"
RUN \
 sed -i "s/AllowOverride None/AllowOverride All/" /etc/apache2/apache2.conf

ENV APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_LOG_DIR=/var/log/apache2 \
    APACHE_LOCK_DIR=/var/lock/apache2 \
    APACHE_RUN_DIR=/var/run/apache2 \
    APACHE_PID_FILE=/var/run/apache2.pid 

COPY ./conf/conf-available/* /etc/apache2/conf-available/
COPY ./conf/mods-available/* /etc/apache2/mods-available/

COPY ./scripts/boot.sh /root/scripts/boot.sh

RUN a2enmod remoteip && a2enconf remoteip && a2enmod rewrite && a2enmod php7.1
RUN chown -R www-data:www-data /var/www/html 

ADD http://download.icu-project.org/files/icu4c/60.1/icu4c-60_1-Ubuntu16.04-x64.tgz /tmp
RUN tar -xzf /tmp/icu4c-60_1-Ubuntu16.04-x64.tgz /tmp && cp -r /tmp/icu/usr / && rm -rf /tmp
WORKDIR /var/www
EXPOSE 80
CMD ["/root/scripts/boot.sh"]
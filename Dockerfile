FROM debian:buster

RUN	apt-get update -y \
	&& apt-get install nginx -y

RUN	apt-get -y install vim

RUN	apt-get -y update \
	&& apt-get -y install mariadb-server mariadb-client \
	&& /etc/init.d/mysql start

RUN 	apt-get -y install php-fpm php-mysql \
	&& sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.3/fpm/php.ini 

COPY	srcs/default /etc/nginx/sites-enabled/ 

RUN	chown -R root:root /var/www/html/

RUN	apt-get -y install wget

RUN	wget https://wordpress.org/latest.tar.gz \
	&& tar xpf latest.tar.gz \
	&& rm -rf /var/www/html	\
	&& cp -r wordpress /var/www/html \
	&& chown -R www-data:www-data /var/www/html \
	&& find /var/www/html -type d -exec chmod 755 {} \; \
	&& find /var/www/html -type f -exec chmod 644 {} \;

RUN	apt-get -y install php-mbstring \
	&& apt-get -y install php-zip \
	&& apt-get -y install php-gd \
	&& apt-get -y install php-xml \
	&& apt-get -y install php-pear \
	&& apt-get -y install php-gettext \
	&& apt-get -y install php-cgi \
	&& wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz \
	&& mkdir /var/www/html/phpmyadmin \
	&& tar xzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin

COPY	srcs/config.sample.inc.php /var/www/html/phpmyadmin

RUN	chmod 660 /var/www/html/phpmyadmin/config.sample.inc.php \
	&& chown -R www-data:www-data /var/www/html/phpmyadmin

COPY	srcs/param_user.sh /

RUN	service mysql start \
	&& sh param_user.sh

RUN	apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

CMD ["sh","-c", "service php7.3-fpm start ; nginx -s reload ; service php7.3-fpm restart ; service mysql start ; service nginx start ; tail -f /dev/null"]

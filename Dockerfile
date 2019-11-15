FROM debian:buster

RUN	apt-get update -y \
	&& apt-get install nginx -y

RUN	apt-get -y install vim

RUN	apt-get -y update \
	&& apt-get -y install mariadb-server mariadb-client \
	&& /etc/init.d/mysql start

RUN 	apt-get -y install php-fpm php-mysql \
	&& sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.3/fpm/php.ini 
#php-mbstring php-zip php-gd php-mysql

#COPY 	srcs/localhost /etc/nginx/sites-available/ 

COPY	srcs/default /etc/nginx/sites-enabled/ 

#RUN	ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/ \
#	&& chown -R root:root /var/www/html/
RUN	chown -R root:root /var/www/html/

RUN	apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

#CMD ["nginx", "-g", "daemon off;"]
CMD ["sh","-c", "service php7.3-fpm start ; nginx -s reload ; service php7.3-fpm restart ; service nginx start ; tail -f /dev/null"]
#CMD ["sh","-c", "service php7.3-fpm start ; nginx -s reload ; service php7.3-fpm restart"]

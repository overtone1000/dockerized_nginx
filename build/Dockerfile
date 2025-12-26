FROM docker.io/nginx:alpine

#
#
#Compile rust. Only for ARM64!
RUN echo "Skipping rust compilation. This will cause failure if deploying to ARM architectures!"
#RUN apt-get -y update && apt-get -y install python3-dev libffi-dev libssl-dev curl
#RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#RUN ln -s ~/.cargo/bin/* /bin/
#RUN rustc --version


#Install PHP-FPM and create the pertinent socket link; service is started in entrypoint.sh
#ENV PHP_VERSION=81 
#ENV PHP_INI_DIR=/etc/php/$PHP_VERSION/cli/conf.d
#was 7.4
#did "8.1" for a bit, was that a fluke?
#ENV PATH="/etc/nginx:${PATH}"
#ENV TZ="US/Los_Angeles"

###
### Certbot
###

#Can't use snapd to install certbot. Need to run the script in the container then save the image.
#RUN apt-get install -y snapd
#Certbot (use the pip installation instructions instead of snapd!)
RUN apk add --no-cache python3 
    #python3-venv libaugeas0
    
#
#
#Install certbot with pip
RUN python3 -m venv /opt/certbot/
RUN /opt/certbot/bin/pip install --upgrade pip
RUN /opt/certbot/bin/pip install cryptography
RUN /opt/certbot/bin/pip install certbot certbot-nginx
RUN ln -s /opt/certbot/bin/certbot /usr/bin/certbot


#For entrypoint
RUN apk add --no-cache bash
#RUN apk add --no-cache openrc 
#Just run crond in the background, but php-fpm needs to be a service I guess

#For nginx
RUN apk add --no-cache php$PHP_VERSION php$PHP_VERSION-fpm php$PHP_VERSION-sockets
    #php$PHP_VERSION-fpm

#For certbot
RUN apk add --no-cache apk-cron
RUN apk add --no-cache wget

#
#Create PHP symbolic link
# Don't do this anymore, just set fastcgi_pass to 127.0.0.1:9000
#RUN echo iterate
#RUN /usr/sbin/php-fpm81 --help
#RUN cat /etc/php81/php-fpm.conf | grep listen
#RUN ln -s /var/run/php/php$PHP_VERSION-fpm.sock /var/run/php/php-fpm.sock

#
#Create log files
RUN touch /var/log/nginx/access.log
RUN touch /var/log/nginx/error.log
RUN touch /var/log/nginx/stream.log
RUN adduser -G www-data -D www-data
RUN chown -R www-data:www-data /var/log/nginx && chmod -R 755 /var/log/nginx;

#
#
#Nginx configs
#just enable all sites in sites available
RUN ln -s /etc/nginx/sites-available /etc/nginx/sites-enabled
#test page
COPY static_content /var/www/html/static_content
#Nginx base config - currently the volume keeps /etc/nginx/sties-available perisistent, but the /etc/nginx directory depeneds on the image
COPY nginx_config /etc/nginx/
#PHP ini for increasing uploads in wordpress
#This does not affect the wordpress container php limitations! Need to modify php in the wordpress container. See README.
COPY php_ini/ $PHP_INI_DIR/


#Cron config
ENV CRONDIR=/var/spool/cron/crontabs
COPY certbot_hooks /etc/letsencrypt/renewal-hooks
RUN chmod -R 755 /etc/letsencrypt/renewal-hooks
COPY ./cron/root $CRONDIR/root
RUN chmod 0644 $CRONDIR/root

#Send logs to stdout and stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log \ 	&& ln -sf /dev/stderr /var/log/nginx/error.log

WORKDIR /
COPY entrypoint.sh entrypoint.sh

ENTRYPOINT ["/bin/bash","entrypoint.sh"]
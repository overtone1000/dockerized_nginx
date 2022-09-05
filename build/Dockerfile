FROM ubuntu:latest

#Install PHP-FPM and create the pertinent socket link; service is started in entrypoint.sh
ENV PHP_VERSION=7.4
#was 7.4
#did "8.1" for a bit, was that a fluke?
ENV PHP_INI_DIR=/etc/php/$PHP_VERSION/cli/conf.d
ENV DEBIAN_FRONTEND="noninteractive"

#
#
# Install necessary packages
RUN apt-get -y update && apt-get -y install \
    make \
    #needed for PCRE
    build-essential sudo \
    #Can't use snapd to install certbot. Need to run the script in the container then save the image.
    #RUN apt-get install -y snapd
    #Certbot (use the pip installation instructions instead of snapd!)
    python3 python3-venv libaugeas0 \
    #For certbot
    cron \
    wget \
    #PHP
    php$PHP_VERSION php$PHP_VERSION-fpm

ENV TZ="US/Los_Angeles"

#
#
#Install third party libraries (predownloaded)
ARG OPENSSL=openssl-1.1.1g
ARG ZLIB=zlib-1.2.11
ARG PCRE=pcre-8.45
ARG NGINX=nginx-1.19.0

COPY downloads/ /tmp/

#Unpack
WORKDIR /tmp/
RUN dir
RUN dir /tmp
RUN tar -zxf $OPENSSL.tar.gz
RUN tar -zxf $ZLIB.tar.gz
RUN tar -zxf $PCRE.tar.gz
RUN tar -zxf $NGINX.tar.gz

#Compile nginx
WORKDIR /tmp/$NGINX
RUN ./configure \
--sbin-path=/etc/nginx/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/etc/nginx/nginx.pid \
--with-pcre=../$PCRE \
--with-zlib=../$ZLIB \
--with-openssl=../$OPENSSL \
--with-http_ssl_module \
--with-stream \
--with-stream_ssl_preread_module \
--with-mail=dynamic
RUN make
RUN make install
ENV PATH="/etc/nginx:${PATH}"

WORKDIR /

#
#
#Compile rust. Only for ARM64!
RUN echo "Skipping rust compilation. This will cause failure if deploying to ARM architectures!"
#RUN apt-get -y update && apt-get -y install python3-dev libffi-dev libssl-dev curl
#RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#RUN ln -s ~/.cargo/bin/* /bin/
#RUN rustc --version


#
#
#Install certbot with pip
RUN python3 -m venv /opt/certbot/
RUN /opt/certbot/bin/pip install --upgrade pip
RUN /opt/certbot/bin/pip install cryptography
RUN /opt/certbot/bin/pip install certbot certbot-nginx
RUN ln -s /opt/certbot/bin/certbot /usr/bin/certbot

#
#Create PHP symbolic link
RUN ln -s /var/run/php/php$PHP_VERSION-fpm.sock /var/run/php/php-fpm.sock

#
#Create log files
RUN mkdir /var/log/nginx
RUN touch /var/log/nginx/access.log
RUN touch /var/log/nginx/error.log
RUN touch /var/log/nginx/stream.log
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
RUN chmod 0644 /etc/cron.d/*
COPY certbot_hooks /etc/letsencrypt/renewal-hooks
RUN chmod -R 755 /etc/letsencrypt/renewal-hooks

#Final cleanup
RUN rm -dr /tmp/*
RUN apt-get remove -y make build-essential
RUN apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /
COPY entrypoint.sh entrypoint.sh
ENTRYPOINT ["bash","entrypoint.sh"]
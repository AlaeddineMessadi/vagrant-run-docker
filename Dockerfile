FROM phusion/baseimage:latest
MAINTAINER Alaeddine Messadi <alaeddine.messadi@gmail.com>

# Setup environment
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# common baseimage actions
RUN echo "/root" > /etc/container_environment/HOME && \
    echo "noninteractive" > /etc/container_environment/DEBIAN_FRONTEND && \
    echo "linux" > /etc/container_environment/TERM && \
    rm -f /etc/service/sshd/down && \
    /usr/sbin/enable_insecure_key && \
    /etc/my_init.d/00_regen_ssh_host_keys.sh

# Add Vagrant key
RUN mkdir -p /root/.ssh && \
    curl -sL https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub > /root/.ssh/authorized_keys

# to use your private keys generate and copy your public key rsa into /keys
# Comment the previous line 'curl ...' , uncomment the line above and check the valide key 
# ADD keys/id_rsa.pub /root/.ssh/authorized_keys

# add NGINX and PHP7
RUN echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/nginx.list
RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/php.list

# install packages
RUN apt-get update && \
    apt-get -y --force-yes --no-install-recommends install \
    supervisor \
    nginx \
    php7.0-fpm php7.0-cli php7.0-common php7.0-curl php7.0-gd php7.0-intl php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-opcache php7.0-pgsql php7.0-soap php7.0-sqlite3 php7.0-xml php7.0-xmlrpc php7.0-xsl php7.0-zip && \
    apt-get autoclean && apt-get -y autoremove
RUN rm -rf /tmp/* /var/tmp/*

# configure NGINX and php-fpm as non-daemon
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf

# mountable directories for config , apps and logs
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]
VOLUME ["/var/www"]

# copy config file for Supervisor and NGINX
COPY config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
COPY config/nginx/default /etc/nginx/sites-available/default

# php7.0-fpm will not start if this directory does not exist
RUN mkdir /run/php

# NGINX ports
EXPOSE 80 443

#CMD ["/usr/bin/supervisord"]

# Init process is entrypoint
ENTRYPOINT ["/sbin/my_init", "--"]

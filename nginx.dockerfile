FROM nginx:latest

# List all the packages that we want to install
#ENV PACKAGES php-fpm
ENV PACKAGES php-fpm iputils-ping net-tools xtail mc nano procps 

# Install Packages
RUN apt-get update && apt-get install -y $PACKAGES

# Copy configuration and sample files
COPY info.php  /usr/share/nginx/html/
COPY ip.php  /usr/share/nginx/html/
COPY default.conf /etc/nginx/conf.d/default.conf
COPY www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Reloading the services
# service restart does not work for php7.3-fpm
RUN service php7.3-fpm stop
RUN service php7.3-fpm start
#RUN service php7.3-fpm status
#RUN service nginx reload

# Configure root password
RUN echo "root:.Geheim!" | chpasswd
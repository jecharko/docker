﻿FROM mariadb/server:latest

# List all the packages that we want to install
#ENV PACKAGES openssh-server openssh-client
ENV PACKAGES iputils-ping net-tools 

ENV MYSQL_ROOT_PASSWORD mypass
ENV MYSQL_DATABASE wordpress 

# Install Packages
RUN apt-get update && apt-get install -y $PACKAGES

# Allow SSH Root Login
#RUN sed -i 's|^#PermitRootLogin.*|PermitRootLogin yes|g' /etc/ssh/sshd_config

# Configure root password
RUN echo "root:root123" | chpasswd
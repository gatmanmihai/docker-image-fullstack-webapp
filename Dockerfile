FROM ubuntu:20.04

ENV TZ=UTC

RUN export LC_ALL=C.UTF-8
RUN DEBIAN_FRONTEND=noninteractive
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y \
    sudo \
    autoconf \
    autogen \
    language-pack-en-base \
    wget \
    zip \
    unzip \
    curl \
    rsync \
    ssh \
    mysql-client \
    openssh-client \
    git \
    build-essential \
    apt-utils \
    software-properties-common \
    nasm \
    libjpeg-dev \
    libpng-dev \
    libpng16-16

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# PHP
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y php8.3
RUN apt-get install -y \
    php8.3-curl \
    php8.3-gd \
    php8.3-dev \
    php8.3-xml \
    php8.3-bcmath \
    php8.3-mysql \
    php8.3-pgsql \
    php8.3-mbstring \
    php8.3-zip \
    php8.3-bz2 \
    php8.3-sqlite \
    php8.3-soap \
    php8.3-json \
    php8.3-intl \
    php8.3-imap \
    php8.3-imagick \
    php8.3-memcached \
    php8.3-mongodb \
    php8.3-mcrypt \
    php8.3-common
RUN command -v php

# Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install -y google-chrome-stable --no-install-recommends

# Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    composer self-update
RUN command -v composer

# Node.js
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
ENV NVM_DIR="/root/.nvm"
RUN . /root/.nvm/nvm.sh && nvm install 14
RUN . /root/.nvm/nvm.sh && nvm install 16
RUN . /root/.nvm/nvm.sh && nvm install 20
RUN . /root/.nvm/nvm.sh && nvm install 8

# Other
RUN mkdir ~/.ssh
RUN touch ~/.ssh_config

# Display versions installed
RUN php -v
RUN composer --version
RUN . /root/.nvm/nvm.sh && nvm use node && node -v
RUN . /root/.nvm/nvm.sh && nvm use node && npm -v

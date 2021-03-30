FROM ubuntu:20.04

WORKDIR /var/www/app

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
  && apt-get install -y nginx gnupg gosu curl mysql-client zip unzip supervisor libcap2-bin libpng-dev python2 \
  && mkdir -p ~/.gnupg \
  && chmod 600 ~/.gnupg \
  && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
  && apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E5267A6C \
  && apt-key adv --homedir ~/.gnupg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C300EE8C \
  && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu focal main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
  && apt-get update \
  && apt-get install -y php8.0-fpm php8.0-cli \
    php8.0-pgsql php8.0-gd \
    php8.0-curl \
    php8.0-imap php8.0-mysql php8.0-mbstring \
    php8.0-xml php8.0-zip php8.0-bcmath php8.0-soap \
    php8.0-intl php8.0-readline \
    php8.0-msgpack php8.0-igbinary php8.0-ldap \
    php8.0-redis \
  && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
  && curl -sL https://deb.nodesource.com/setup_15.x | bash - \
  && apt-get install -y nodejs \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y yarn \
  && apt-get install -y mysql-client \
  && apt-get install -y postgresql-client \
  && apt-get install -y nodejs gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget libgbm-dev \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  
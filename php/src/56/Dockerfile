FROM php:5.6-fpm

LABEL maintainer.name="Mavaddat Javid" \
      maintainer.email="support@mavaddat.ca"

ENV PATH /usr/local/go/bin:/root/.composer/vendor/bin:$PATH
RUN apt-add-repository ppa:fish-shell/release-3 && apt update && \
    apt install -y --no-install-recommends \
    cron \
    git \
    gnupg \
    iputils-ping \
    less \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng-dev \
    libwebp-dev \
    libxml2-dev \
    libxslt-dev \
    nano \
    net-tools \
    ssh \
    msmtp \
    sudo \
    supervisor \
    unzip \
    libzip-dev \
    libz-dev \
    fish \
    fonts-powerline \
    powerline \
    keychain \
    net-tools \
  && yes '' | pecl install -f memcached-2.2.0 redis-4.3.0 xdebug-2.5.5 \
  && docker-php-ext-install -j$(nproc) bcmath calendar exif intl mysqli opcache pdo_mysql soap xsl zip\
  && docker-php-ext-enable mcrypt memcached redis xdebug\
  && mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# Configure GD Library
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
  && docker-php-ext-install -j$(nproc) gd

# Install Ioncube
RUN cd /tmp \
  && curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
  && tar -xvvzf ioncube.tar.gz \
  && mv ioncube/ioncube_loader_lin_$(php -r 'echo PHP_MAJOR_VERSION . "." . PHP_MINOR_VERSION;').so /usr/local/lib/php/extensions/* \
  && rm -Rf ioncube.tar.gz ioncube \
  && echo "zend_extension=ioncube_loader_lin_$(php -r 'echo PHP_MAJOR_VERSION . "." . PHP_MINOR_VERSION;').so" > /usr/local/etc/php/conf.d/00_docker-php-ext-ioncube_loader_lin_$(php -r 'echo PHP_MAJOR_VERSION . "." . PHP_MINOR_VERSION;').ini

# Install Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && composer clear-cache

# Install MailHog
RUN curl -L -o /usr/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
  && chmod +x /usr/bin/mhsendmail

# Install Yarn
RUN curl -sS 'https://dl.yarnpkg.com/debian/pubkey.gpg' | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt update \
  && apt install -y --no-install-recommends yarn \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# Install Node
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - \
  && apt install -y --no-install-recommends nodejs \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# Install Wordpress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

# Install PHPCS
RUN composer global require squizlabs/php_codesniffer wp-coding-standards/wpcs \
  && phpcs --config-set installed_paths /root/.composer/vendor/wp-coding-standards/wpcs \
  && composer clear-cache

# Setup Crons
RUN touch /root/custom_crontab \
  && /usr/bin/crontab -u www-data /root/custom_crontab

# Update site's directory permissions
RUN chown -R www-data /var/www/

# Cleanup
RUN apt clean \
  && rm -rf /var/lib/apt/lists/*

# Custom PHP.ini Config
COPY ./conf/custom.ini /usr/local/etc/php/conf.d/zza-custom.ini

# PHP-FPM and CRON supervisord config
COPY ./conf/supervisord.conf /etc/supervisor/supervisord.conf
RUN touch /etc/supervisor/supervisord.pid

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]

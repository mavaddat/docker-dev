FROM phpdockerio/php:7.2-fpm

LABEL maintainer.name="Mavaddat Javid" \
      maintainer.email="support@mavaddat.ca"

# Setup user (to stay in-sync with the host system's user)
ARG CUSTOM_USER_NAME
ARG CUSTOM_UID
ARG CUSTOM_GID
RUN groupadd -g ${CUSTOM_GID} ${CUSTOM_USER_NAME} \
  && useradd -m -u ${CUSTOM_UID} -g ${CUSTOM_USER_NAME} -G sudo -s /usr/bin/fish ${CUSTOM_USER_NAME} \
  && passwd -d ${CUSTOM_USER_NAME} \
  && echo "${CUSTOM_USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install FISH & config
RUN wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh \
  && chmod +x /usr/local/bin/oh-my-posh \
  && mkdir /home/${CUSTOM_USER_NAME}/.poshthemes \
  && wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O /home/${CUSTOM_USER_NAME}/.poshthemes/themes.zip \
  && unzip /home/${CUSTOM_USER_NAME}/.poshthemes/themes.zip -d /home/${CUSTOM_USER_NAME}/.poshthemes \
  && chown -R ${CUSTOM_USER_NAME}:${CUSTOM_USER_NAME} /home/${CUSTOM_USER_NAME}/.poshthemes/ \
  && chmod u+rw /home/${CUSTOM_USER_NAME}/.poshthemes/*.json \
  && rm /home/${CUSTOM_USER_NAME}/.poshthemes/themes.zip \
  && echo "oh-my-posh --init --shell fish --config ~/.poshthemes/jandedobbeleer.omp.json | source" >> /home/${CUSTOM_USER_NAME}/.config/fish/config.fish

# Aliases
RUN echo "alias artisan='php artisan'" >> /home/${CUSTOM_USER_NAME}/.config/fish/config.fish \
  && echo "alias magento='php bin/magento'" >> /home/${CUSTOM_USER_NAME}/.config/fish/config.fish

# Install Blackfire
# RUN curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$(php -r 'echo PHP_MAJOR_VERSION . PHP_MINOR_VERSION;') \
#   && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
#   && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
#   && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

# Run the user specified commands
ARG EXTRA_CMDS="echo 'None to run'"
RUN eval $EXTRA_CMDS

# Custom PHP.ini Config
COPY ./conf/.gitkeep ./conf/custom.ini* /usr/local/etc/php/conf.d/

# Update permissions for supervisor and cron
RUN chown ${CUSTOM_USER_NAME}:${CUSTOM_USER_NAME} /etc/supervisor/supervisord.pid \
  && chmod gu+rw /var/run \
  && chmod gu+s /usr/sbin/cron

# Copy and enable CRON/s
COPY ./72/Dockerfile ./72/custom_crontab* /root/
RUN /usr/bin/crontab -u ${CUSTOM_USER_NAME} /root/custom_crontab

ENTRYPOINT []
CMD ["/usr/bin/supervisord"]

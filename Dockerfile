FROM cloudron/base:0.10.0
MAINTAINER Felix Bartels <felix@host-consultants.de>

# configure apache
RUN rm /etc/apache2/sites-enabled/*
RUN sed -e 's,^ErrorLog.*,ErrorLog "/dev/stderr",' -i /etc/apache2/apache2.conf
RUN sed -e "s,MaxSpareServers[^:].*,MaxSpareServers 5," -i /etc/apache2/mods-available/mpm_prefork.conf

RUN a2disconf other-vhosts-access-log
ADD apache2-shaarli.conf /etc/apache2/sites-available/shaarli.conf
RUN ln -sf /etc/apache2/sites-available/shaarli.conf /etc/apache2/sites-enabled/shaarli.conf
RUN echo "Listen 8000" > /etc/apache2/ports.conf

# configure mod_php
RUN a2enmod php7.0
RUN sed -e 's/upload_max_filesize = .*/upload_max_filesize = 8M/' \
        -e 's,;session.save_path.*,session.save_path = "/run/shaarli/sessions",' \
        -i /etc/php/7.0/apache2/php.ini

# configuring rewrite
RUN a2enmod rewrite

RUN mkdir -p /app/code
WORKDIR /app/code

RUN curl -L https://github.com/shaarli/Shaarli/releases/download/v0.8.3/shaarli-v0.8.3-full.tar.gz | tar -xz --strip-components 1 -f -

RUN mkdir -p /app/data/data-dir /run/shaarli/cache /run/shaarli/pagecache /run/shaarli/sessions /run/shaarli/tmp

# config
RUN mv /app/code/data /app/code/data.orig && \
    ln -s /app/data/data-dir /app/code/data && \
    mv /app/code/tpl /app/code/tpl.orig && \
    ln -s /app/data/tpl /app/code/tpl && \
    mv /app/code/plugins /app/code/plugins.orig && \
    ln -s /app/data/plugins/ /app/code/plugins && \
    rm -rf /app/code/cache /app/code/pagecache /app/code/tmp && \
    ln -s /run/shaarli/cache /app/code/cache && \
    ln -s /run/shaarli/pagecache /app/code/pagecache && \
    ln -s /run/shaarli/tmp /app/code/tmp

RUN chown -R www-data:www-data /app/code

ADD start.sh /app/code/start.sh

CMD [ "/app/code/start.sh" ]

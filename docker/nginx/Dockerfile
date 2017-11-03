# Dockerfile von Paul
FROM nginx

LABEL name=surfnotify.com/nginx
LABEL version=0.0.1

COPY nginx.conf /etc/nginx/nginx.conf
COPY sites-available/* /etc/nginx/sites-available/

RUN mkdir -p /etc/nginx/sites-enabled; \
    for site in $(ls /etc/nginx/sites-available/); \
    do ln -s /etc/nginx/sites-available/${site} /etc/nginx/sites-enabled/${site}; \
    done

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
      curl \
      cron \
      ca-certificates; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /var/www/dehydrated; \
    chown www-data:www-data /var/www/dehydrated; \
    chmod 550 -R /var/www/dehydrated; \
    mkdir -p /etc/ssl/surfnotify.com/accounts; \
    chmod 700 -R /etc/ssl/surfnotify.com/accounts; \
    curl https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated \
         -o /usr/local/bin/dehydrated; \
    chmod 755 /usr/local/bin/dehydrated;

# Install dehydrated for let's encrypt.
COPY dehydrated/config /etc/dehydrated/
COPY dehydrated/domains.txt /etc/dehydrated/
COPY dehydrated/reload-nginx.sh /usr/local/bin/
COPY dehydrated/dehydrated-cron /etc/cron.d/dehydrated-cron

RUN chmod 700 -R /etc/dehydrated; \
    chmod 755 /usr/local/bin/reload-nginx.sh; \
    chmod 755 /etc/cron.d/dehydrated-cron; \
    crontab /etc/cron.d/dehydrated-cron;

VOLUME '/var/log/nginx'
VOLUME '/etc/ssl/surfnotify.com'

CMD cron && nginx -g 'daemon off;'

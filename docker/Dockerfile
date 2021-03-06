FROM ruby:2.6-alpine

RUN apk update && \
    apk add build-base nodejs postgresql-dev git openssh tzdata libxml2-dev libxslt-dev

# make app dir
RUN mkdir /app
WORKDIR /app

# install deploy key for gitlab (to pull data providers from gitlab) and gems
COPY deployment/deploy_rsa /tmp/id_rsa
COPY Gemfile Gemfile.lock ./
RUN eval `ssh-agent -s` && \
    chmod 600 /tmp/id_rsa && \
    ssh-add /tmp/id_rsa && \
    echo -e "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    bundle install --binstubs

# copy project
COPY . .

# cleanup
RUN apk del git openssh && \
    rm /tmp/id_rsa && \
    rm -r ./deployment

# precompile assets for production
ARG SECRET_KEY_BASE
RUN SECRET_KEY_BASE=${SECRET_KEY_BASE} RAILS_ENV=production bundle exec rake assets:precompile

# setup entrypoint
COPY ./docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# expose port 3000
EXPOSE 3000

LABEL maintainer="Malte Hecht <malte.fisch@posteo.de>"

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "app" ]
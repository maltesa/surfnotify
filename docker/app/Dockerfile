FROM ruby:2.4-jessie

LABEL name=surfnotify.com/app
LABEL version=0.0.1

# install packages
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev libpq-dev git apt-transport-https
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && apt-get install nodejs yarn
RUN bundle config build.nokogiri --use-system-libraries

# setup directory
RUN mkdir /usr/src/surfnotify

# copy scripts
COPY docker/app/bundle_installer.sh /docker/
RUN chmod +x /docker/bundle_installer.sh
WORKDIR /usr/src/surfnotify
COPY docker/app/start_app.sh .
RUN chmod +x ./start_app.sh

# copy project
COPY . .
# declare build parameters
ARG USER
ARG PASS
# install gems
RUN USER="$USER" PASS="$PASS" /docker/bundle_installer.sh

# precompile assets
RUN bundle exec rails assets:precompile

LABEL maintainer="Malte Hecht <malte.fisch@gmail.com>"

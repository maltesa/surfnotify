FROM ruby:2.4-jessie

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
WORKDIR /usr/src/surfnotify

# install gems
COPY docker/bundle_installer.sh /docker/
COPY Gemfile Gemfile.lock ./
RUN chmod +x /docker/bundle_installer.sh
# declare build parameters
ARG USER
ARG PASS
RUN USER="$USER" PASS="$PASS" /docker/bundle_installer.sh

# copy project
COPY . .
RUN chmod a+x start_app.sh

EXPOSE 3000

LABEL maintainer="Malte Hecht <malte.fisch@gmail.com>"

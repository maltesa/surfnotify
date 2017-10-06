FROM ruby:2.4-alpine

RUN apk add --update --no-cache \
      build-base \
      nodejs \
      tzdata \
      libxml2-dev \
      libxslt-dev \
      postgresql-dev \
      git
RUN bundle config build.nokogiri --use-system-libraries

RUN mkdir /usr/src/surfnotify
WORKDIR /usr/src/surfnotify

COPY bundle_installer.sh /docker/
RUN chmod +x /docker/bundle_installer.sh
COPY Gemfile Gemfile.lock ./

# declare build parameters
ARG USER
ARG PASS
# parameter is passed to the script as an environment variable.
RUN USER="$USER" PASS="$PASS" /docker/bundle_installer.sh

COPY . ./usr/src/surfnotify

LABEL maintainer="Malte Hecht <malte.fisch@gmail.com>"

CMD puma -C config/puma.rb
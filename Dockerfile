FROM ruby:2.4-alpine

RUN apk update && apk add build-base nodejs postgresql-dev git

RUN mkdir /usr/src/surfnotify
WORKDIR /usr/src/surfnotify

COPY bundle_installer.sh /docker/
RUN chmod +x /docker/bundle_installer.sh
COPY Gemfile Gemfile.lock ./

# declare build parameter
ARG CREDENTIALS
# parameter is passed to the script as an environment variable.
RUN CRED="$CREDENTIALS" /docker/bundle_installer.sh

COPY . .

LABEL maintainer="Malte Hecht <malte.fisch@gmail.com>"

CMD puma -C config/puma.rb
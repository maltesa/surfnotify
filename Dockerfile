FROM ruby:2.4-alpine

RUN apk update && apk add build-base nodejs postgresql-dev

RUN mkdir /usr/src/surfnotify
WORKDIR /usr/src/surfnotify

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .

LABEL maintainer="Malte Hecht <malte.fisch@gmail.com>"

CMD puma -C config/puma.rb
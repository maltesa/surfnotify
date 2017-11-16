#!/bin/sh

# remove old pids
rm tmp/pids/*
# DB setup
bundle exec rails db:create
bundle exec rails db:migrate
# start resque worker
LOGGING=1 QUEUE=* bundle exec rake resque:work &
# start resque schedule
bundle exec rake resque:scheduler &
# starting server
bundle exec rails s -p 3000 -b '0.0.0.0' # '127.0.0.1'

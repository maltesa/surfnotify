#!/bin/sh

# remove old pids
# rm tmp/pids/*

# start resque workers
bundle exec rake resque:prune_dead_workers
COUNT=4 LOGGING=1 QUEUE=* bundle exec rake resque:workers &

# start resque scheduler
bundle exec rake resque:scheduler &

# starting server
puma -C config/puma.rb

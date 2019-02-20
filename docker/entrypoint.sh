#!/bin/sh

# exit if command failes
set -e

case "$1" in
  help)
    echo "Usage: app|worker|scheduler|migrate|help"
    ;;
  app)
    # starting server
    rm -f /app/tmp/pids/* || true
    exec puma -C config/puma.rb
    ;;
  worker)
    # start resque workers
    bundle exec rake resque:prune_dead_workers
    exec env COUNT=1 LOGGING=1 QUEUE=* bundle exec rake resque:workers
    ;;
  scheduler)
    # start resque scheduler
    bundle exec rake resque:prune_dead_workers
    exec bundle exec rake resque:scheduler
    ;;
  migrate)
    bundle exec rails db:migrate
    ;;
  *)
    exec "$@"
    ;;
esac

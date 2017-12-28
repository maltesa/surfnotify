# README
## initial installation with docker
*Runs Application in Production Mode*
- install docker and docker-compose
- create volume for ssl files (its shared with mailserver): `docker volume create surfnotify_ssl`
- (re)create dhparams.pem in ./docker/nginx/ `openssl dhparam -out ./docker/nginx/dhparam.pem 2048`
- run `git@bitbucket.org:surfnotify/surfnotify-rails.git`
- `cd surfnotify`
- comment out whole file `docker/nginx/sites-available/surfnotify.com`
- run `docker-compose build nginx`
- run `docker-compose build --build-arg USER='malte.fisch%40gmail.com' --build-arg PASS='password' app`
- run `docker-compose up`
- run `docker exec -t -i nginx_container_name /bin/bash`
- generate ssl certy initially:
  - run `dehydrated --register -accept-terms`
  - run `dehydrated --cron`
  - run `exit`
- run `docker-compose down`
- comment in whole file `docker/nginx/sites-available/surfnotify.com`
- run `docker-compose build --no-cache nginx`
- run `docker-compose up`

## Updating Surfnotify app
- `cd` to app directory (e.g. `/var/apps/surfnotify-rails`)
- run `git pull origin master`
- run `docker-compose build --build-arg USER='malte.fisch%40gmail.com' --build-arg PASS='password' app`
- run `docker-compose down`
- run `docker-compose up -d`

## starting resque and resque scheduler
*in production it should be started by docker-compose*
- make sure redis is running on default port
- start (at least) one worker:
  - `LOGGING=1 QUEUE=* bundle exec rake resque:work`
- start resque scheduler task:
  - `rake resque:scheduler`

## catching mails in development
- mailcather is used so please `gem install mailcatcher` (do NOT add it to the GEMFILE)
- and run `mailcatcher` afterwards
- see mails at http://localhost:1080/
# README
## installation with docker
*Runs Application in Production Mode*
- install docker and docker-compose
- run `git@bitbucket.org:surfnotify/surfnotify-rails.git`
- `cd surfnotify`
- run `docker-compose build --build-arg USER='malte.fisch%40gmail.com' --build-arg PASS='password' app`
- run `docker-compose up`

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
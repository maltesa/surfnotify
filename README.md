# README
## installation with docker
- install docker and docker-compose
- run `git clone user@bitbucket.org:surfnotify/dataprovider-msw.git`
- `cd surfnotify`
- run `docker-compose build --build-arg USER='malte.fisch%40gmail.com' --build-arg PASS='password' rails`
- run `docker-compose run rails rake db:create`
- run `docker-compose run rails rake db:migrate`
- run `docker-compose up`

## starting resque and resque scheduler
- make sure redis is running on default port
- start (at least) one worker:
  - `LOGGING=1 QUEUE=* bundle exec rake resque:work`
- start resque scheduler task:
  - `rake resque:scheduler`

## catching mails in development
- mailcather is used so please `gem install mailcatcher` (do NOT add it to the GEMFILE)
- and run `mailcatcher` afterwards
- see mails at http://localhost:1080/
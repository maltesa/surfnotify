# README
## installation with docker
- install docker and docker-compose
- run `git clone user@bitbucket.org:surfnotify/dataprovider-msw.git`
- `cd surfnotify`
- run `docker build --build-arg CREDENTIALS="user:password@bitbucket.org" ./`

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
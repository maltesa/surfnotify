#!/bin/sh
export BUNDLE_BITBUCKET__ORG="$USER:$PASS"
# bundle config https://bitbucket.org/surfnotify/dataprovider-msw.git "$USER:$PASS"
exec bundle install

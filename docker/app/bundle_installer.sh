#!/bin/sh
export BUNDLE_BITBUCKET__ORG="$USER:$PASS"
exec bundle install

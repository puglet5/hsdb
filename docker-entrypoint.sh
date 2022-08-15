#!/bin/sh

set -e

echo "Environment: $RAILS_ENV"
bundle check || bundle install --jobs 20 --retry 5
yarn install
rm -f $APP_PATH/tmp/pids/server.pid
bundle exec foreman start -f Procfile.dev

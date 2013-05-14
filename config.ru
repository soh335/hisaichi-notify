# This file is used by Rack-based servers to start the application.

# https://devcenter.heroku.com/articles/logging
$stdout.sync = true

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application

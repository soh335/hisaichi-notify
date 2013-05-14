require ::File.expand_path('../config/environment',  __FILE__)
require 'bundler/setup'

# https://devcenter.heroku.com/articles/logging
$stdout.sync = true

EM.run do
  Message.restore
  Thin::Server.start Rails.application, '0.0.0.0', ENV["PORT"]
end

require ::File.expand_path('../config/environment',  __FILE__)
require 'bundler/setup'

$stdout.sync = true

EM.run do
  Message.restore
  Thin::Server.start Rails.application, '0.0.0.0', ENV["PORT"]
end

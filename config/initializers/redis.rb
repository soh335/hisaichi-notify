require 'uri'

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  $redis = Redis.new( :host => uri.host, :port => uri.port, :password => uri.password )
  # http://memo.yomukaku.net/entries/331
  $redis.ping if ENV["RAILS_ENV"] != "test"
end

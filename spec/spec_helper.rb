# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'webmock/rspec'

require 'socket'
require 'tmpdir'
require 'tempfile'
require 'fileutils'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # https://github.com/resque/resque/wiki/RSpec-and-Resque

  config.before(:all) do

    @redis_pid = Tempfile.new(["redis-test", ".pid"])
    @redis_cache_dir = Dir.mktmpdir

    # http://qiita.com/items/bf47e254d662af1294d8
    s = TCPServer.open(0)
    redis_port = s.addr[1]
    s.close

    redis_options = {
      "daemonize"     => 'yes',
      "pidfile"       => @redis_pid.path,
      "port"          => redis_port,
      "timeout"       => 300,
      "save 900"      => 1,
      "save 300"      => 1,
      "save 60"       => 10000,
      "dbfilename"    => "dump.rdb",
      "dir"           => @redis_cache_dir,
      "loglevel"      => "debug",
      "logfile"       => "stdout",
      "databases"     => 16
    }.map { |k, v| "#{k} #{v}" }.join("\n")

    $redis = Redis.new( :host => "localhost", :port => redis_port )
    `echo '#{redis_options}' | redis-server -`
  end

  config.after(:all) do
    %x{
      cat #{@redis_pid.path} | xargs kill -QUIT
    }
    @redis_pid.unlink
    FileUtils.remove_dir @redis_cache_dir, true
  end
end

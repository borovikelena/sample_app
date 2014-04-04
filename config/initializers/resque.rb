rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

require 'resque'
# require 'yaml'

unless defined?($redis)
  $redis = Redis.new(:host => 'localhost', :port => 6379)
end

Resque.redis = $redis
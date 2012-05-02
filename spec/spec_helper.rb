require 'rubygems'
require 'bundler/setup'

require File.expand_path("test_orm/rails/config/application")
require "rspec/rails"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
	config.use_transactional_fixtures = true
	config.before(:each) do
		[MenuItem, Menu, Category, Shop, Btree].each do |klass|
			klass.delete_all
		end
	end

end


require File.expand_path('../boot', __FILE__)

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Test
  class Application < Rails::Application
    config.root= File.expand_path('..', File.dirname(__FILE__))
    config.logger=Logger.new(File.join(config.root, 'log', 'development.log'))
    config.active_support.deprecation=:log
    #config.autoload_paths=File.expand_path("../#{File.dirname(__FILE__)}")
  end
end

require File.expand_path("test_orm/rails/config/enviroment")

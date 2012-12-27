require 'active_record'
require 'logger'
test_orm_dir = File.dirname(__FILE__)
dbconf = YAML::load(File.open(File.join(test_orm_dir, 'rails', 'config', 'database.yml')))
ActiveRecord::Base.establish_connection(dbconf["development"])
ActiveRecord::Base.logger = Logger.new(File.join(test_orm_dir, 'log', 'database.log'))
ActiveRecord::Migrator.up(File.join(test_orm_dir, 'db', 'migrate'))

source "http://rubygems.org"


if File.exist?(File.expand_path('../lolita'))
  gem 'lolita', :path=>File.expand_path('../../lolita',__FILE__)
else
  gem 'lolita','~>3.2.0.rc.9'
end

group :development, :test do
  gem "rails", "~>3.2.0"
  gem 'rspec', '~>2.9.0'
  gem "sqlite3"
  gem 'rspec-rails', '~>2.9.0'
  gem 'haml-rails'
  gem "jeweler", "~> 1.6.0"
	gem "database_cleaner", "~>0.6.7"
end

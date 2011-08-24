namespace :lolita_menu do
  task :require => :environment do
    require "lolita-menu"
  end
  desc 'Generate autocomplete file'
  task :generate_urls => ["lolita_menu:require"] do
    require "lolita-menu"
    if File.exist?(Lolita::Menu::Autocomplete::FileBuilder.input_file)
      Lolita::Menu::Autocomplete.generate_urls
    else
      raise "Lolita menu URL's generator file not found. Call `rails g lolita_menu:install`"
    end
  end
end
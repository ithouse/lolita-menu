namespace :lolita_menu do
  desc 'Generate autocomplete file'
  task :generate do
    if File.exist?(Lolita::Menu::Autocomplete::FileBuilder.input_file)
      Lolita::Menu::Autocomplete.generate
    else
      raise "Lolita menu URL's generator file not found. Call `rails g lolita_menu:install`"
    end
  end
end
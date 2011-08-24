module Lolita
  module Menu
    class Railtie < Rails::Railtie
      
      rake_tasks do
        load "tasks/lolita-menu.rake"
      end
    end
  end
end
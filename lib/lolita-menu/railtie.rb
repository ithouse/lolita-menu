module Lolita
  module Menu
    class Railtie < Rails::Railtie
      railtie_name :lolita_menu

      rake_tasks do
        load "tasks/lolita-menu.rake"
      end
    end
  end
end
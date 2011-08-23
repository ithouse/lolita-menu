require 'rails/generators'
require 'rails/generators/migration'    
module LolitaMenu
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)
      desc "Copy assets and create migrations. "

      def self.next_migration_number(dirname)
       if ActiveRecord::Base.timestamped_migrations
         Time.now.utc.strftime("%Y%m%d%H%M%S")
       else
         "%.3d" % (current_migration_number(dirname) + 1)
       end
     end

      def copy_assets
        generate("lolita_menu:assets")
      end

      def create_menu_migrations
        begin
          migration_template "migrations/create_menus.rb", "db/migrate/create_lolita_menus.rb" 
          migration_template "migrations/create_menu_items.rb", "db/migrate/create_lolita_menu_items.rb"
        rescue Exception => e
          puts e
        end
      end

      def copy_initializer
        template "lolita-menu-urls.rb", "config/lolita-menu-urls.rb"
      end

    end
  end
end
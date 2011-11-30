require 'rails/generators'
require 'rails/generators/migration'    
module Lolita
  module Menu
    module Generators
      class InstallGenerator < Rails::Generators::Base
        include Rails::Generators::Migration

        source_root File.expand_path("../templates", __FILE__)
        desc "Create migrations. "

        @@migration_counts = 0

        def self.next_migration_number(dirname)
          @@migration_counts +=1
          if ActiveRecord::Base.timestamped_migrations
            base_time = (Time.now.utc.strftime("%Y%m%d%H%M")+"00").to_i
            base_time + @@migration_counts
          else
            "%.3d" % (current_migration_number(dirname) + @@migration_counts)
          end
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
end

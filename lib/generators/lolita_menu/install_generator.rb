module LolitaMenu
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Lolita::Generators::FileHelper
      source_root File.expand_path("../templates", __FILE__)
      desc "Copy assets and create migrations. "


      def copy_assets
        generate("lolita_menu:assets")
      end

      def copy_migration
        copy_file "migrations/create_menus.rb", "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_lolita_menus.rb"
        copy_file "migrations/create_menu_items.rb", "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_lolita_menu_items.rb"
      end
    end
  end
end
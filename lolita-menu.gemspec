# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{lolita-menu}
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["ITHouse", "Arturs Meisters"]
  s.date = %q{2011-06-09}
  s.description = %q{Manage public menus for each project inside Lolita.}
  s.email = %q{support@ithouse.lv}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "History.rdoc",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "app/controllers/menu_items_controller.rb",
    "app/models/menu.rb",
    "app/models/menu_item.rb",
    "app/views/components/lolita/menu/_columns.html.haml",
    "app/views/components/lolita/menu/_columns_body.html.haml",
    "app/views/components/lolita/menu/_list.html.haml",
    "app/views/components/lolita/menu_items/_display.html.haml",
    "app/views/components/lolita/menu_items/_row.html.haml",
    "app/views/components/lolita/menu_items/_subtree.html.haml",
    "config/locales/en.yml",
    "config/locales/lv.yml",
    "config/routes.rb",
    "lib/generators/lolita_menu/assets_generator.rb",
    "lib/generators/lolita_menu/install_generator.rb",
    "lib/generators/lolita_menu/templates/migrations/create_menu_items.rb",
    "lib/generators/lolita_menu/templates/migrations/create_menus.rb",
    "lib/lolita-menu.rb",
    "lib/lolita-menu/module.rb",
    "lib/lolita-menu/rails.rb",
    "lolita-menu.gemspec",
    "public/images/lolita-menu/delete.png",
    "public/images/lolita-menu/move.png",
    "public/javascripts/jquery-ui-nested-sortables.js",
    "public/javascripts/lolita/menu-items.js",
    "public/stylesheets/lolita/menu/style.css",
    "spec/controllers/menu_items_controller_spec.rb",
    "spec/models/menu_item_spec.rb",
    "spec/models/menu_spec.rb",
    "spec/spec_helper.rb",
    "test_orm/active_record.rb",
    "test_orm/boot.rb",
    "test_orm/config/active_record.yml",
    "test_orm/db/migrate/01_create_lolita_menus.rb",
    "test_orm/db/migrate/02_create_lolita_menu_items.rb",
    "test_orm/rails/config/application.rb",
    "test_orm/rails/config/enviroment.rb"
  ]
  s.homepage = %q{http://github.com/ithouse/lolita-menu}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.1}
  s.summary = %q{Menu managing plugin for Lolita.}
  s.test_files = [
    "spec/controllers/menu_items_controller_spec.rb",
    "spec/models/menu_item_spec.rb",
    "spec/models/menu_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<lolita>, ["~> 3.1.6"])
      s.add_runtime_dependency(%q<haml>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.6.0"])
      s.add_development_dependency(%q<haml-rails>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<lolita>, ["~> 3.1.6"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.6.0"])
      s.add_dependency(%q<haml-rails>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<lolita>, ["~> 3.1.6"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.6.0"])
    s.add_dependency(%q<haml-rails>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end


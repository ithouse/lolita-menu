# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = "lolita-menu"
  s.version = "0.4.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["ITHouse", "Arturs Meisters"]
  s.description = "Manage public menus for each project inside Lolita."
  s.email = "support@ithouse.lv"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.homepage = "http://github.com/ithouse/lolita-menu"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.summary = "Menu managing plugin for Lolita."

  s.add_runtime_dependency(%q<lolita>, [">= 4.5"])
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test_orm,spec}/*`.split("\n")
  s.require_paths = ["lib"]
end


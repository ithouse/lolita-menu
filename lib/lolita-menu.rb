
$: << File.dirname(__FILE__) unless $:.include?(File.dirname(__FILE__))
require 'haml'
require 'lolita'

module Lolita
  module Menu
    autoload :Configuration, "lolita-menu/configuration"
    module Autocomplete
      autoload :LinkSet, "lolita-menu/autocomplete/link_set"
      autoload :FileBuilder, "lolita-menu/autocomplete/file_builder"
      autoload :Collector, "lolita-menu/autocomplete/collector"

      def self.generate_urls
        file = Lolita::Menu::Autocomplete::FileBuilder.input_file
        instance_eval(File.read(file),file)
      end
    end
    # took this from sitemap_generator
    Urls = (Class.new do
      def method_missing(*args, &block)
        (@link_set ||= reset!).send(*args, &block)
      end

      # Use a new LinkSet instance
      def reset!
        @link_set = Autocomplete::LinkSet.new
      end
    end).new
  end
end

module LolitaMenuConfiguration
  def menu
    @menu ||= Lolita::Menu::Configuration.new
  end
end

Lolita.configuration.extend(LolitaMenuConfiguration)


require 'lolita-menu/module'
require 'lolita-menu/nested_tree'
require 'lolita-menu/rails'
#require 'lolita-menu/railtie'

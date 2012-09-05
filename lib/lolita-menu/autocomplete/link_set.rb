module Lolita
  module Menu
    module Autocomplete
      class LinkSet
        include ::Rails.application.routes.url_helpers

        def initialize(&block)
          @links = []
        end

        def add *args
          unless @file
            @file = Lolita::Menu::Autocomplete::FileBuilder.new("a")
            new_stream = true
          end
          @file.add(*args)
          if new_stream
            finalize_file!
          end
        end

        def create &block
          @file = Lolita::Menu::Autocomplete::FileBuilder.new("w")
          begin
            instance_eval(&block)
          ensure
            finalize_file!
          end
        end

        private

        def finalize_file!
          @file.finalize! 
          @file = nil
        end

      end
    end
  end
end

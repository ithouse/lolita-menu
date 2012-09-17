module Lolita
  module Menu
    module Autocomplete
      class LinkSet
        include ::Rails.application.routes.url_helpers

        def initialize(&block)
          @links = []
          @new_stream = false
        end

        def add *args
          open_file("a+")
          @file.add(*args)
          if @new_stream
            finalize_file!
          end
        end

        def remove *args
          finalize_file!
          open_file("r")
          lines = @file.reject_lines_with(*args)
          finalize_file!
          open_file("w")
          @file.write_lines(lines)
          finalize_file!
        end

        def exist? *args
          @file.exist?(*args)
          if @new_stream
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

        def clear
          open_file("w")
          finalize_file!
        end

        private

        def finalize_file!
          if @file
            @file.finalize! 
            @file = nil
          end
        end

        def open_file mode
          unless @file
            @file = Lolita::Menu::Autocomplete::FileBuilder.new(mode)
            @new_stream = true
          end
        end

      end
    end
  end
end

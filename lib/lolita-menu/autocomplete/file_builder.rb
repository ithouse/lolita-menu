module Lolita
  module Menu
    module Autocomplete
      class FileBuilder

        class << self
          def input_file
            File.join(Rails.root,"config","lolita-menu-urls.rb")
          end

          def output_file
            File.join(Rails.root,"public","lolita-menu-url.txt")
          end
        end

        attr_reader :file

        def initialize(mode)
          @file = File.open(self.class.output_file,mode)
        end

        def add url,label = nil
          @file.puts "#{url} #{label || url}"
        end

        def finalize!
          @file.close
        end
      end

    end
  end
end
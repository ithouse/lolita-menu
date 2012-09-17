module Lolita
  module Menu
    module Autocomplete
      class FileBuilder

        class << self
          def input_file
            Lolita.menu.autocomplete_input_file
          end

          def output_file
            Lolita.menu.autocomplete_output_file
          end
        end

        attr_reader :file

        def initialize(mode)
          @file = File.open(self.class.output_file,mode)
        end

        def add url,label = nil
          @file.puts "#{url} #{label || url}"
        end

        def reject_lines_with url, label = nil
          lines_arr = @file.readlines
          label ||= url
          lines_arr.reject do |line|
            line_match_url_and_label?(line, url, label)
          end
        end

        def exist?(url, label = nil)
          old_lineno = @file.lineno
          @file.rewind
          label ||= url
          !!@file.detect do |line|
            line_match_url_and_label(line, url, label)
          end
        end

        def write_lines(*lines)
          lines.each do |line|
            @file.puts(line)
          end
        end

        def finalize!
          @file.close
        end

        private

        def link_match?(line, url, label)
          line = line.gsub($/, "")
          line == "#{url} #{label}"
        end
      end

    end
  end
end
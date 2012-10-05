module Lolita
  module Menu
    module Autocomplete
      class Collector

        def initialize(term)
          @links = []
          @term = term
          collect_from_file
        end

        def collect_from_file
          if File.exist?(Lolita::Menu::Autocomplete::FileBuilder.output_file)
            File.open(Lolita::Menu::Autocomplete::FileBuilder.output_file, "r").readlines.each{ |line|
              item = line.to_s.split(/\s/)
              first_item = item.shift
              item = [first_item, item.join(" ")]
              term_regexp = Regexp.new(@temp.gsub("\\",""))
              if item.first.match(term_regexp) || item.last.match(term_regexp)
                @links << item
              end
            }
          end
        end

        def to_json
          result = []
          @links.each_with_index{|item, index|
            result << {:id => index, :label => "#{item.last} #{item[1] != item[0] ? "(#{item[0]})" : ""}", :value => item.first}
          }
          result
        end

      end
    end
  end
end
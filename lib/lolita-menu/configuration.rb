module Lolita
  module Menu

    class Configuration
      attr_writer :autocomplete_output_file
      attr_writer :autocomplete_input_file
      
      def autocomplete_output_file
        file_location(@autocomplete_output_file) || File.join(Rails.root,"public","lolita-menu-url.txt")
      end

      def autocomplete_input_file
        file_location(@autocomplete_input_file) || File.join(Rails.root,"config","lolita-menu-urls.rb")
      end

      private

      def file_location(location)
         location.respond_to?(:call) ? location.call : location
      end
    end

  end
end
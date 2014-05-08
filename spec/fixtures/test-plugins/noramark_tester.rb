module NoraMark
  module Tester
    class Generator
      def self.name
        :tester
      end
      def initialize(param = {})
      end
      def convert(parsed_result, render_parameter = {})
        'it is just a test.'
      end
    end
  end
end

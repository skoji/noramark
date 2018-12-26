module NoraMark
  module Tester
    class Generator
      def self.name
        :tester
      end

      def initialize(param = {})
      end

      def convert(_parsed_result, _render_parameter = {})
        'it is just a test.'
      end
    end
  end
end

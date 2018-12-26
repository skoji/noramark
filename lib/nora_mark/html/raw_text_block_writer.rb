module NoraMark
  module Html
    class RawTextBlockWriter
      def initialize(generator)
        @generator = generator
      end

      def write(node)
        @generator.to_html node.text
      end
    end
  end
end

module ArtiMark
  module Html
    class HeaderWriter
      def initialize(generator)
        @generator = generator
        @context = generator.context
      end
      def write(item)
        @context << item[:raw_text]
      end
    end
  end
end

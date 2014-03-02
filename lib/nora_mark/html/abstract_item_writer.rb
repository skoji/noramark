module NoraMark
  module Html
    class AbstractItemWriter
      def initialize(generator)
        @generator = generator
      end
      def write(item)
        item[:children].each do |child|
          @generator.to_html child
        end
      end
    end
  end
end  

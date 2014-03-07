module NoraMark
  module Html
    class AbstractNodeWriter
      def initialize(generator)
        @generator = generator
      end
      def write(node)
        node.children.each do |child|
          @generator.to_html child
        end
      end
    end
  end
end  

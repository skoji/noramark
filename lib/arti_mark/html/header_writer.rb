module ArtiMark
  module Html
    class HeaderWriter
      def initialize(generator)
        @generator = generator
        @context = generator.context
        @writers = {
          :stylesheets => proc do |item|
            @context.stylesheets.concat( item[:stylesheets].map do
              |s|
              if s =~ /^(.+?\.css):\((.+?)\)$/
                [$1, $2]
              else
                s
              end
            end)
          end
        }
      end
      def write(item)
        @writers[item[:type]].call item
      end
    end
  end
end

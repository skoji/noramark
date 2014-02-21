module ArtiMark
  module Html
    class HeaderWriter
      include Util
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
          end,
          :title => proc do |item|
            @context.title = escape_html item[:title].strip
          end
        }
      end
      def write(item)
        @writers[item[:type]].call item
      end
    end
  end
end

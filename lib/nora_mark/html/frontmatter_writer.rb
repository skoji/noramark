module NoraMark
  module Html
    class FrontmatterWriter
      include Util
      def initialize(generator)
        @generator = generator
        @context = generator.context
        @writers = {
          stylesheets: proc do |value|
            value = [value] if value.is_a? String
            @context.stylesheets.concat value
          end,
          title: proc do |value|
            @context.title = escape_html value
          end,
          lang: proc do |value|
            @context.lang = escape_html value.strip
          end,
          paragraph_style: proc do |value|
            @context.paragraph_style = value.strip.to_sym
          end,
          namespace: proc do |value|
            @context.namespaces.merge! value
          end
        }
      end
      def write(node)
        node.yaml.each {
          |k,v|
          writer = @writers[k.to_sym]
          writer.call(v) unless writer.nil?
        }
      end
    end
  end
end

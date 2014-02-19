module ArtiMark
  module Html
    class TagWriter
      attr_accessor :trailer, :item_preprocessors

      def self.create(tag_name, generator, item_preprocessor: nil, trailer: '')
        instance = TagWriter.new(tag_name, generator)
        instance.item_preprocessors << item_preprocessor unless item_preprocessor.nil?
        instance.trailer = trailer
        yield instance if block_given?
        instance
      end

      def initialize(tag_name, generator)
        @tag_name = tag_name
        @generator = generator
        @context = generator.context
        @trailer = trailer
        @item_preprocessors = []
      end

      def attr_string(attrs)
        attrs.map do
          |name, vals|
          if vals.size == 0
            ''
          else
            " #{name}='#{vals.join(' ')}'"            
          end
        end.join('')
      end

      def class_string(cls_array)
        attr_string({'class' => cls_array})
      end

      def ids_string(ids_array)
        attr_string({'id' => ids_array})
      end

      def tag_start(item, attr = {})
        return if item[:no_tag] 
        ids = item[:ids] || []
        classes = item[:classes] || []
        tag_name = @tag_name || item[:name]
        @context << "<#{tag_name}#{ids_string(ids)}#{class_string(classes)}#{attr_string(attr)}>"
      end

      def tag_end(item)
        return if item[:no_tag] 
        tag_name = @tag_name || item[:name]
        @context << "</#{tag_name}>#{@trailer}"
      end

      def write(item)
        @item_preprocessors.each { |x| item = x.call item }
        @context.enable_pgroup, saved_ep = !(item[:args].include?('wo-pgroup') || !@context.enable_pgroup), @context.enable_pgroup
        tag_start item
        write_body item
        tag_end item
        @context.enable_pgroup = saved_ep
      end
      
      def write_body(item)
        item[:children].each { |x| @generator.to_html x }
      end
    end
  end
end

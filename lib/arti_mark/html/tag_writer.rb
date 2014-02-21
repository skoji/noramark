module ArtiMark
  module Html
    class TagWriter
      include Util
      attr_accessor :trailer, :item_preprocessors, :write_body_preprocessors

      def self.create(tag_name, generator, item_preprocessor: nil, write_body_preprocessor: nil, trailer: "\n", chop_last_space: false)
        instance = TagWriter.new(tag_name, generator, chop_last_space: chop_last_space)
        instance.item_preprocessors << item_preprocessor unless item_preprocessor.nil?
        instance.write_body_preprocessors << write_body_preprocessor unless write_body_preprocessor.nil?
        instance.trailer = trailer 
        yield instance if block_given?
        instance
      end

      def initialize(tag_name, generator, **param)
        @tag_name = tag_name
        @generator = generator
        @context = generator.context
        @trailer = trailer
        @item_preprocessors = []
        @write_body_preprocessors = []
        @param = param
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

      def add_class(item, cls)
        (item[:classes] ||= []) << cls
      end

      def add_class_if_empty(item, cls)
        add_class(item, cls) if item[:classes].nil? || item[:classes].size == 0 
      end

      def tag_start(item)
        return if item[:no_tag] 
        ids = item[:ids] || []
        classes = item[:classes] || []
        attr = item[:attrs] || {}
        tag_name = @tag_name || item[:name]
        @context << "<#{tag_name}#{ids_string(ids)}#{class_string(classes)}#{attr_string(attr)}"
        if item[:no_body]
          @context << " />"
        else
          @context << ">"
        end
      end

      def output(string)
        @context << string
      end
      
      def tag_end(item)
        return if item[:no_tag] 
        tag_name = @tag_name || item[:name]
        @context << "</#{tag_name}>#{@trailer}"
      end

      def write(item)
        @item_preprocessors.each { |x| item = instance_exec item.dup, &x }
        @context.enable_pgroup, saved_ep = !(item[:args].include?('wo-pgroup') || !@context.enable_pgroup), @context.enable_pgroup
        tag_start item
        write_body item if !item[:no_body]
        tag_end item if !item[:no_body]
        @context.enable_pgroup = saved_ep
      end

      def write_body(item)
        @write_body_preprocessors.each {
          |x|
          return if instance_exec(item, &x) == :done
        }
        write_children item
      end

      def write_children(item)
        write_array(item[:children])
      end

      def write_array(array)
        return if array.nil? || array.size == 0
        array.each { |x| @generator.to_html x }
        @generator.context.chop_last_space if (@param[:chop_last_space]) 
      end
      
      def children_not_empty(item)
        !item[:children].nil? && item[:children].size > 0 && item[:children].select { |x| (x.is_a? String) ? x.size >0 : !x.nil? }.size > 0
      end

    end
  end
end

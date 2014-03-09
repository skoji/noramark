module NoraMark
  module Html
    class TagWriter
      include Util
      attr_accessor :trailer, :node_preprocessors, :write_body_preprocessors

      def self.create(tag_name, generator, node_preprocessor: nil, write_body_preprocessor: nil, trailer: "\n", chop_last_space: false)
        instance = TagWriter.new(tag_name, generator, chop_last_space: chop_last_space)
        instance.node_preprocessors << node_preprocessor unless node_preprocessor.nil?
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
        @node_preprocessors = []
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
        attr_string({class: cls_array})
      end

      def ids_string(ids_array)
        attr_string({id: ids_array})
      end

      def add_class(node, cls)
        (node.classes ||= []) << cls
      end

      def add_class_if_empty(node, cls)
        add_class(node, cls) if node.classes.nil? || node.classes.size == 0 
      end

      def tag_start(node)
        return if node.no_tag
        ids = node.ids || []
        classes = node.classes || []
        attr = node.attrs || {}
        tag_name = @tag_name || node.name
        @context << "<#{tag_name}#{ids_string(ids)}#{class_string(classes)}#{attr_string(attr)}"
        if node.body_empty
          @context << " />"
        else
          @context << ">"
        end
      end

      def output(string)
        @context << string
      end
      
      def tag_end(node)
        return if node.no_tag
        tag_name = @tag_name || node.name
        @context << "</#{tag_name}>#{@trailer}"
      end

      def write(node)
        @node_preprocessors.each { |x| node = instance_exec node.dup, &x }
        @context.enable_pgroup, saved_ep = !(node.parameters.include?('wo-pgroup') || !@context.enable_pgroup), @context.enable_pgroup
        tag_start node
        write_body node unless node.body_empty
        tag_end node unless node.body_empty
        @context.enable_pgroup = saved_ep
      end

      def write_body(node)
        @write_body_preprocessors.each {
          |x|
          return if instance_exec(node, &x) == :done
        }
        write_children node
      end

      def write_children(node)
        write_nodeset(node.children)
      end

      def write_nodeset(nodeset)
        return if nodeset.nil? || nodeset.size == 0
        nodeset.each { |x| @generator.to_html x }
        @generator.context.chop_last_space if (@param[:chop_last_space]) 
      end
      
      def children_not_empty(node)
        !node.children.nil? && node.children.size > 0 && node.children.reject { |x| x.nil? }.size > 0
      end
    end
  end
end

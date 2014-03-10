module NoraMark
  class NodeBuilder
    def initialize(original_node, options)
      @node = original_node
      @options = options
    end

    def _node(klass, name, children = nil, ids: nil, children_: nil, classes: nil, parameters: nil, named_parameters: nil, attrs: nil, inherit: false)
      children_arg = children || children_
      if !children_arg.nil?
        children_arg = children_arg.to_ary if children_arg.kind_of? NodeSet
        children_arg = [ children_arg ] if !children_arg.kind_of? Array
        children_arg = children_arg.map { |node| (node.is_a? String) ? Text.new(node, @node.line_no) : node }
      end
      if (inherit)
        node = klass.new(name, @node.ids, @node.classes, @node.parameters, @node.named_parameters, @node.children, @node.line_no)
        node.ids = (node.ids ||[] + ids) if !ids.nil?
        node.classes = (node.classes || [])  +  classes if !classes.nil?
        node.parameters = parameters if !parameters.nil?
        node.named_parameters = named_parameters if !named_parameters.nil?
        node.content = children_arg if !children_arg.nil?
      else
        node = klass.new(name, ids, classes, parameters, named_parameters, children_arg, @node.line_no)
      end
      node
    end

    def block(name, children = nil, ids: nil, children_: nil, classes: nil, parameters: nil, named_parameters: nil, attrs: nil, inherit: true)
      _node(Block, name, children, ids: ids, children_: children_, classes: classes, parameters: parameters, named_parameters: named_parameters, attrs: attrs, inherit: inherit)
    end

    def text value
      Text.new(value, @node.line_no)
    end

    def inline
      _node(Inline, name, children, ids: ids, children_: children_, classes: classes, parameters: parameters, named_parameters: named_parameters, attrs: attrs, inherit: inherit)
    end

    def modify(&block)
      instance_eval &block
    end

    def replace(&block)
      new_node = instance_eval &block
      @node.replace new_node
    end
  end
end

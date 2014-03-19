module NoraMark
  module NodeUtil
    def _node(klass, name, children_ = nil, ids: nil, children: nil, classes: nil, parameters: nil, named_parameters: nil, attrs: nil, template: nil, class_if_empty: nil, chop_last_space: nil)
      children_arg = children || children_
      if !children_arg.nil?
        children_arg = children_arg.to_ary if children_arg.kind_of? NodeSet
        children_arg = [ children_arg ] if !children_arg.kind_of? Array
        children_arg = children_arg.map { |node| (node.is_a? String) ? Text.new(node, 0) : node }
      end
      if !template.nil?
        node = klass.new(name, template.ids, template.classes, template.parameters, template.named_parameters, template.children, template.line_no)
        node.ids = (node.ids ||[] + ids) if !ids.nil?
        node.classes = (node.classes || [])
        node.classes << classes if !classes.nil?
        if node.classes.size == 0 && class_if_empty
          node.classes << class_if_empty
        end
        node.parameters = parameters if !parameters.nil?
        node.named_parameters = named_parameters if !named_parameters.nil?
        node.content = children_arg if !children_arg.nil?
        node.attrs = attrs || {}
      else
        node = klass.new(name, ids, classes || [], parameters, named_parameters, children_arg, 0)
        node.attrs = attrs || {}
        if node.classes.size == 0 && class_if_empty
          node.classes << class_if_empty
        end
      end
      node.chop_last_space = chop_last_space if chop_last_space
      node.reparent
      node
    end

    def block(*args)
      _node(Block, *args)
    end

    def inline(*args)
      _node(Inline, *args)
    end

    def text value
      Text.new(value, 0)
    end

  end
end

module NoraMark
  module NodeUtil
    def _node(klass, name, children = nil, ids: nil, children_: nil, classes: nil, parameters: nil, named_parameters: nil, attrs: nil, template: nil)
      children_arg = children || children_
      if !children_arg.nil?
        children_arg = children_arg.to_ary if children_arg.kind_of? NodeSet
        children_arg = [ children_arg ] if !children_arg.kind_of? Array
        children_arg = children_arg.map { |node| (node.is_a? String) ? Text.new(node, 0) : node }
      end
      if !template.nil?
        node = klass.new(name, template.ids, template.classes, template.parameters, template.named_parameters, template.children, template.line_no)
        node.ids = (node.ids ||[] + ids) if !ids.nil?
        node.classes = (node.classes || [])  +  classes if !classes.nil?
        node.parameters = parameters if !parameters.nil?
        node.named_parameters = named_parameters if !named_parameters.nil?
        node.content = children_arg if !children_arg.nil?
      else
        node = klass.new(name, ids, classes, parameters, named_parameters, children_arg, 0)
        node.reparent
      end
      node
    end

    def block(name, children = nil, ids: nil, children_: nil, classes: nil, parameters: nil, named_parameters: nil, attrs: nil, template: nil)
      _node(Block, name, children, ids: ids, children_: children_, classes: classes, parameters: parameters, named_parameters: named_parameters, attrs: attrs, template: template)
    end

    def text value
      Text.new(value, 0)
    end

    def inline(name, children = nil, ids: nil, children_: nil, classes: nil, parameters: nil, named_parameters: nil, attrs: nil, template: nil)
      _node(Inline, name, children, ids: ids, children_: children_, classes: classes, parameters: parameters, named_parameters: named_parameters, attrs: attrs, template: template)
    end


  end
end

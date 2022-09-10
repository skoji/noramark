module NoraMark
  module NodeUtil
    def _node(klass, name, children_ = nil, ids: [], children: nil, classes: [], params: [], n: {}, attrs: [], template: nil, class_if_empty: nil, line_no: nil, body_empty: nil, raw_text: nil)
      children_arg = children || children_
      if !children_arg.nil?
        children_arg = children_arg.to_ary if children_arg.kind_of? NodeSet
        children_arg = [children_arg] if !children_arg.kind_of? Array
        children_arg = children_arg.map { |node| (node.is_a? String) ? Text.new(node, 0) : node }
      end
      if !template.nil?
        node = klass.new(name, template.ids, template.classes, template.params, template.n, template.children, template.line_no)
        node.ids = (node.ids || [] + ids) if ids.size > 0
        node.classes = (node.classes || [])
        node.classes = node.classes + classes
        if node.classes.size == 0 && class_if_empty
          node.classes << class_if_empty
        end
        node.params = params if params.size > 0
        node.n = n if n.size > 0
        node.children = children_arg if !children_arg.nil?
        node.attrs = template.attrs || attrs || {}
      else
        node = klass.new(name, ids, classes || [], params, n, children_arg, 0)
        node.attrs = attrs || {}
        if node.classes.size == 0 && class_if_empty
          node.classes << class_if_empty
        end
      end
      node.line_no = line_no
      node.body_empty = body_empty
      node.raw_text = raw_text
      node.reparent
      node
    end

    def block(*args, **kwargs)
      _node(Block, *args, **kwargs)
    end

    def inline(*args, **kwargs)
      _node(Inline, *args, **kwargs)
    end

    def text value, raw_text: nil
      text = Text.new(value, 0)
      text.raw_text = raw_text
      text
    end
  end
end

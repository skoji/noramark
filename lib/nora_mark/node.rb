require 'yaml'

module NoraMark
  class Node
    include Enumerable
    attr_accessor :content, :ids, :classes, :no_tag, :attrs, :name, :body_empty, :line_no
    attr_accessor :parent, :first_child, :last_child, :prev, :next, :holders

    def chop_last_space?
      @chop_last_space
    end

    def chop_last_space=(val)
      @chop_last_space=val
      self
    end
    
    def named_parameters=(named_parameters)
      @named_parameters = named_parameters
    end

    def named_parameters
      @named_parameters ||= {}
    end

    def parameters=(parameters)
      @parameters = parameters
    end
    
    def parameters
      @parameters ||= []
    end

    def each
      node = self
      while !node.nil?
        yield node
        node = node.next
      end
    end

    def match?(selector)
      selector = build_selector(selector)
      selector.inject(true) {
        |result, selector|
        result && selector.call(self)
      }
    end

    def modify_selector(k,v)
      case k
      when :type
        proc { | node | node.kind_of? NoraMark.const_get(v) }
      when :name
        proc { | node | node.name ==  v }
      when :id
        proc { | node | (node.ids || []).contain? v }
      when :class
        proc { | node | (node.class || []).contain? v }
      when :proc
        v
      else
        raise 'no selector'
      end
    end

    def build_selector(selector)
      original_selector = selector
      case selector
      when String
        selector = { name: original_selector }
      when Regexp
        selector = { proc: proc { |node| original_selector =~ node.name }}
      end
      selector.map { |k,v| modify_selector(k,v) }
    end

    def ancestors(selector = {})
      result = []
      node = parent
      while !node.nil?
        result << node if node.match?(selector)
        node = node.parent
      end
      result
    end

    def children_empty?
      children.nil? || children.size == 0 || children.reject { |x| x.nil? }.size == 0
    end

    def reparent
      return if @content.nil?

      @content.each {|node| node.remove }

      @first_child = @content.first
      @last_child = @content.last
      @content.inject(nil) do |prev, child_node|
        child_node.prev = prev
        prev.next = child_node if !prev.nil?
        child_node.parent = self
        child_node.reparent 
        child_node
      end
      @content = nil
      @children = nil
    end

    def children
      return [] if @first_child.nil?
      return @children ||= NodeSet.new(@first_child.collect { |node| node })
    end

    def children=(x)
      @content = x.to_ary
      reparent
    end

    def children_replaced
      @children = nil
    end

    def unlink
      @parent = nil
      @prev = nil
      @next = nil
    end

    def remove
      @parent.first_child = @next  if !@parent.nil? && @parent.first_child == self
      @parent.last_child = @prev  if !@parent.nil? && @parent.last_child == self
      @next.prev = @prev unless @next.nil?
      @prev.next = @next unless @prev.nil?
      @parent.children_replaced unless @parent.nil?
      unlink
    end

    def append(node)
      node.remove
      node.parent = @parent
      node.prev = self
      node.next = @next
      @next.prev = node unless @next.nil?
      @next = node
      if @parent.last_child == self
        @parent.last_child = node
      end
      node.reparent
      @parent.children_replaced
    end

    def replace(node)
      node = [node] if !node.is_a? Array
      
      first_node = node.shift
      rest_nodes = node

      first_node.parent = @parent
      @parent.first_child = first_node if (@parent.first_child == self)
      @parent.last_child = first_node if (@parent.last_child == self)

      first_node.prev = @prev
      first_node.next = @next

      @prev.next = first_node unless @prev.nil?
      @next.prev = first_node unless @next.nil?

      first_node.reparent
      first_node.parent.children_replaced
      unlink
      rest_nodes.inject(first_node) do
        |prev, rest_node|
        prev.append rest_node
        rest_node
      end
    end

    def prepend_child(node)
      node.remove
      node.reparent
      if self.children.size == 0
        @content = [ node ]
        reparent
      else
        @first_child.prev = node
        node.next = @first_child
        node.parent = self
        @first_child = node
        children_replaced
      end
    end
    
    def append_child(node)
      node.remove
      node.reparent
      if self.children.size == 0
        @content = [ node ]
        reparent
      else
        @last_child.next = node 
        node.prev = @last_child
        node.parent = self
        @last_child = node
        children_replaced
      end
    end

    def all_nodes
      return [] if @first_child.nil?
      @first_child.inject([]) do
        |result, node|
        result << node
        result + node.all_nodes
      end
    end
    
    def clone
      @content = nil
      all_nodes.each { |node| @content = nil }
      Marshal.restore Marshal.dump self
    end

    def get_text
      children.inject("") do
        |result, node|
        result << node.get_text
      end
    end
  end

  class Root < Node
    attr_accessor :document_name
  end

  class Page < Node
    attr_accessor :page_no
  end

  class DLItem < Node
    def reparent
      super
      @parameters[0].inject(nil) do
        |prev, child_node|
        child_node.prev = prev
        prev.next = child_node if !prev.nil?
        child_node.parent = self
        child_node.reparent 
        child_node
      end
    end
    def get_text
      @parameters[0].inject('') do
        |result, node|
        result << node.get_text
      end << super
    end
  end

  class Block < Node
    def heading_info
      @name =~ /h([1-6])/
      return {} if $1.nil?
      {level:  $1.to_i, id: @ids[0], text: get_text }
    end
  end

  class HeadedSection < Node
    def heading_info
      {level: @level, id: (named_parameters[:heading_id] || [])[0], text: @heading.map(&:get_text).join('')}
    end

    def reparent
      super
      @heading.inject(nil) do
        |prev, child_node|
        child_node.prev = prev
        prev.next = child_node if !prev.nil?
        child_node.parent = self
        child_node.reparent 
        child_node
      end
    end

    def get_text
      @heading[0].inject('') do
        |result, node|
        result << node.get_text
      end << super
    end

  end
  class Text < Node
    def reparent
      # do nothing.
    end

    def get_text
      @content
    end
  end


  class PreformattedBlock < Node
    def reparent
      # do nothing.
    end
    def get_text
      @content.join "\n"
    end
  end
  
  class Frontmatter < Node
    def reparent
      # do nothing.
    end

    def get_text
      @content.join "\n"
    end

    def yaml
      @yaml ||= YAML.load(@content.join("\n"))
      @yaml
    end
  end
end  

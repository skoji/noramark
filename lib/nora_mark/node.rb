require 'yaml'

module NoraMark
  class Node
    include Enumerable
    attr_accessor :content, :ids, :classes, :no_tag, :attrs, :name, :body_empty, :line_no
    attr_accessor :parent, :first_child, :last_child, :prev, :next, :holders
    def named_parameters=(named_parameters)
      @named_parameters = named_parameters
    end

    def named_parameters
      @named_parameters = Hash[*(parameters.select { |x| x.include?(':') }.map { |x| v = x.split(':', 2); [v[0].strip.to_sym, v[1]]}.flatten)] if !@parameters.nil?
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

    def match(selector)
      selector.each {
        |k,v|
        return false unless send(k, v)
      }
    end

    def ancestors(selector = {})
      result = []
      node = parent
      while !node.nil?
        result << node if node.match(selector)
        node = node.parent
      end
      result
    end
    
    def reparent
      return if @content.nil?
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
      warn 'this should be removed or not'
      @content = x
      reparent
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

  class DlItem < Node
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
  class HeadedSection < Node
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

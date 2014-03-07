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
    
    def organize
      return if @content.nil?
      @first_child = @content.first
      @last_child = @content.last
      @content.inject(nil) do |prev, child_node|
        child_node.prev = prev
        prev.next = child_node if !prev.nil?
        child_node.parent = self
        child_node.organize 
        child_node
      end
      @content = nil
    end

    def children
      return [] if @first_child.nil?
      return @content ||= NodeSet.new(@first_child.collect { |node| node })
    end

    def children=(x)
      warn 'this should be removed or not'
      @content = x
      organize
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
  end

  class Root < Node
    attr_accessor :document_name
  end

  class Text < Node
    def organize
      # do nothing.
    end
  end

  class PreformattedBlock < Node
    def organize
      # do nothing.
    end
  end
  
  class Frontmatter < Node
    def organize
      # do nothing.
    end
    def yaml
      @yaml ||= YAML.load(@content.join("\n"))
      @yaml
    end
  end
end  

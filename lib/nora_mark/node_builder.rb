module NoraMark
  class NodeBuilder
    include NodeUtil
    def initialize(original_node, options)
      @node = original_node
      @options = options
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

module NoraMark
  class Transformer
    include NodeUtil
    def initialize(rules, options)
      @rules = rules
      @options = options
    end

    def transform(node)
      frontmatter_node = node.find_node :type => :Frontmatter
      @frontmatter = frontmatter_node.yaml if frontmatter_node
      node.all_nodes.each do 
        |n|
        if match_rule = @rules.find { |rule| n.match?(rule[0]) }
          action, p = match_rule[1,2]
          @node = n
          send(action, &p)
        end 
      end
      node
    end

    def modify(&block)
      instance_eval(&block)
    end

    def replace(&block)
      new_node = instance_eval(&block)
      @node.replace new_node if new_node
    end

  end
  
  class TransformerFactory
    attr_accessor :rules, :options
    
    def self.create(text: nil, &block)
      instance = new
      instance.instance_eval do
        @rules = []
        @options = {}
        if text
          instance_eval text
        else
          instance_eval(&block)
        end
        Transformer.new(@rules, @options)
      end
    end 
    
    def transform_options options
      (@options ||= {}).merge options 
    end
    
    def modify(selector, &block)
      @rules << [ selector, :modify, block ]
    end

    def replace(selector, &block)
      @rules << [ selector, :replace, block ]
    end

    def rename(selector, name)
      @rules << [ selector, :modify, proc { @node.name = name } ]
    end
  end
end

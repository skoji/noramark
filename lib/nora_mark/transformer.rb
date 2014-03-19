module NoraMark
  class Transformer
    def initialize(rules, options)
      @rules = rules
      @options = options
    end
    def transform(node)
      node.all_nodes.each do 
        |node|
        if match_rule = @rules.find { |rule| node.match?(rule[0]) }
          selector, action, p = match_rule
          NodeBuilder.new(node, @options).send(action, &p)
        end 
      end
      node
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
          instance_eval &block
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
  end
end

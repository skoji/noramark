require 'yaml'

module NoraMark
  class Node
    attr_accessor :content, :ids, :classes, :no_tag, :attrs, :name, :body_empty, :line_no

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
  end

  class Frontmatter < Node
    def yaml
      @yaml ||= YAML.load(@content.join("\n"))
      @yaml
    end
  end
end  

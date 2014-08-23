require 'securerandom'

module NoraMark
  class Document 
    attr_accessor :document_name, :root
    private_class_method :new 

    def self.generators
      @generators ||= {}
    end
    
    def self.register_generator(generator)
      @generators ||= {}
      generator_name = generator.name
      @generators[generator_name] = generator
      generator.activate self if generator.respond_to? :activate
      define_method(generator_name) do
        generate(generator_name)
      end
    end

    def self.unregister_generator(generator)
      @generators ||= {}
      if generator.is_a? Symbol or generator.is_a? String
        generator_name = generator.to_sym
      else
        generator_name = generator.name        
      end

      @generators.delete generator_name
      generator.deactivate self if generator.respond_to? :deactivate
      remove_method generator_name
    end

    register_generator(::NoraMark::Html::Generator)

    def self.parse(string_or_io, param = {})
      instance = new param
      src = (string_or_io.respond_to?(:read) ? string_or_io.read : string_or_io).encode 'utf-8'
      yield instance if block_given?
      instance.instance_eval do 
        @preprocessors.each do
          |pr|
          src = pr.call(src)
        end
        parser = Parser.new(src)
        if (!parser.parse)
          raise parser.raise_error
        end
        @root = parser.result
        @root.document_name ||= @document_name
        @root.reparent
        @root.first_child.inject(1) do |page_no, node|
          if node.kind_of? Page
            node.page_no = page_no
            page_no = page_no + 1
          end
          page_no
        end
      end
      frontmatter = instance.root.find_node :type => :Frontmatter
      if (frontmatter)
        if (frontmatter.yaml['generator'])
          NoraMark::Extensions.register_generator(frontmatter.yaml['generator'].to_sym)
        end
      end
      
      instance
    end

    def preprocessor(&block)
      @preprocessors << block
    end

    def transformers(generator_name)
      @transformers[generator_name] ||= []
    end
    
    def generate(generator_name)
      if @result[generator_name].nil?
        transformers(generator_name).each { |t| t.transform @root }
        @result[generator_name] = Document.generators[generator_name].new(@param).convert(@root.clone, @render_parameter)
      end
      @result[generator_name]
    end

    def render_parameter(param = {})
      @render_parameter.merge! param
      self
    end

    def add_transformer(generator: :html, text: nil, &block)
      (@transformers[generator] ||= []) << TransformerFactory.create(text: text, &block)
    end
    
    def initialize(param = {})
      @param = param
      @result = {}
      @preprocessors = [
                        Proc.new { |text| text.gsub(/\r?\n(\r?\n)+/, "\n\n") },
                       ]
      @document_name = param[:document_name] || "noramark_#{SecureRandom.uuid}"
      @render_parameter = {}
      @transformers = { }
    end 
  end
end

require 'securerandom'

module NoraMark
  class Document 
    attr_accessor :document_name, :root
    private_class_method :new 

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
      instance.register_generator(Html::Generator)
      instance
    end

    def preprocessor(&block)
      @preprocessors << block
    end

    def register_generator(generator)
      if !generator.respond_to? :name
        generator = load_generator(generator)
      end
      generator_name = generator.name
      @generators[generator_name] = generator
      @transformers[generator_name] = []
      generator.activate self if generator.respond_to? :activate
      singleton_class.class_eval do
        define_method(generator_name) do
          generate(generator_name)
        end
      end
    end
    
    def load_generator(generator)
      module_name = '::NoraMark::#{generator.to_s.capitalize}::Generator'
      return const_get(module_name) if const_defined? module_name.to_sym
      path = "noramark-generator-#{generator.to_s.lowercase}.rb"
      current_dir_path = File.expand_path(File.join('.', '.noramark-plugins', path))
      home_dir_path = File.expand_path(File.join(ENV['HOME'], '.noramark-plugins', path))
      if File.exist? current_dir_path
        require current_dir_path
      elsif File.exist? home_dir_path
        require home_dir_path
      else
        require path
      end
      const_defined? module_name.to_sym ? const_get(module_name) : nil
    end
    
    def generate(generator_name)
      if @result[generator_name].nil?
        @transformers[generator_name].each { |t| t.transform @root }
        @result[generator_name] = @generators[generator_name].new(@param).convert(@root.clone, @render_parameter)
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
      @generators = {}
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

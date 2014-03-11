require "nora_mark/version"
require 'nora_mark/html/generator'
require 'nora_mark/parser'
require 'nora_mark/node_util'
require 'nora_mark/node'
require 'nora_mark/node_set'
require 'nora_mark/transformer'
require 'nora_mark/node_builder'
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
      instance
    end

    def preprocessor(&block)
      @preprocessors << block
    end

    def html
      if @html.nil?
        @transformers[:html].each { |t| t.transform @root }
        @html = Html::Generator.new(@param).convert(@root.clone, @render_parameter)
      end
      @html
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
      @preprocessors = [
                        Proc.new { |text| text.gsub(/\r?\n(\r?\n)+/, "\n\n") },
                       ]
      @document_name = param[:document_name] || "noramark_#{SecureRandom.uuid}"
      @render_parameter = {}
      @transformers = { html: []}
    end 
  end
end

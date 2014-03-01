require "arti_mark/version"
require 'arti_mark/html/generator'
require 'arti_mark/parser'

module ArtiMark
  class Document
    private_class_method :new 

    def self.parse(string_or_io, param = {})
      instance = new param
      src = string_or_io.respond_to?(:read) ? string_or_io.read : string_or_io
      yield instance if block_given?
      instance.instance_eval do 
        @preprocessors.each do
          |pr|
          src = pr.call(src)
        end
        @parser = Parser.new(src)
        if (!@parser.parse)
          raise @parser.raise_error
        end
      end
      instance
    end

    def preprocessor(&block)
      @preprocessors << block
    end

    def html
      if @html.nil?
        @html = @html_generator.convert(@parser.result)
      end
      @html
    end
    
    def initialize(param = {})
      @preprocessors = [
                        Proc.new { |text| text.gsub(/\r?\n(\r?\n)+/, "\n\n") },
                       ]
      @html_generator = Html::Generator.new(param)
    end 


  end
end

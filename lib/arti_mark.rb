# -*- encoding: utf-8 -*-
require "arti_mark/version"
require 'arti_mark/html/generator'
require 'arti_mark/parser'

module ArtiMark
  class Document
    def initialize(param = {})
      @preprocessors = [
                        Proc.new { |text| text.gsub(/\r?\n(\r?\n)+/, "\n\n") },
                        Proc.new { |text| text.strip.gsub(/　/, ' ') } # convert Japanese full-width spece to normal space
                       ]
      @generator = Html::Generator.new(param)
    end 

    def preprocessor(&block)
      @preprocessors << block
    end

    def convert(text)
      @preprocessors.each {
        |pr|
        text = pr.call(text)
      }
      @parser = Parser.new(text)
      if (!@parser.parse)
        raise @parser.raise_error
      end
      @generator.convert(@parser.result)
    end
  end
end

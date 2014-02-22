# -*- encoding: utf-8 -*-
require "arti_mark/version"
require "arti_mark/command_lexer"
require "arti_mark/base_parser"
require 'arti_mark/common_block_parser'
require "arti_mark/paragraph_parser"
require "arti_mark/div_parser"
require "arti_mark/article_parser"
require "arti_mark/section_parser"
require "arti_mark/head_parser"
require "arti_mark/block_image_parser"
require "arti_mark/list_parser"
require "arti_mark/ordered_list_parser"
require "arti_mark/unordered_list_parser"
require "arti_mark/definition_list_parser"
require "arti_mark/universal_block_parser"
require 'arti_mark/syntax'

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

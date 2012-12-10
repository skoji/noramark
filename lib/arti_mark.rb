# -*- encoding: utf-8 -*-
require "arti_mark/version"
require "arti_mark/command_parser"
require "arti_mark/base_parser"
require 'arti_mark/common_block_parser'
require "arti_mark/paragraph_parser"
require "arti_mark/div_parser"
require "arti_mark/article_parser"
require "arti_mark/section_parser"
require "arti_mark/head_parser"
require 'arti_mark/syntax_handler'
require 'arti_mark/result_holder'

module ArtiMark
  class Document
    def initialize(param = {})
      @resultHolder = ResultHolder.new(param)
      @syntax_handler = SyntaxHandler.new
    end 

    def convert(text)
      # split text to lines
      lines = text.strip.gsub(/　/, ' ').gsub(/\r?\n(\r?\n)+/, "\n\n").split(/\r?\n/).map { |line| line.strip } # should be plaggable
      process_lines(lines, @resultHolder)
      @resultHolder.result
    end

    def process_lines(lines, r)
      while (lines.size > 0)
        @syntax_handler.parse(lines, r)
      end
      r
    end

  end
end

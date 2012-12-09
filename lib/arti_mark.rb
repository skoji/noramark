# -*- encoding: utf-8 -*-
require "arti_mark/version"
require "arti_mark/base_parser"
require 'arti_mark/common_block_parser'
require "arti_mark/paragraph_parser"
require "arti_mark/div_parser"
require "arti_mark/article_parser"
require "arti_mark/head_parser"
require 'arti_mark/syntax_handler'

module ArtiMark
  class Document
    def initialize(param = {})
      @lang = param[:lang] || 'en'
      @title = param[:title] || 'ArtiMark generated document'
      @syntax_handler = SyntaxHandler.new
    end 

    def start_html(pages)
      page = ''
      page << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
      page << "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"#{@lang}\" xml:lang=\"#{@lang}\">\n"
      page << "<head>\n"
      page << "<title>#{@title}</title>\n"
      # TODO : head inserter
      page << "</head>\n"
      page << "<body>\n"
      pages << page
    end
    
    def end_html(pages)
      page = pages[0]
      page << "</body>\n"
      page << "</html>\n"
      page.freeze # TODO: really need this? 
    end

    def convert(text)
      # split text to lines
      lines = text.strip.gsub(/\r?\n(\r?\n)+/, "\n\n").split(/\r?\n/).map { |line| line.strip }
      r = []
      start_html r
      process_lines(lines, r)
      end_html r
      r
    end

    def process_lines(lines, r)
      while (lines.size > 0)
        @syntax_handler.parse(lines, r)
      end
      r
    end

  end
end

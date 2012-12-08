# -*- encoding: utf-8 -*-
require "arti_mark/version"
require "arti_mark/paragraph_parser"

module ArtiMark
  class Document
    def initialize(param = {})
      @lang = param[:lang] || 'en'
      @title = param[:title] || 'ArtiMark generated document'
      @output = ""
    end 

    def result
      @output
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
        block_parse(lines, r)
      end
      r
    end

    def block_parse(lines, r)
        # slice_beforeが使えるかもしれない
        lines.shift while lines[0] == ''
        index = lines.find_index { |line| line.size == 0} || lines.size
        block = lines.shift(index)
        r[0] << process_paragraph_group(block)
    end    

    def process_paragraph(line)
      classstr = ""
      if line =~/^(「|（)/
        classstr = " class='noindent'"
      end
      "<p#{classstr}>#{line}</p>"
    end

    def process_paragraph_group(lines)
      r = "<div class='pgroup'>\n"
      lines.each {
        |line|
        r << process_paragraph(line) + "\n" unless line.size == 0
      }
      r << "</div>\n"
    end

  end
end

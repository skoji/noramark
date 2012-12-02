# -*- encoding: utf-8 -*-
require "arti_mark/version"

module ArtiMark
  class Document
    def initialize
      @output = ""
    end 

    def result
      @output
    end 

    def process_paragraph(line)
      classstr = ""
      if line =~/^(「|（)/
        classstr = ' class="noindent"'
      end
      output "<p#{classstr}>#{line}</p>\n"
    end

    def process_paragraph_block(lines)
      output "<div class='paragraph_block'>\n"
      lines.each {
        |line|
        process_paragraph(line)
      }
      output "</div>\n"
    end

    def output(str)
      @output << str
    end
  end
end

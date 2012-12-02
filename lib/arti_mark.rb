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
        classstr = " class='noindent'"
      end
      "<p#{classstr}>#{line}</p>"
    end

    def process_paragraph_group(lines)
      r = ["<div class='pgroup'>"]
      lines.each {
        |line|
        r << process_paragraph(line)
      }
      r << "</div>"
    end

  end
end

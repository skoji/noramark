# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class ParagraphParser
    include BaseParser, Singleton
    def parse(lines, r)
        lines.shift while lines[0] == ''
        index = lines.find_index { |line| line.size == 0} || lines.size
        block = lines.shift(index)
        r[0] << process_paragraph_group(block)
    end

    def process_paragraph_group(lines)
      r = "<div class='pgroup'>\n"
      lines.each {
        |line|
        r << process_line(line) unless line.size == 0
      }
      r << "</div>\n"
    end

  end
end

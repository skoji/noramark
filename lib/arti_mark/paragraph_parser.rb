# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class ParagraphParser
    include BaseParser, Singleton

    def accept?(lines)
      lines[0].size == 0
    end
    def parse(lines, r, syntax)
        lines.shift while lines[0].size == 0
        return unless syntax.determine_parser(lines).nil? 
        r << process_paragraph_group(lines, '', syntax)
    end

    def process_paragraph_group(lines, paragraph, syntax)
      paragraph << "<div class='pgroup'>\n"
      while (lines.size > 0 && 
            lines[0] != '}' && # TODO: is this correct...?
            syntax.determine_parser(lines).nil?)
          paragraph << process_line(lines.shift, syntax) 
      end
      paragraph << "</div>\n"
    end

  end
end

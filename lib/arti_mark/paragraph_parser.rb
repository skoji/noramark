# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class ParagraphParser
    include BaseParser, Singleton

    def parse(lines, r, syntax_handler)
        lines.shift while lines[0].size == 0
        return unless syntax_handler.determine_parser(lines).nil? 
        r[0] << process_paragraph_group(lines, '', syntax_handler)
    end

    def process_paragraph_group(lines, r, syntax_handler)
      r << "<div class='pgroup'>\n"
      while lines.size > 0 && 
            lines[0] != '}' && # TODO: is this correct...?
            syntax_handler.determine_parser(lines).nil? 
          r << process_line(lines.shift, syntax_handler) 
      end
      r << "</div>\n"
    end

  end
end

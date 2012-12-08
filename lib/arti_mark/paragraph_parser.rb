# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class ParagraphParser
    include BaseParser, Singleton
    def parse(lines, r, syntax_handler)
        lines.shift while lines[0] == ''
        r[0] << process_paragraph_group(lines, syntax_handler)
    end

    def process_paragraph_group(lines, syntax_handler)
      r = "<div class='pgroup'>\n"
      while lines.size > 0 && syntax_handler.determine_parser(lines[0]).nil? && lines[0].size > 0
        r << process_line(lines.shift, syntax_handler)
      end
      r << "</div>\n"
    end

  end
end

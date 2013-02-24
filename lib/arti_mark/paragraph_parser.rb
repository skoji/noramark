# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class ParagraphParser
    include BaseParser, Singleton

    def accept?(lines)
      lines[0].size == 0
    end
    def parse(lines, context, syntax)
        lines.shift while lines[0].size == 0
        return unless syntax.determine_parser(lines).nil? 
        context << process_paragraph_group(lines, syntax, context)
    end

    def process_paragraph_group(lines, syntax, context)
      paragraph = ''
      while (lines.size > 0 && 
            lines[0] != '}' && # TODO: is this correct...?
            syntax.determine_parser(lines).nil?)
          paragraph << process_line(lines.shift, syntax, context) 
      end
      if paragraph.size > 0 
        paragraph = "<div class='pgroup'>\n#{paragraph}</div>\n" if context.enable_pgroup
      end
      paragraph
    end
  end
end

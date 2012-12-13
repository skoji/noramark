# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class OrderedListParser
    include BaseParser, Singleton
 
    def accept?(lines)
      lex_line_command(lines[0])[:cmd] =~ /[0-9]+/
    end

    def parse(lines, r, syntax)
      lexed = lex_line_command(lines[0])
      r << "<ol#{class_string(lexed[:cls])}>\n"
      process_block(lines, r, syntax)
      r << "</ol>\n"
    end

    def process_block(lines, r, syntax)
      while lines.size > 0  
        lexed = lex_line_command(lines[0])
        return unless lexed[:cmd] =~ /[0-9]+/
        r << "<li>#{lexed[:text].strip}</li>\n"
        lines.shift
      end
    end
  end
end

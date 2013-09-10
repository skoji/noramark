# -*- encoding: utf-8 -*-

module ArtiMark
  module ListParser
    include BaseParser
 
    def accept?(lines)
      lex_line_command(lines[0])[:cmd] =~ @cmd
    end

    def parse(lines, r, syntax)
      lexed = lex_line_command(lines[0])
      r << "<#{@blockname}#{ids_string(lexed[:ids])}#{class_string(lexed[:cls])}>\n"
      process_block(lines, r, syntax)
      r << "</#{@blockname}>\n"
    end

    def process_block(lines, r, syntax)
      while lines.size > 0  
        lexed = lex_line_command(lines[0])
        return unless lexed[:cmd] =~ @cmd
        r << "<li>#{escape_html lexed[:text].strip}</li>\n"
        lines.shift
      end
    end
  end
end

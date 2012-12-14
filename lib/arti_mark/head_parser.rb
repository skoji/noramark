#require 'singleton'

module ArtiMark
  class HeadParser
    include BaseParser, Singleton
    def accept?(lines)
      lex_line_command(lines[0])[:cmd] =~ /h[1-6]/
    end

    def parse(lines, r, syntax)
      lexed = lex_line_command(lines[0])
      raise 'HeadParser called for #{lines[0]}' unless lexed[:cmd] =~ /h([1-6])/
      lines.shift
      r << "<#{lexed[:cmd]}#{class_string(lexed[:cls])}>#{escape_html lexed[:text].strip}</#{lexed[:cmd]}>\n"
      r.toc = lexed[:text].strip if lexed[:params].member? 'in-toc'
    end
  end
end
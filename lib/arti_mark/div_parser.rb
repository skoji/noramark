# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class DivParser
    include BaseParser, Singleton
    def parse(lines, r, syntax_handler)
      lines.shift =~ /^d(\.\w+?)*\s*{\s*$/
      if !$1.nil?
        class_array = $1[1..-1].split('.')
      else
        class_array = []
      end
      r[0] << process_div(lines, syntax_handler, class_array)
    end

    def process_div(lines, syntax_handler, class_array)
      r = "<div#{class_string(class_array)}>\n"
      while lines.size > 0  
        line = lines.shift
        break if line == '}'
        if parser = syntax_handler.determine_parser(lines[0])
          parser.parse(lines, r, syntax_handler)
        else 
          r << process_line(line, syntax_handler)
        end
      end
      r << "</div>\n"
    end

  end
end

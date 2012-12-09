# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class DivParser
    include BaseParser, Singleton
    def parse(lines, r, syntax_handler)
      lines.shift =~ /^d(\.\w+?)*\s*{\s*$/
      cls_array = class_array($1)
      process_div(lines, r, syntax_handler, cls_array)
    end

    def process_div(lines, r, syntax_handler, cls_array)
      r[0] << "<div#{class_string(cls_array)}>\n"
      while lines.size > 0  
        if lines[0] == '}'
          lines.shift
          break
        end
        syntax_handler.determine_parser(lines, :get_default => true).parse(lines, r, syntax_handler)
      end
      r[0] << "</div>\n"
    end

  end
end

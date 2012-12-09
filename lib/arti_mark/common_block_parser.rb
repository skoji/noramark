# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  module CommonBlockParser
    include BaseParser
    def accept?(lines)
      lines[0] =~ /^#{@command}(\.\w+?)*\s*{\s*$/
    end

    def parse(lines, r, syntax_handler)
      lines.shift =~ /^#{@command}(\.\w+?)*\s*{\s*$/
      cls_array = class_array($1)
      process_block(lines, r, syntax_handler, cls_array)
    end

    def process_block(lines, r, syntax_handler, cls_array)
      r << "<#{@markup}#{class_string(cls_array)}>\n"
      while lines.size > 0  
        if lines[0] == '}'
          lines.shift
          break
        end
        syntax_handler.determine_parser(lines, :get_default => true).parse(lines, r, syntax_handler)
      end
      r << "</#{@markup}>\n"
    end

  end
end

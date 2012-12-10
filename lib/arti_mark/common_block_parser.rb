# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  module CommonBlockParser
    include BaseParser
    def accept?(lines)
      lex_block_command(lines[0])[:cmd] =~ @command
    end

    def parse(lines, r, syntax)
      lexed = lex_block_command(lines.shift)
      throw 'something wrong here #{lines}' unless lexed[:cmd] =~ @command
      process_block(lines, r, syntax, lexed[:cls])
    end

    def process_block(lines, r, syntax, cls_array)
      r << "<#{@markup}#{class_string(cls_array)}>\n"
      while lines.size > 0  
        if lines[0] == '}'
          lines.shift
          break
        end
        syntax.determine_parser(lines, :get_default => true).call(lines, r, syntax)
      end
      r << "</#{@markup}>\n"
    end

  end
end

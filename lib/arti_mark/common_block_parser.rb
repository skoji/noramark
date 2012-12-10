# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  module CommonBlockParser
    include BaseParser
    def accept?(lines)
      lex_block_command(lines[0])[:cmd] == @command
    end

    def parse(lines, r, syntax_handler)
      lexed = lex_block_command(lines.shift)
      throw 'something wrong here #{lines}' if lexed[:cmd] != @command
      process_block(lines, r, syntax_handler, lexed[:cls])
    end

    def process_block(lines, r, syntax_handler, cls_array)
      r << "<#{@markup}#{class_string(cls_array)}>\n"
      while lines.size > 0  
        if lines[0] == '}'
          lines.shift
          break
        end
        syntax_handler.determine_parser(lines, :get_default => true).call(lines, r, syntax_handler)
      end
      r << "</#{@markup}>\n"
    end

  end
end

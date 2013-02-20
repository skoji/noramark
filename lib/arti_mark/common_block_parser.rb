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
      @markup = lexed[:cmd] if @markup.nil?
      process_block(lines, r, syntax, lexed[:cls], lexed[:params])
    end
    
    def process_block(lines, r, syntax, cls_array, params)
      flat_text = params.member? 'flat-text'
      r << "<#{@markup}#{class_string(cls_array)}>\n"
      while lines.size > 0  
        if lines[0] == '}'
          lines.shift
          break
        end
        if flat_text 
          #TODO : common with paragraph_parser. should go anywhere else
          while (lines.size > 0 && 
            lines[0] != '}' && 
            syntax.determine_parser(lines).nil?)
            r << process_line(lines.shift, syntax, r) 
          end
        else 
          syntax.determine_parser(lines, :get_default => true).call(lines, r, syntax)
        end
      end
      r << "</#{@markup}>\n"
    end

  end
end

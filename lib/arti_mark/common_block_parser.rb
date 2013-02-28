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
      r.enter_block(lexed)
      process_block(lines, r, syntax, lexed[:cls], lexed[:params])
      r.exit_block(lexed)
    end
    
    def process_block(lines, r, syntax, cls_array, params)
      previous_pgroup , r.enable_pgroup = r.enable_pgroup , false if params.member? 'wo-pgroup'
      r << "<#{@markup}#{class_string(cls_array)}>\n"
      while lines.size > 0
        if lines[0] == r.block_delimiter + '}' 
          lines.shift
          break
        else
          syntax.determine_parser(lines, :get_default => true).call(lines, r, syntax)
        end
      end
      r << "</#{@markup}>\n"
      r.enable_pgroup = previous_pgroup if !previous_pgroup.nil?
    end

  end
end

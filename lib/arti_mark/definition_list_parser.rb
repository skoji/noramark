# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class DefinitionListParser
    include ListParser, Singleton
 
    def initialize
      @cmd = /;/
      @blockname = 'dl'
    end

    def process_block(lines, r, syntax)
      while lines.size > 0  
        lexed = lex_line_command(lines[0])
        return unless lexed[:cmd] =~ @cmd
        dt, dd = lexed[:text].split(':').map(&:strip)
        r << "<dt>#{dt}</dt><dd>#{dd}</dd>\n"
        lines.shift
      end
    end
  end
end

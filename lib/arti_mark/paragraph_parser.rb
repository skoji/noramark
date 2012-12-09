# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class ParagraphParser
    include BaseParser, Singleton

    class StatusAware
      attr_accessor :result, :div_opend
      def initialize()
          @result = ''
          @div_opened = false
      end
      def open_div()
        if !@div_opened
          @result << "<div class='pgroup'>\n"
        end
        @div_opened = true
      end

      def close_div()
        if @div_opened
          @result  << "</div>\n"
        end
        @div_opened = false
      end

    end

    def parse(lines, r, syntax_handler)
        lines.shift while lines[0] == ''
        status = StatusAware.new
        r[0] << process_paragraph_group(lines, status, syntax_handler)
    end

    def process_if_pgroup_splitter(lines, status, syntax_handler)
      lines[0] =~ /^(\w+?)((?:\.\w*?)*):(.*?)$/
      cmd, cls, text = $1, $2, $3
      if cmd =~ /h([1-6])/
        lines.shift
        class_array = []
        if !cls.nil? && cls.size > 0
          class_array = cls[1..-1].split('.')
        end
        status.close_div()
        status.result << "<h#{$1}#{class_string(class_array)}>#{text.strip}</h#{$1}>\n"
        true
      end
    end

    def process_paragraph_group(lines, status, syntax_handler)
      while lines.size > 0 && 
            syntax_handler.determine_parser(lines[0]).nil? 
        if !process_if_pgroup_splitter(lines, status, syntax_handler)
          status.open_div()
          status.result << process_line(lines.shift, syntax_handler)
        end
      end
      status.close_div()
      status.result
    end

  end
end

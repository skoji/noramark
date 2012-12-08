# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class ParagraphParser
    include Singleton
    def parse(lines, r)
        lines.shift while lines[0] == ''
        index = lines.find_index { |line| line.size == 0} || lines.size
        block = lines.shift(index)
        r[0] << process_paragraph_group(block)
    end
    def process_paragraph(line)
      classstr = ""
      if line =~/^(「|（)/
        classstr = " class='noindent'"
      end
      "<p#{classstr}>#{line}</p>"
    end

    def process_paragraph_group(lines)
      r = "<div class='pgroup'>\n"
      lines.each {
        |line|
        line =~ /^(\w+?)(?:\.(\w*?))?:(.*?)$/
        cmd, cls, text = $1, $2, $3
        classstr = ''
        if !cls.nil?
          classstr = " class='#{cls}'"
        end
        if cmd =~ /h([1-6])/
          r << "<h#{$1}#{classstr}>#{text.strip}</h#{$1}>\n"
        elsif !cmd.nil? && respond_to?(cmd.to_sym)
          send(cmd, cls, "#{text}")
        else
          r << process_paragraph(line) + "\n" unless line.size == 0
        end
      }
      r << "</div>\n"
    end

  end
end

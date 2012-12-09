# -*- encoding: utf-8 -*-
module ArtiMark
  module BaseParser
    def class_string(cls_array)
      if cls_array.size == 0
        ''
      else
        " class='#{cls_array.join(' ')}'"
      end
    end

    def process_if_pgroup_splitter(lines, r, syntax_handler)
      lines[0] =~ /^(\w+?)((?:\.\w*?)*):(.*?)$/
      cmd, cls, text = $1, $2, $3
      if cmd =~ /h([1-6])/
        lines.shift
        class_array = []
        if !cls.nil? && cls.size > 0
          class_array = cls[1..-1].split('.')
        end
        r << "</div>\n"
        r << "<h#{$1}#{class_string(class_array)}>#{text.strip}</h#{$1}>\n"
        r << "<div class='pgroup'>\n"
        p r
        true
      end
    end

    def paragraph(line, cls_array)
      if line =~/^(「|（)/ # TODO: should be plaggable
        cls_array << 'noindent'
      end
      "<p#{class_string(cls_array)}>#{line}</p>\n"
    end

    def process_line(line, syntax_handler)
      line =~ /^(\w+?)((?:\.\w*?)*):(.*?)$/
      cmd, cls, text = $1, $2, $3
      class_array = []
      if !cls.nil? && cls.size > 0
        class_array = cls[1..-1].split('.')
      end
      if !cmd.nil? && syntax_handler.respond_to?(cmd.to_sym)
        syntax_handler.send(cmd, class_array, "#{text}")
      else
        paragraph(line, class_array)
      end
    end
  end
end
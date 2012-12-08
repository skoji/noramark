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

    def paragraph(line, cls_array)
      if line =~/^(「|（)/
        cls_array << 'noindent'
      end
      "<p#{class_string(cls_array)}>#{line}</p>\n"
    end

    def process_line(line)
      line =~ /^(\w+?)((?:\.\w*?)*):(.*?)$/
      cmd, cls, text = $1, $2, $3
      class_array = []
      if !cls.nil? && cls.size > 0
        class_array = cls[1..-1].split('.')
      end
      if cmd =~ /h([1-6])/
        "<h#{$1}#{class_string(class_array)}>#{text.strip}</h#{$1}>\n"
      elsif !cmd.nil? && respond_to?(cmd.to_sym)
        send(cmd, cls, "#{text}")
      else
        paragraph(line, class_array)
      end
    end

  end
end
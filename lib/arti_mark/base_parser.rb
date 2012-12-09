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
    def class_array(cls_part)
      cls_array = []
      if !cls_part.nil? && cls_part.size > 0
        cls_array = cls_part[1..-1].split('.')
      end
      cls_array
    end
    def paragraph(line, cls_array)
      if line =~/^(「|（)/ # TODO: should be plaggable
        cls_array << 'noindent'
      end
      "<p#{class_string(cls_array)}>#{line}</p>\n"
    end

    def process_line(line, syntax_handler)
      line =~ /^(\w+?)((?:\.\w*?)*):(.*?)$/
      cmd, cls, text = $1, class_array($2), $3
      if !cmd.nil? && syntax_handler.respond_to?(cmd.to_sym)
        syntax_handler.send(cmd, cls, "#{text}")
      else
        paragraph(line, cls)
      end
    end
  end
end
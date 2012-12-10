# -*- encoding: utf-8 -*-
module ArtiMark
  module BaseParser
    include CommandParser
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
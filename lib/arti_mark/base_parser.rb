# -*- encoding: utf-8 -*-
module ArtiMark
  module BaseParser
    include CommandLexer
    def paragraph(line, cls_array = [])
      if line =~/^(「|（)/ # TODO: should be plaggable
        cls_array << 'noindent'
      end
      "<p#{class_string(cls_array)}>#{line}</p>\n"
    end

    def process_line(line, syntax_handler)
      lexed = lex_line_command(line)
      if !lexed[:cmd].nil? && syntax_handler.respond_to?(lexed[:cmd].to_sym)
        syntax_handler.send(lexed[:cmd], lexed[:cls], lexed[:param], lexed[:text])
      else
        paragraph(line)
      end
    end
  end
end
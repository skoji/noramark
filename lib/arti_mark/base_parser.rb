# -*- encoding: utf-8 -*-
module ArtiMark
  module BaseParser
    include CommandLexer

    def paragraph(line, syntax, cls_array = [])
      if line =~/^(「|（)/ # TODO: should be plaggable
        cls_array << 'noindent'
      end
      "<p#{class_string(cls_array)}>#{line}</p>\n"
    end

    def process_line(line, syntax)
      line = replace_inline_commands(line, syntax)
      lexed = lex_line_command(line)
      if !lexed[:cmd].nil? && syntax.linecommand_handler.respond_to?(lexed[:cmd].to_sym)
        syntax.linecommand_handler.send(lexed[:cmd], lexed[:cls], lexed[:param], lexed[:text])
      else
        paragraph(line, syntax)
      end
    end
  end
end
# -*- encoding: utf-8 -*-
module ArtiMark
  module BaseParser
    include CommandLexer
    # should be in CommandLexer? 
    def replace_inline_commands(line, syntax_handler)
      line.gsub(/:(\w+?)((?:\.\w+?)*)(?:\((.+?)\))?\s*{(.*?)}:/) {
        |matched|
        cmd, cls, param, text = $1, class_array($2), param_array($3), $4
        if syntax_handler.inline_handler.respond_to?(cmd)
          syntax_handler.inline_handler.send(cmd, cls, param, text)
        else
          matched
        end
      }
    end

    def paragraph(line, syntax_handler, cls_array = [])
      line = replace_inline_commands(line, syntax_handler)
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
        paragraph(line, syntax_handler)
      end
    end
  end
end
# -*- encoding: utf-8 -*-
module ArtiMark
  module CommandLexer
    def escape_html(string)
      string.to_s.gsub("&", "&amp;").
        gsub("<", "&lt;").
        gsub(">", "&gt;").
        gsub('"', "&quot;")
    end

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

    def param_parse(param_part)
      r = []
      named = {}
      if !param_part.nil? && param_part.size > 0
        r = param_part.split(',')
      end
      r.each {
        |param|
        splitted = param.split(':', 2)
        if (splitted.size == 2)
          named[splitted[0].strip.to_sym] = splitted[1]
        end
      }
      return r, named
    end

    def lex_line_command(line)
      line =~ /^([\w\*;]+?)((?:\.[A-Za-z0-9_\-]+?)*)(?:\((.+?)\))?\s*:(.*?)$/
      all_params, named_params = param_parse($3)
      return { :cmd => $1, :cls => class_array($2), :params => all_params, :named_params => named_params, :text => $4 }
    end

    def lex_block_command(line)
      line =~ /^(\w+?)((?:\.[A-Za-z0-9_\-]+?)*)(?:\((.+?)\))?\s*(?:{(---)?)\s*$/
      not_named, named = param_parse($3)
      return { :cmd => $1, :cls => class_array($2), :params => not_named, :named_params => named, :delimiter => $4||''}
    end

    def replace_inline_commands(line, syntax, context)
      line.gsub(/\[(\w+?)((?:\.[A-Za-z0-9_\-]+?)*)(?:\((.+?)\))?\s*{(.*?)}\]/) {
        |matched|
        not_named, named = param_parse($3)        
        lexed = {:cmd => $1, :cls => class_array($2), :params => not_named, :named_params => named, :text => $4 }
        if !lexed[:cmd].nil? 
          syntax.inline_handler.send(lexed[:cmd], lexed, context)
        else
          matched
        end
      }
    end

  end
end

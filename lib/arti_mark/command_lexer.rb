# -*- encoding: utf-8 -*-
module ArtiMark
  module CommandLexer
    def escape_html(string)
      string.to_s.gsub("&", "&amp;").
        gsub("<", "&lt;").
        gsub(">", "&gt;").
        gsub('"', "&quot;")
    end

    def attr_string(the_array, attr_name) 
      if the_array.size == 0
        ''
      else
        " #{attr_name}='#{the_array.join(' ')}'"
      end
    end

    def class_string(cls_array)
      attr_string(cls_array, 'class')
    end

    def ids_string(ids_array)
      attr_string(ids_array, 'id')
    end
    def attr_array(part, separator=".") 
      the_array = []
      if !part.nil? && part.size > 0
        the_array = part[1..-1].split(separator)
      end
      the_array
    end
    def id_array(id_part)
      attr_array(id_part, '#')
    end

    def class_array(cls_part)
      attr_array(cls_part, '.')
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
      line =~ /^([\w\*;]+?)((?:\#[A-Za-z0-9_\-]+?)*)((?:\.[A-Za-z0-9_\-]+?)*)(?:\((.+?)\))?\s*:(.*?)$/
      all_params, named_params = param_parse($4)
      return { :cmd => $1, :ids => id_array($2), :cls => class_array($3), :params => all_params, :named_params => named_params, :text => $5 }
    end

    def lex_block_command(line)
      line =~ /^(\w+?)((?:\#[A-Za-z0-9_\-]+?)*)((?:\.[A-Za-z0-9_\-]+?)*)(?:\((.+?)\))?\s*(?:{(---)?)\s*$/
      not_named, named = param_parse($4)
      return { :cmd => $1, :ids => id_array($2), :cls => class_array($3), :params => not_named, :named_params => named, :delimiter => $5||''}
    end

    def replace_inline_commands(line, syntax, context)
      line.gsub(/\[(\w+?)((?:\#[A-Za-z0-9_\-]+?)*)((?:\.[A-Za-z0-9_\-]+?)*)(?:\((.+?)\))?\s*{(.*?)}\]/) {
        |matched|
        not_named, named = param_parse($4)        
        lexed = {:cmd => $1, :ids => id_array($2), :cls => class_array($3), :params => not_named, :named_params => named, :text => $5 }
        if !lexed[:cmd].nil?
          syntax.inline_handler.send(lexed[:cmd], lexed, context)
        else
          matched
        end
      }
    end

  end
end

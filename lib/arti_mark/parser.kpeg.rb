require 'kpeg/compiled_parser'

class ArtiMark::Parser < KPeg::CompiledParser
  # :stopdoc:

  # - = (" " | "\\v" | "\\t")*
  def __hyphen_
    while true

      _save1 = self.pos
      while true # choice
        _tmp = match_string(" ")
        break if _tmp
        self.pos = _save1
        _tmp = match_string("\\v")
        break if _tmp
        self.pos = _save1
        _tmp = match_string("\\t")
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      break unless _tmp
    end
    _tmp = true
    set_failed_rule :__hyphen_ unless _tmp
    return _tmp
  end

  # nl = /\r?\n/
  def _nl
    _tmp = scan(/\A(?-mix:\r?\n)/)
    set_failed_rule :_nl unless _tmp
    return _tmp
  end

  # nls = nl+
  def _nls
    _save = self.pos
    _tmp = apply(:_nl)
    if _tmp
      while true
        _tmp = apply(:_nl)
        break unless _tmp
      end
      _tmp = true
    else
      self.pos = _save
    end
    set_failed_rule :_nls unless _tmp
    return _tmp
  end

  # lh = /^/
  def _lh
    _tmp = scan(/\A(?-mix:^)/)
    set_failed_rule :_lh unless _tmp
    return _tmp
  end

  # le = (nl | /$/)
  def _le

    _save = self.pos
    while true # choice
      _tmp = apply(:_nl)
      break if _tmp
      self.pos = _save
      _tmp = scan(/\A(?-mix:$)/)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_le unless _tmp
    return _tmp
  end

  # word = < /[\w0-9]/ ("-" | /[\w0-9]/)* > { text }
  def _word

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = scan(/\A(?-mix:[\w0-9])/)
        unless _tmp
          self.pos = _save1
          break
        end
        while true

          _save3 = self.pos
          while true # choice
            _tmp = match_string("-")
            break if _tmp
            self.pos = _save3
            _tmp = scan(/\A(?-mix:[\w0-9])/)
            break if _tmp
            self.pos = _save3
            break
          end # end choice

          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_word unless _tmp
    return _tmp
  end

  # num = < [0-9]+ > { text.to_i }
  def _num

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _save1 = self.pos
      _save2 = self.pos
      _tmp = get_byte
      if _tmp
        unless _tmp >= 48 and _tmp <= 57
          self.pos = _save2
          _tmp = nil
        end
      end
      if _tmp
        while true
          _save3 = self.pos
          _tmp = get_byte
          if _tmp
            unless _tmp >= 48 and _tmp <= 57
              self.pos = _save3
              _tmp = nil
            end
          end
          break unless _tmp
        end
        _tmp = true
      else
        self.pos = _save1
      end
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text.to_i ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_num unless _tmp
    return _tmp
  end

  # classname = "." word:classname { classname }
  def _classname

    _save = self.pos
    while true # sequence
      _tmp = match_string(".")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_word)
      classname = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  classname ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_classname unless _tmp
    return _tmp
  end

  # classnames = classname*:classnames { classnames }
  def _classnames

    _save = self.pos
    while true # sequence
      _ary = []
      while true
        _tmp = apply(:_classname)
        _ary << @result if _tmp
        break unless _tmp
      end
      _tmp = true
      @result = _ary
      classnames = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  classnames ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_classnames unless _tmp
    return _tmp
  end

  # idname = "#" word:idname { idname }
  def _idname

    _save = self.pos
    while true # sequence
      _tmp = match_string("#")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_word)
      idname = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  idname ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_idname unless _tmp
    return _tmp
  end

  # idnames = idname*:idnames { idnames }
  def _idnames

    _save = self.pos
    while true # sequence
      _ary = []
      while true
        _tmp = apply(:_idname)
        _ary << @result if _tmp
        break unless _tmp
      end
      _tmp = true
      @result = _ary
      idnames = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  idnames ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_idnames unless _tmp
    return _tmp
  end

  # commandname = word:name idnames?:idnames classnames?:classes { {:name => name, :ids => idnames, :classes => classes} }
  def _commandname

    _save = self.pos
    while true # sequence
      _tmp = apply(:_word)
      name = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_idnames)
      @result = nil unless _tmp
      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      idnames = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save2 = self.pos
      _tmp = apply(:_classnames)
      @result = nil unless _tmp
      unless _tmp
        _tmp = true
        self.pos = _save2
      end
      classes = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  {:name => name, :ids => idnames, :classes => classes} ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_commandname unless _tmp
    return _tmp
  end

  # parameter = < (/[^,)]/* | "\"" /[^"]/* "\"" | "'" /[^']/* "'") > { text }
  def _parameter

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # choice
        while true
          _tmp = scan(/\A(?-mix:[^,)])/)
          break unless _tmp
        end
        _tmp = true
        break if _tmp
        self.pos = _save1

        _save3 = self.pos
        while true # sequence
          _tmp = match_string("\"")
          unless _tmp
            self.pos = _save3
            break
          end
          while true
            _tmp = scan(/\A(?-mix:[^"])/)
            break unless _tmp
          end
          _tmp = true
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = match_string("\"")
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        break if _tmp
        self.pos = _save1

        _save5 = self.pos
        while true # sequence
          _tmp = match_string("'")
          unless _tmp
            self.pos = _save5
            break
          end
          while true
            _tmp = scan(/\A(?-mix:[^'])/)
            break unless _tmp
          end
          _tmp = true
          unless _tmp
            self.pos = _save5
            break
          end
          _tmp = match_string("'")
          unless _tmp
            self.pos = _save5
          end
          break
        end # end sequence

        break if _tmp
        self.pos = _save1
        break
      end # end choice

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_parameter unless _tmp
    return _tmp
  end

  # parameters = < parameter ("," parameter)* > { text }
  def _parameters

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_parameter)
        unless _tmp
          self.pos = _save1
          break
        end
        while true

          _save3 = self.pos
          while true # sequence
            _tmp = match_string(",")
            unless _tmp
              self.pos = _save3
              break
            end
            _tmp = apply(:_parameter)
            unless _tmp
              self.pos = _save3
            end
            break
          end # end sequence

          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_parameters unless _tmp
    return _tmp
  end

  # command = commandname:commandname ("(" - parameters:arg - ")")? { arg ||= ''; commandname.merge({ :args => arg.split(',') }) }
  def _command

    _save = self.pos
    while true # sequence
      _tmp = apply(:_commandname)
      commandname = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos

      _save2 = self.pos
      while true # sequence
        _tmp = match_string("(")
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_parameters)
        arg = @result
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = match_string(")")
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  arg ||= ''; commandname.merge({ :args => arg.split(',') }) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_command unless _tmp
    return _tmp
  end

  # implicit_paragraph = < (!paragraph_delimiter documentline):paragraph > { create_item(:paragraph, nil, paragraph, raw: text) }
  def _implicit_paragraph

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _save2 = self.pos
        _tmp = apply(:_paragraph_delimiter)
        _tmp = _tmp ? nil : true
        self.pos = _save2
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_documentline)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      paragraph = @result
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  create_item(:paragraph, nil, paragraph, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_implicit_paragraph unless _tmp
    return _tmp
  end

  # paragraph = (explicit_paragraph | implicit_paragraph)
  def _paragraph

    _save = self.pos
    while true # choice
      _tmp = apply(:_explicit_paragraph)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_implicit_paragraph)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_paragraph unless _tmp
    return _tmp
  end

  # paragraph_group = < (paragraph nl | paragraph)+:paragraphs nl* > { create_item(:paragraph_group, nil, paragraphs, raw: text) }
  def _paragraph_group

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _save2 = self.pos
        _ary = []

        _save3 = self.pos
        while true # choice

          _save4 = self.pos
          while true # sequence
            _tmp = apply(:_paragraph)
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_nl)
            unless _tmp
              self.pos = _save4
            end
            break
          end # end sequence

          break if _tmp
          self.pos = _save3
          _tmp = apply(:_paragraph)
          break if _tmp
          self.pos = _save3
          break
        end # end choice

        if _tmp
          _ary << @result
          while true

            _save5 = self.pos
            while true # choice

              _save6 = self.pos
              while true # sequence
                _tmp = apply(:_paragraph)
                unless _tmp
                  self.pos = _save6
                  break
                end
                _tmp = apply(:_nl)
                unless _tmp
                  self.pos = _save6
                end
                break
              end # end sequence

              break if _tmp
              self.pos = _save5
              _tmp = apply(:_paragraph)
              break if _tmp
              self.pos = _save5
              break
            end # end choice

            _ary << @result if _tmp
            break unless _tmp
          end
          _tmp = true
          @result = _ary
        else
          self.pos = _save2
        end
        paragraphs = @result
        unless _tmp
          self.pos = _save1
          break
        end
        while true
          _tmp = apply(:_nl)
          break unless _tmp
        end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  create_item(:paragraph_group, nil, paragraphs, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_paragraph_group unless _tmp
    return _tmp
  end

  # blockhead = lh - command:command - "{" - le { command }
  def _blockhead

    _save = self.pos
    while true # sequence
      _tmp = apply(:_lh)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_command)
      command = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("{")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_le)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  command ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_blockhead unless _tmp
    return _tmp
  end

  # blockend = lh - "}" - le
  def _blockend

    _save = self.pos
    while true # sequence
      _tmp = apply(:_lh)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("}")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_le)
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_blockend unless _tmp
    return _tmp
  end

  # blockbody = (!blockend block)+:body { body }
  def _blockbody

    _save = self.pos
    while true # sequence
      _save1 = self.pos
      _ary = []

      _save2 = self.pos
      while true # sequence
        _save3 = self.pos
        _tmp = apply(:_blockend)
        _tmp = _tmp ? nil : true
        self.pos = _save3
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_block)
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      if _tmp
        _ary << @result
        while true

          _save4 = self.pos
          while true # sequence
            _save5 = self.pos
            _tmp = apply(:_blockend)
            _tmp = _tmp ? nil : true
            self.pos = _save5
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_block)
            unless _tmp
              self.pos = _save4
            end
            break
          end # end sequence

          _ary << @result if _tmp
          break unless _tmp
        end
        _tmp = true
        @result = _ary
      else
        self.pos = _save1
      end
      body = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  body ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_blockbody unless _tmp
    return _tmp
  end

  # explicit_block = < blockhead:head blockbody:body blockend > { create_item(:block, head, body, raw: text) }
  def _explicit_block

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_blockhead)
        head = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_blockbody)
        body = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_blockend)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  create_item(:block, head, body, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_explicit_block unless _tmp
    return _tmp
  end

  # inline = < "[" command:command "{" documentcontent_except('}'):content "}" "]" > { create_item(:inline, command, content, raw: text) }
  def _inline

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = match_string("[")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_command)
        command = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("{")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply_with_args(:_documentcontent_except, '}')
        content = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("}")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("]")
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  create_item(:inline, command, content, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_inline unless _tmp
    return _tmp
  end

  # newpage = line_command:item &{ item[:name] == 'newpage' }
  def _newpage

    _save = self.pos
    while true # sequence
      _tmp = apply(:_line_command)
      item = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = begin;  item[:name] == 'newpage' ; end
      self.pos = _save1
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_newpage unless _tmp
    return _tmp
  end

  # explicit_paragraph_command = command:command &{ command[:name] == 'p' }
  def _explicit_paragraph_command

    _save = self.pos
    while true # sequence
      _tmp = apply(:_command)
      command = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = begin;  command[:name] == 'p' ; end
      self.pos = _save1
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_explicit_paragraph_command unless _tmp
    return _tmp
  end

  # explicit_paragraph = < lh - explicit_paragraph_command:command ":" documentcontent?:content le > { create_item(:paragraph, command, content, raw:text) }
  def _explicit_paragraph

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_lh)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_explicit_paragraph_command)
        command = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(":")
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_documentcontent)
        @result = nil unless _tmp
        unless _tmp
          _tmp = true
          self.pos = _save2
        end
        content = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_le)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  create_item(:paragraph, command, content, raw:text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_explicit_paragraph unless _tmp
    return _tmp
  end

  # unordered_list = < unordered_item+:items > { create_item(:ul, nil, items, raw: text) }
  def _unordered_list

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _save1 = self.pos
      _ary = []
      _tmp = apply(:_unordered_item)
      if _tmp
        _ary << @result
        while true
          _tmp = apply(:_unordered_item)
          _ary << @result if _tmp
          break unless _tmp
        end
        _tmp = true
        @result = _ary
      else
        self.pos = _save1
      end
      items = @result
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  create_item(:ul, nil, items, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_unordered_list unless _tmp
    return _tmp
  end

  # unordered_item = lh "*:" documentcontent:content le { content }
  def _unordered_item

    _save = self.pos
    while true # sequence
      _tmp = apply(:_lh)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("*:")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_documentcontent)
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_le)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  content ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_unordered_item unless _tmp
    return _tmp
  end

  # ordered_list = < ordered_item+:items > { create_item(:ol, nil, items, raw: text) }
  def _ordered_list

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _save1 = self.pos
      _ary = []
      _tmp = apply(:_ordered_item)
      if _tmp
        _ary << @result
        while true
          _tmp = apply(:_ordered_item)
          _ary << @result if _tmp
          break unless _tmp
        end
        _tmp = true
        @result = _ary
      else
        self.pos = _save1
      end
      items = @result
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  create_item(:ol, nil, items, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_ordered_list unless _tmp
    return _tmp
  end

  # ordered_item = lh num ":" documentcontent:content le { content }
  def _ordered_item

    _save = self.pos
    while true # sequence
      _tmp = apply(:_lh)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_num)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(":")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_documentcontent)
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_le)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  content ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_ordered_item unless _tmp
    return _tmp
  end

  # items_list = (unordered_list | ordered_list)
  def _items_list

    _save = self.pos
    while true # choice
      _tmp = apply(:_unordered_list)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_ordered_list)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_items_list unless _tmp
    return _tmp
  end

  # line_command = < lh - (!explicit_paragraph_command command):command ":" documentcontent?:content le > { create_item(:line_command, command, content, raw: text) }
  def _line_command

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_lh)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end

        _save2 = self.pos
        while true # sequence
          _save3 = self.pos
          _tmp = apply(:_explicit_paragraph_command)
          _tmp = _tmp ? nil : true
          self.pos = _save3
          unless _tmp
            self.pos = _save2
            break
          end
          _tmp = apply(:_command)
          unless _tmp
            self.pos = _save2
          end
          break
        end # end sequence

        command = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(":")
        unless _tmp
          self.pos = _save1
          break
        end
        _save4 = self.pos
        _tmp = apply(:_documentcontent)
        @result = nil unless _tmp
        unless _tmp
          _tmp = true
          self.pos = _save4
        end
        content = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_le)
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  create_item(:line_command, command, content, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_line_command unless _tmp
    return _tmp
  end

  # block = (line_command | explicit_block | items_list | paragraph_group)
  def _block

    _save = self.pos
    while true # choice
      _tmp = apply(:_line_command)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_explicit_block)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_items_list)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_paragraph_group)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_block unless _tmp
    return _tmp
  end

  # block_delimiter = (blockhead | blockend | newpage)
  def _block_delimiter

    _save = self.pos
    while true # choice
      _tmp = apply(:_blockhead)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_blockend)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_newpage)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_block_delimiter unless _tmp
    return _tmp
  end

  # paragraph_delimiter = (block | block_delimiter)
  def _paragraph_delimiter

    _save = self.pos
    while true # choice
      _tmp = apply(:_block)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_block_delimiter)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_paragraph_delimiter unless _tmp
    return _tmp
  end

  # char = < /[[:print:]]/ > { text }
  def _char

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = scan(/\A(?-mix:[[:print:]])/)
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_char unless _tmp
    return _tmp
  end

  # charstring = < char* > { text }
  def _charstring

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      while true
        _tmp = apply(:_char)
        break unless _tmp
      end
      _tmp = true
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_charstring unless _tmp
    return _tmp
  end

  # char_except = char:c &{ c != e }
  def _char_except(e)

    _save = self.pos
    while true # sequence
      _tmp = apply(:_char)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = begin;  c != e ; end
      self.pos = _save1
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_char_except unless _tmp
    return _tmp
  end

  # charstring_except = < char_except(e)* > { text }
  def _charstring_except(e)

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      while true
        _tmp = apply_with_args(:_char_except, e)
        break unless _tmp
      end
      _tmp = true
      if _tmp
        text = get_text(_text_start)
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  text ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_charstring_except unless _tmp
    return _tmp
  end

  # documentcontent_except = (inline | !inline char_except(e))+:content {parse_text(content)}
  def _documentcontent_except(e)

    _save = self.pos
    while true # sequence
      _save1 = self.pos
      _ary = []

      _save2 = self.pos
      while true # choice
        _tmp = apply(:_inline)
        break if _tmp
        self.pos = _save2

        _save3 = self.pos
        while true # sequence
          _save4 = self.pos
          _tmp = apply(:_inline)
          _tmp = _tmp ? nil : true
          self.pos = _save4
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply_with_args(:_char_except, e)
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        break if _tmp
        self.pos = _save2
        break
      end # end choice

      if _tmp
        _ary << @result
        while true

          _save5 = self.pos
          while true # choice
            _tmp = apply(:_inline)
            break if _tmp
            self.pos = _save5

            _save6 = self.pos
            while true # sequence
              _save7 = self.pos
              _tmp = apply(:_inline)
              _tmp = _tmp ? nil : true
              self.pos = _save7
              unless _tmp
                self.pos = _save6
                break
              end
              _tmp = apply_with_args(:_char_except, e)
              unless _tmp
                self.pos = _save6
              end
              break
            end # end sequence

            break if _tmp
            self.pos = _save5
            break
          end # end choice

          _ary << @result if _tmp
          break unless _tmp
        end
        _tmp = true
        @result = _ary
      else
        self.pos = _save1
      end
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; parse_text(content); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_documentcontent_except unless _tmp
    return _tmp
  end

  # documentcontent = (inline | !inline char)+:content {parse_text(content)}
  def _documentcontent

    _save = self.pos
    while true # sequence
      _save1 = self.pos
      _ary = []

      _save2 = self.pos
      while true # choice
        _tmp = apply(:_inline)
        break if _tmp
        self.pos = _save2

        _save3 = self.pos
        while true # sequence
          _save4 = self.pos
          _tmp = apply(:_inline)
          _tmp = _tmp ? nil : true
          self.pos = _save4
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:_char)
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        break if _tmp
        self.pos = _save2
        break
      end # end choice

      if _tmp
        _ary << @result
        while true

          _save5 = self.pos
          while true # choice
            _tmp = apply(:_inline)
            break if _tmp
            self.pos = _save5

            _save6 = self.pos
            while true # sequence
              _save7 = self.pos
              _tmp = apply(:_inline)
              _tmp = _tmp ? nil : true
              self.pos = _save7
              unless _tmp
                self.pos = _save6
                break
              end
              _tmp = apply(:_char)
              unless _tmp
                self.pos = _save6
              end
              break
            end # end sequence

            break if _tmp
            self.pos = _save5
            break
          end # end choice

          _ary << @result if _tmp
          break unless _tmp
        end
        _tmp = true
        @result = _ary
      else
        self.pos = _save1
      end
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; parse_text(content); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_documentcontent unless _tmp
    return _tmp
  end

  # documentline = lh documentcontent:content /$/ { content }
  def _documentline

    _save = self.pos
    while true # sequence
      _tmp = apply(:_lh)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_documentcontent)
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = scan(/\A(?-mix:$)/)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  content ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_documentline unless _tmp
    return _tmp
  end

  # root = block*:blocks { blocks }
  def _root

    _save = self.pos
    while true # sequence
      _ary = []
      while true
        _tmp = apply(:_block)
        _ary << @result if _tmp
        break unless _tmp
      end
      _tmp = true
      @result = _ary
      blocks = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  blocks ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_root unless _tmp
    return _tmp
  end

  Rules = {}
  Rules[:__hyphen_] = rule_info("-", "(\" \" | \"\\\\v\" | \"\\\\t\")*")
  Rules[:_nl] = rule_info("nl", "/\\r?\\n/")
  Rules[:_nls] = rule_info("nls", "nl+")
  Rules[:_lh] = rule_info("lh", "/^/")
  Rules[:_le] = rule_info("le", "(nl | /$/)")
  Rules[:_word] = rule_info("word", "< /[\\w0-9]/ (\"-\" | /[\\w0-9]/)* > { text }")
  Rules[:_num] = rule_info("num", "< [0-9]+ > { text.to_i }")
  Rules[:_classname] = rule_info("classname", "\".\" word:classname { classname }")
  Rules[:_classnames] = rule_info("classnames", "classname*:classnames { classnames }")
  Rules[:_idname] = rule_info("idname", "\"\#\" word:idname { idname }")
  Rules[:_idnames] = rule_info("idnames", "idname*:idnames { idnames }")
  Rules[:_commandname] = rule_info("commandname", "word:name idnames?:idnames classnames?:classes { {:name => name, :ids => idnames, :classes => classes} }")
  Rules[:_parameter] = rule_info("parameter", "< (/[^,)]/* | \"\\\"\" /[^\"]/* \"\\\"\" | \"'\" /[^']/* \"'\") > { text }")
  Rules[:_parameters] = rule_info("parameters", "< parameter (\",\" parameter)* > { text }")
  Rules[:_command] = rule_info("command", "commandname:commandname (\"(\" - parameters:arg - \")\")? { arg ||= ''; commandname.merge({ :args => arg.split(',') }) }")
  Rules[:_implicit_paragraph] = rule_info("implicit_paragraph", "< (!paragraph_delimiter documentline):paragraph > { create_item(:paragraph, nil, paragraph, raw: text) }")
  Rules[:_paragraph] = rule_info("paragraph", "(explicit_paragraph | implicit_paragraph)")
  Rules[:_paragraph_group] = rule_info("paragraph_group", "< (paragraph nl | paragraph)+:paragraphs nl* > { create_item(:paragraph_group, nil, paragraphs, raw: text) }")
  Rules[:_blockhead] = rule_info("blockhead", "lh - command:command - \"{\" - le { command }")
  Rules[:_blockend] = rule_info("blockend", "lh - \"}\" - le")
  Rules[:_blockbody] = rule_info("blockbody", "(!blockend block)+:body { body }")
  Rules[:_explicit_block] = rule_info("explicit_block", "< blockhead:head blockbody:body blockend > { create_item(:block, head, body, raw: text) }")
  Rules[:_inline] = rule_info("inline", "< \"[\" command:command \"{\" documentcontent_except('}'):content \"}\" \"]\" > { create_item(:inline, command, content, raw: text) }")
  Rules[:_newpage] = rule_info("newpage", "line_command:item &{ item[:name] == 'newpage' }")
  Rules[:_explicit_paragraph_command] = rule_info("explicit_paragraph_command", "command:command &{ command[:name] == 'p' }")
  Rules[:_explicit_paragraph] = rule_info("explicit_paragraph", "< lh - explicit_paragraph_command:command \":\" documentcontent?:content le > { create_item(:paragraph, command, content, raw:text) }")
  Rules[:_unordered_list] = rule_info("unordered_list", "< unordered_item+:items > { create_item(:ul, nil, items, raw: text) }")
  Rules[:_unordered_item] = rule_info("unordered_item", "lh \"*:\" documentcontent:content le { content }")
  Rules[:_ordered_list] = rule_info("ordered_list", "< ordered_item+:items > { create_item(:ol, nil, items, raw: text) }")
  Rules[:_ordered_item] = rule_info("ordered_item", "lh num \":\" documentcontent:content le { content }")
  Rules[:_items_list] = rule_info("items_list", "(unordered_list | ordered_list)")
  Rules[:_line_command] = rule_info("line_command", "< lh - (!explicit_paragraph_command command):command \":\" documentcontent?:content le > { create_item(:line_command, command, content, raw: text) }")
  Rules[:_block] = rule_info("block", "(line_command | explicit_block | items_list | paragraph_group)")
  Rules[:_block_delimiter] = rule_info("block_delimiter", "(blockhead | blockend | newpage)")
  Rules[:_paragraph_delimiter] = rule_info("paragraph_delimiter", "(block | block_delimiter)")
  Rules[:_char] = rule_info("char", "< /[[:print:]]/ > { text }")
  Rules[:_charstring] = rule_info("charstring", "< char* > { text }")
  Rules[:_char_except] = rule_info("char_except", "char:c &{ c != e }")
  Rules[:_charstring_except] = rule_info("charstring_except", "< char_except(e)* > { text }")
  Rules[:_documentcontent_except] = rule_info("documentcontent_except", "(inline | !inline char_except(e))+:content {parse_text(content)}")
  Rules[:_documentcontent] = rule_info("documentcontent", "(inline | !inline char)+:content {parse_text(content)}")
  Rules[:_documentline] = rule_info("documentline", "lh documentcontent:content /$/ { content }")
  Rules[:_root] = rule_info("root", "block*:blocks { blocks }")
  # :startdoc:
end

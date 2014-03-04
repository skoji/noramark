require 'kpeg/compiled_parser'

class NoraMark::Parser < KPeg::CompiledParser
  # :stopdoc:

  # eof = !.
  def _eof
    _save = self.pos
    _tmp = get_byte
    _tmp = _tmp ? nil : true
    self.pos = _save
    set_failed_rule :_eof unless _tmp
    return _tmp
  end

  # space = (" " | "\\t")
  def _space

    _save = self.pos
    while true # choice
      _tmp = match_string(" ")
      break if _tmp
      self.pos = _save
      _tmp = match_string("\\t")
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_space unless _tmp
    return _tmp
  end

  # eof_comment = space* "#" (!eof .)*
  def _eof_comment

    _save = self.pos
    while true # sequence
      while true
        _tmp = apply(:_space)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("#")
      unless _tmp
        self.pos = _save
        break
      end
      while true

        _save3 = self.pos
        while true # sequence
          _save4 = self.pos
          _tmp = apply(:_eof)
          _tmp = _tmp ? nil : true
          self.pos = _save4
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = get_byte
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_eof_comment unless _tmp
    return _tmp
  end

  # comment = space* "#" (!nl .)* nl empty_line*
  def _comment

    _save = self.pos
    while true # sequence
      while true
        _tmp = apply(:_space)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("#")
      unless _tmp
        self.pos = _save
        break
      end
      while true

        _save3 = self.pos
        while true # sequence
          _save4 = self.pos
          _tmp = apply(:_nl)
          _tmp = _tmp ? nil : true
          self.pos = _save4
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = get_byte
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_nl)
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_empty_line)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_comment unless _tmp
    return _tmp
  end

  # - = (space | comment | eof_comment)*
  def __hyphen_
    while true

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_space)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_comment)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_eof_comment)
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

  # empty_line = - nl
  def _empty_line

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_nl)
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_empty_line unless _tmp
    return _tmp
  end

  # nl = /\r?\n/
  def _nl
    _tmp = scan(/\A(?-mix:\r?\n)/)
    set_failed_rule :_nl unless _tmp
    return _tmp
  end

  # le = (nl | eof)
  def _le

    _save = self.pos
    while true # choice
      _tmp = apply(:_nl)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_eof)
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

  # commandname = word:name idnames?:idnames classnames?:classes { {name: name, ids: idnames, classes: classes} }
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
      @result = begin;  {name: name, ids: idnames, classes: classes} ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_commandname unless _tmp
    return _tmp
  end

  # parameter_normal = < /[^,)]/* > { text }
  def _parameter_normal

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      while true
        _tmp = scan(/\A(?-mix:[^,)])/)
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

    set_failed_rule :_parameter_normal unless _tmp
    return _tmp
  end

  # parameter_quoted = "\"" < /[^"]/* > "\"" - &/[,)]/ { text }
  def _parameter_quoted

    _save = self.pos
    while true # sequence
      _tmp = match_string("\"")
      unless _tmp
        self.pos = _save
        break
      end
      _text_start = self.pos
      while true
        _tmp = scan(/\A(?-mix:[^"])/)
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
      _tmp = match_string("\"")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _save2 = self.pos
      _tmp = scan(/\A(?-mix:[,)])/)
      self.pos = _save2
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

    set_failed_rule :_parameter_quoted unless _tmp
    return _tmp
  end

  # parameter_single_quoted = "'" < /[^']/* > "'" - &/[,)]/ { text }
  def _parameter_single_quoted

    _save = self.pos
    while true # sequence
      _tmp = match_string("'")
      unless _tmp
        self.pos = _save
        break
      end
      _text_start = self.pos
      while true
        _tmp = scan(/\A(?-mix:[^'])/)
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
      _tmp = match_string("'")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _save2 = self.pos
      _tmp = scan(/\A(?-mix:[,)])/)
      self.pos = _save2
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

    set_failed_rule :_parameter_single_quoted unless _tmp
    return _tmp
  end

  # parameter = (parameter_quoted | parameter_single_quoted | parameter_normal):value { value }
  def _parameter

    _save = self.pos
    while true # sequence

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_parameter_quoted)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_parameter_single_quoted)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_parameter_normal)
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      value = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  value ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_parameter unless _tmp
    return _tmp
  end

  # parameters = parameter:parameter ("," - parameter)*:rest_parameters { [parameter] + rest_parameters }
  def _parameters

    _save = self.pos
    while true # sequence
      _tmp = apply(:_parameter)
      parameter = @result
      unless _tmp
        self.pos = _save
        break
      end
      _ary = []
      while true

        _save2 = self.pos
        while true # sequence
          _tmp = match_string(",")
          unless _tmp
            self.pos = _save2
            break
          end
          _tmp = apply(:__hyphen_)
          unless _tmp
            self.pos = _save2
            break
          end
          _tmp = apply(:_parameter)
          unless _tmp
            self.pos = _save2
          end
          break
        end # end sequence

        _ary << @result if _tmp
        break unless _tmp
      end
      _tmp = true
      @result = _ary
      rest_parameters = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  [parameter] + rest_parameters ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_parameters unless _tmp
    return _tmp
  end

  # command = commandname:cn ("(" - parameters:args - ")")? { args ||= []; cn.merge({ args: args }) }
  def _command

    _save = self.pos
    while true # sequence
      _tmp = apply(:_commandname)
      cn = @result
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
        args = @result
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
      @result = begin;  args ||= []; cn.merge({ args: args }) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_command unless _tmp
    return _tmp
  end

  # implicit_paragraph = < !paragraph_delimiter - documentline:p - > { create_item(:paragraph, nil, p, raw: text) }
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
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_documentline)
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
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
      @result = begin;  create_item(:paragraph, nil, p, raw: text) ; end
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

  # paragraph_group = < paragraph+:p empty_line* > { create_item(:paragraph_group, nil, p, raw: text) }
  def _paragraph_group

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _save2 = self.pos
        _ary = []
        _tmp = apply(:_paragraph)
        if _tmp
          _ary << @result
          while true
            _tmp = apply(:_paragraph)
            _ary << @result if _tmp
            break unless _tmp
          end
          _tmp = true
          @result = _ary
        else
          self.pos = _save2
        end
        p = @result
        unless _tmp
          self.pos = _save1
          break
        end
        while true
          _tmp = apply(:_empty_line)
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
      @result = begin;  create_item(:paragraph_group, nil, p, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_paragraph_group unless _tmp
    return _tmp
  end

  # blockhead = - command:command - "{" - nl empty_line* { command }
  def _blockhead

    _save = self.pos
    while true # sequence
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
      _tmp = apply(:_nl)
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_empty_line)
        break unless _tmp
      end
      _tmp = true
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

  # blockend = - "}" - le empty_line*
  def _blockend

    _save = self.pos
    while true # sequence
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
        break
      end
      while true
        _tmp = apply(:_empty_line)
        break unless _tmp
      end
      _tmp = true
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

  # explicit_block = < blockhead:head - blockbody:body - blockend > { create_item(:block, head, body, raw: text) }
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
        _tmp = apply(:__hyphen_)
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
        _tmp = apply(:__hyphen_)
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

  # preformatted_command = command:command &{ ['pre', 'code'].include? command[:name] }
  def _preformatted_command

    _save = self.pos
    while true # sequence
      _tmp = apply(:_command)
      command = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = begin;  ['pre', 'code'].include? command[:name] ; end
      self.pos = _save1
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_preformatted_command unless _tmp
    return _tmp
  end

  # preformatted_command_head_simple = - preformatted_command:command - "{" nl { command }
  def _preformatted_command_head_simple

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_preformatted_command)
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
      _tmp = apply(:_nl)
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

    set_failed_rule :_preformatted_command_head_simple unless _tmp
    return _tmp
  end

  # preformatted_command_head_complex = - preformatted_command:command - "{//" nl { command }
  def _preformatted_command_head_complex

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_preformatted_command)
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
      _tmp = match_string("{//")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_nl)
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

    set_failed_rule :_preformatted_command_head_complex unless _tmp
    return _tmp
  end

  # preformatted_command_head = (preformatted_command_head_complex | preformatted_command_head_simple)
  def _preformatted_command_head

    _save = self.pos
    while true # choice
      _tmp = apply(:_preformatted_command_head_complex)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_preformatted_command_head_simple)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_preformatted_command_head unless _tmp
    return _tmp
  end

  # preformat_end_simple = blockend
  def _preformat_end_simple
    _tmp = apply(:_blockend)
    set_failed_rule :_preformat_end_simple unless _tmp
    return _tmp
  end

  # preformat_end_complex = - "//}" - le empty_line*
  def _preformat_end_complex

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("//}")
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
      while true
        _tmp = apply(:_empty_line)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_preformat_end_complex unless _tmp
    return _tmp
  end

  # preformatted_block_simple = < preformatted_command_head_simple:command - (!preformat_end_simple charstring nl)+:content preformat_end_simple > { create_item(:preformatted, command, content, raw: text) }
  def _preformatted_block_simple

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_preformatted_command_head_simple)
        command = @result
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
        _ary = []

        _save3 = self.pos
        while true # sequence
          _save4 = self.pos
          _tmp = apply(:_preformat_end_simple)
          _tmp = _tmp ? nil : true
          self.pos = _save4
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:_charstring)
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:_nl)
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        if _tmp
          _ary << @result
          while true

            _save5 = self.pos
            while true # sequence
              _save6 = self.pos
              _tmp = apply(:_preformat_end_simple)
              _tmp = _tmp ? nil : true
              self.pos = _save6
              unless _tmp
                self.pos = _save5
                break
              end
              _tmp = apply(:_charstring)
              unless _tmp
                self.pos = _save5
                break
              end
              _tmp = apply(:_nl)
              unless _tmp
                self.pos = _save5
              end
              break
            end # end sequence

            _ary << @result if _tmp
            break unless _tmp
          end
          _tmp = true
          @result = _ary
        else
          self.pos = _save2
        end
        content = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_preformat_end_simple)
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
      @result = begin;  create_item(:preformatted, command, content, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_preformatted_block_simple unless _tmp
    return _tmp
  end

  # preformatted_block_complex = < preformatted_command_head_complex:command - (!preformat_end_complex charstring nl)+:content preformat_end_complex > { create_item(:preformatted, command, content, raw: text) }
  def _preformatted_block_complex

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_preformatted_command_head_complex)
        command = @result
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
        _ary = []

        _save3 = self.pos
        while true # sequence
          _save4 = self.pos
          _tmp = apply(:_preformat_end_complex)
          _tmp = _tmp ? nil : true
          self.pos = _save4
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:_charstring)
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:_nl)
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        if _tmp
          _ary << @result
          while true

            _save5 = self.pos
            while true # sequence
              _save6 = self.pos
              _tmp = apply(:_preformat_end_complex)
              _tmp = _tmp ? nil : true
              self.pos = _save6
              unless _tmp
                self.pos = _save5
                break
              end
              _tmp = apply(:_charstring)
              unless _tmp
                self.pos = _save5
                break
              end
              _tmp = apply(:_nl)
              unless _tmp
                self.pos = _save5
              end
              break
            end # end sequence

            _ary << @result if _tmp
            break unless _tmp
          end
          _tmp = true
          @result = _ary
        else
          self.pos = _save2
        end
        content = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_preformat_end_complex)
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
      @result = begin;  create_item(:preformatted, command, content, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_preformatted_block_complex unless _tmp
    return _tmp
  end

  # preformatted_block = (preformatted_block_complex | preformatted_block_simple)
  def _preformatted_block

    _save = self.pos
    while true # choice
      _tmp = apply(:_preformatted_block_complex)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_preformatted_block_simple)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_preformatted_block unless _tmp
    return _tmp
  end

  # inline = (img_inline | common_inline)
  def _inline

    _save = self.pos
    while true # choice
      _tmp = apply(:_img_inline)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_common_inline)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_inline unless _tmp
    return _tmp
  end

  # common_inline = < "[" command:c "{" documentcontent_except('}'):content "}" "]" > { create_item(:inline, c, content, raw: text) }
  def _common_inline

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
        c = @result
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
      @result = begin;  create_item(:inline, c, content, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_common_inline unless _tmp
    return _tmp
  end

  # img_command = command:c &{ c[:name] == 'img' && c[:args].size == 2}
  def _img_command

    _save = self.pos
    while true # sequence
      _tmp = apply(:_command)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = begin;  c[:name] == 'img' && c[:args].size == 2; end
      self.pos = _save1
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_img_command unless _tmp
    return _tmp
  end

  # img_inline = < "[" img_command:c "]" > { create_item(:inline, c, nil, raw: text) }
  def _img_inline

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
        _tmp = apply(:_img_command)
        c = @result
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
      @result = begin;  create_item(:inline, c, nil, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_img_inline unless _tmp
    return _tmp
  end

  # commandname_for_special_line_command = (newpage_command | explicit_paragraph_command)
  def _commandname_for_special_line_command

    _save = self.pos
    while true # choice
      _tmp = apply(:_newpage_command)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_explicit_paragraph_command)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_commandname_for_special_line_command unless _tmp
    return _tmp
  end

  # newpage_command = command:command &{ command[:name] == 'newpage' }
  def _newpage_command

    _save = self.pos
    while true # sequence
      _tmp = apply(:_command)
      command = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = begin;  command[:name] == 'newpage' ; end
      self.pos = _save1
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_newpage_command unless _tmp
    return _tmp
  end

  # newpage = < - newpage_command:c ":" documentcontent?:content - nl > { create_item(:newpage, c, content, raw:text) }
  def _newpage

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_newpage_command)
        c = @result
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
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_nl)
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
      @result = begin;  create_item(:newpage, c, content, raw:text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_newpage unless _tmp
    return _tmp
  end

  # explicit_paragraph_command = command:c &{ c[:name] == 'p' }
  def _explicit_paragraph_command

    _save = self.pos
    while true # sequence
      _tmp = apply(:_command)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = begin;  c[:name] == 'p' ; end
      self.pos = _save1
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_explicit_paragraph_command unless _tmp
    return _tmp
  end

  # explicit_paragraph = < - explicit_paragraph_command:c ":" documentcontent?:content le empty_line* > { create_item(:paragraph, c, content, raw:text) }
  def _explicit_paragraph

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_explicit_paragraph_command)
        c = @result
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
          break
        end
        while true
          _tmp = apply(:_empty_line)
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
      @result = begin;  create_item(:paragraph, c, content, raw:text) ; end
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

  # unordered_item = < "*:" documentcontent:content le > { create_item(:li, nil, content, raw: text) }
  def _unordered_item

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = match_string("*:")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_documentcontent)
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
      @result = begin;  create_item(:li, nil, content, raw: text) ; end
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

  # ordered_item = < num ":" documentcontent:content le > { create_item(:li, nil, content, raw: text) }
  def _ordered_item

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_num)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(":")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_documentcontent)
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
      @result = begin;  create_item(:li, nil, content, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_ordered_item unless _tmp
    return _tmp
  end

  # definition_list = < definition_item+:items > { create_item(:dl, nil, items, raw: text) }
  def _definition_list

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _save1 = self.pos
      _ary = []
      _tmp = apply(:_definition_item)
      if _tmp
        _ary << @result
        while true
          _tmp = apply(:_definition_item)
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
      @result = begin;  create_item(:dl, nil, items, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_definition_list unless _tmp
    return _tmp
  end

  # definition_item = < - ";:" - documentcontent_except(':'):term ":" - documentcontent:definition le > { create_item(:dtdd, {args: [term, definition]}, nil, raw: text) }
  def _definition_item

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(";:")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply_with_args(:_documentcontent_except, ':')
        term = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(":")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_documentcontent)
        definition = @result
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
      @result = begin;  create_item(:dtdd, {args: [term, definition]}, nil, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_definition_item unless _tmp
    return _tmp
  end

  # long_definition_list = < long_definition_item+:items > { create_item(:dl, nil, items, raw: text) }
  def _long_definition_list

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _save1 = self.pos
      _ary = []
      _tmp = apply(:_long_definition_item)
      if _tmp
        _ary << @result
        while true
          _tmp = apply(:_long_definition_item)
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
      @result = begin;  create_item(:dl, nil, items, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_long_definition_list unless _tmp
    return _tmp
  end

  # long_definition_item = < - ";:" - documentcontent_except('{'):term "{" - nl - blockbody:definition - blockend > { create_item(:dtdd, {args: [term, definition]}, nil, raw: text) }
  def _long_definition_item

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(";:")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply_with_args(:_documentcontent_except, '{')
        term = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string("{")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_nl)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_blockbody)
        definition = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
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
      @result = begin;  create_item(:dtdd, {args: [term, definition]}, nil, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_long_definition_item unless _tmp
    return _tmp
  end

  # items_list = (unordered_list | ordered_list | definition_list | long_definition_list)
  def _items_list

    _save = self.pos
    while true # choice
      _tmp = apply(:_unordered_list)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_ordered_list)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_definition_list)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_long_definition_list)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_items_list unless _tmp
    return _tmp
  end

  # line_command = < - !commandname_for_special_line_command command:c ":" documentcontent?:content - le empty_line* > { create_item(:line_command, c, content, raw: text) }
  def _line_command

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _tmp = apply(:_commandname_for_special_line_command)
        _tmp = _tmp ? nil : true
        self.pos = _save2
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_command)
        c = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(":")
        unless _tmp
          self.pos = _save1
          break
        end
        _save3 = self.pos
        _tmp = apply(:_documentcontent)
        @result = nil unless _tmp
        unless _tmp
          _tmp = true
          self.pos = _save3
        end
        content = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_le)
        unless _tmp
          self.pos = _save1
          break
        end
        while true
          _tmp = apply(:_empty_line)
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
      @result = begin;  create_item(:line_command, c, content, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_line_command unless _tmp
    return _tmp
  end

  # line_block = (items_list | line_command)
  def _line_block

    _save = self.pos
    while true # choice
      _tmp = apply(:_items_list)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_line_command)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_line_block unless _tmp
    return _tmp
  end

  # block = (preformatted_block | headed_section | line_block | explicit_block | paragraph_group):block empty_line* {block}
  def _block

    _save = self.pos
    while true # sequence

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_preformatted_block)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_headed_section)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_line_block)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_explicit_block)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_paragraph_group)
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      block = @result
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_empty_line)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; block; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_block unless _tmp
    return _tmp
  end

  # block_delimiter = (blockhead | blockend)
  def _block_delimiter

    _save = self.pos
    while true # choice
      _tmp = apply(:_blockhead)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_blockend)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_block_delimiter unless _tmp
    return _tmp
  end

  # paragraph_delimiter = (block_delimiter | preformatted_command_head | line_block | newpage | headed_start)
  def _paragraph_delimiter

    _save = self.pos
    while true # choice
      _tmp = apply(:_block_delimiter)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_preformatted_command_head)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_line_block)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_newpage)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_headed_start)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_paragraph_delimiter unless _tmp
    return _tmp
  end

  # h_start_mark = < "="+ ":" > &{ text.length - 1 == n }
  def _h_start_mark(n)

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _save2 = self.pos
        _tmp = match_string("=")
        if _tmp
          while true
            _tmp = match_string("=")
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(":")
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
      _save3 = self.pos
      _tmp = begin;  text.length - 1 == n ; end
      self.pos = _save3
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_h_start_mark unless _tmp
    return _tmp
  end

  # h_markup_terminator = - < "="+ ":" > &{ text.length - 1 <= n }
  def _h_markup_terminator(n)

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _save2 = self.pos
        _tmp = match_string("=")
        if _tmp
          while true
            _tmp = match_string("=")
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(":")
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
      _save3 = self.pos
      _tmp = begin;  text.length - 1 <= n ; end
      self.pos = _save3
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_h_markup_terminator unless _tmp
    return _tmp
  end

  # h_start = - h_start_mark(n) charstring:s le { { level: n, heading: s } }
  def _h_start(n)

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_h_start_mark, n)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_charstring)
      s = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_le)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  { level: n, heading: s } ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_h_start unless _tmp
    return _tmp
  end

  # h_section = < h_start(n):h (!h_markup_terminator(n) !eof block)+:content > { create_item(:h_section, h, content, raw: text) }
  def _h_section(n)

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = apply_with_args(:_h_start, n)
        h = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _save2 = self.pos
        _ary = []

        _save3 = self.pos
        while true # sequence
          _save4 = self.pos
          _tmp = apply_with_args(:_h_markup_terminator, n)
          _tmp = _tmp ? nil : true
          self.pos = _save4
          unless _tmp
            self.pos = _save3
            break
          end
          _save5 = self.pos
          _tmp = apply(:_eof)
          _tmp = _tmp ? nil : true
          self.pos = _save5
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:_block)
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

        if _tmp
          _ary << @result
          while true

            _save6 = self.pos
            while true # sequence
              _save7 = self.pos
              _tmp = apply_with_args(:_h_markup_terminator, n)
              _tmp = _tmp ? nil : true
              self.pos = _save7
              unless _tmp
                self.pos = _save6
                break
              end
              _save8 = self.pos
              _tmp = apply(:_eof)
              _tmp = _tmp ? nil : true
              self.pos = _save8
              unless _tmp
                self.pos = _save6
                break
              end
              _tmp = apply(:_block)
              unless _tmp
                self.pos = _save6
              end
              break
            end # end sequence

            _ary << @result if _tmp
            break unless _tmp
          end
          _tmp = true
          @result = _ary
        else
          self.pos = _save2
        end
        content = @result
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
      @result = begin;  create_item(:h_section, h, content, raw: text) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_h_section unless _tmp
    return _tmp
  end

  # headed_start = (h_start(1) | h_start(2) | h_start(3) | h_start(4) | h_start(5) | h_start(6))
  def _headed_start

    _save = self.pos
    while true # choice
      _tmp = apply_with_args(:_h_start, 1)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_h_start, 2)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_h_start, 3)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_h_start, 4)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_h_start, 5)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_h_start, 6)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_headed_start unless _tmp
    return _tmp
  end

  # headed_section = (h_section(1) | h_section(2) | h_section(3) | h_section(4) | h_section(5) | h_section(6))
  def _headed_section

    _save = self.pos
    while true # choice
      _tmp = apply_with_args(:_h_section, 1)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_h_section, 2)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_h_section, 3)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_h_section, 4)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_h_section, 5)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_h_section, 6)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_headed_section unless _tmp
    return _tmp
  end

  # frontmatter_separator = - "---" - nl
  def _frontmatter_separator

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("---")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_nl)
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_frontmatter_separator unless _tmp
    return _tmp
  end

  # frontmatter = frontmatter_separator (!frontmatter_separator charstring nl)+:yaml frontmatter_separator empty_line* { create_frontmatter(yaml) }
  def _frontmatter

    _save = self.pos
    while true # sequence
      _tmp = apply(:_frontmatter_separator)
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _ary = []

      _save2 = self.pos
      while true # sequence
        _save3 = self.pos
        _tmp = apply(:_frontmatter_separator)
        _tmp = _tmp ? nil : true
        self.pos = _save3
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_charstring)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_nl)
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
            _tmp = apply(:_frontmatter_separator)
            _tmp = _tmp ? nil : true
            self.pos = _save5
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_charstring)
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

          _ary << @result if _tmp
          break unless _tmp
        end
        _tmp = true
        @result = _ary
      else
        self.pos = _save1
      end
      yaml = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_frontmatter_separator)
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_empty_line)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  create_frontmatter(yaml) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_frontmatter unless _tmp
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

  # documentline = documentcontent:content le { content }
  def _documentline

    _save = self.pos
    while true # sequence
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

    set_failed_rule :_documentline unless _tmp
    return _tmp
  end

  # page = frontmatter?:frontmatter - (!newpage block)*:blocks { create_item(:page, nil, ([frontmatter] +  blocks).select{ |x| !x.nil?}) }
  def _page

    _save = self.pos
    while true # sequence
      _save1 = self.pos
      _tmp = apply(:_frontmatter)
      @result = nil unless _tmp
      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      frontmatter = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _ary = []
      while true

        _save3 = self.pos
        while true # sequence
          _save4 = self.pos
          _tmp = apply(:_newpage)
          _tmp = _tmp ? nil : true
          self.pos = _save4
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:_block)
          unless _tmp
            self.pos = _save3
          end
          break
        end # end sequence

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
      @result = begin;  create_item(:page, nil, ([frontmatter] +  blocks).select{ |x| !x.nil?}) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_page unless _tmp
    return _tmp
  end

  # newpaged_page = newpage:newpage page:page { page[:children] = page[:children].unshift newpage; page }
  def _newpaged_page

    _save = self.pos
    while true # sequence
      _tmp = apply(:_newpage)
      newpage = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_page)
      page = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  page[:children] = page[:children].unshift newpage; page ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_newpaged_page unless _tmp
    return _tmp
  end

  # root = page:page newpaged_page*:pages - eof_comment? eof { create_item(:document, {name: @document_name} , [ page ] + pages) }
  def _root

    _save = self.pos
    while true # sequence
      _tmp = apply(:_page)
      page = @result
      unless _tmp
        self.pos = _save
        break
      end
      _ary = []
      while true
        _tmp = apply(:_newpaged_page)
        _ary << @result if _tmp
        break unless _tmp
      end
      _tmp = true
      @result = _ary
      pages = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _save2 = self.pos
      _tmp = apply(:_eof_comment)
      unless _tmp
        _tmp = true
        self.pos = _save2
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_eof)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  create_item(:document, {name: @document_name} , [ page ] + pages) ; end
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
  Rules[:_eof] = rule_info("eof", "!.")
  Rules[:_space] = rule_info("space", "(\" \" | \"\\\\t\")")
  Rules[:_eof_comment] = rule_info("eof_comment", "space* \"\#\" (!eof .)*")
  Rules[:_comment] = rule_info("comment", "space* \"\#\" (!nl .)* nl empty_line*")
  Rules[:__hyphen_] = rule_info("-", "(space | comment | eof_comment)*")
  Rules[:_empty_line] = rule_info("empty_line", "- nl")
  Rules[:_nl] = rule_info("nl", "/\\r?\\n/")
  Rules[:_le] = rule_info("le", "(nl | eof)")
  Rules[:_word] = rule_info("word", "< /[\\w0-9]/ (\"-\" | /[\\w0-9]/)* > { text }")
  Rules[:_num] = rule_info("num", "< [0-9]+ > { text.to_i }")
  Rules[:_classname] = rule_info("classname", "\".\" word:classname { classname }")
  Rules[:_classnames] = rule_info("classnames", "classname*:classnames { classnames }")
  Rules[:_idname] = rule_info("idname", "\"\#\" word:idname { idname }")
  Rules[:_idnames] = rule_info("idnames", "idname*:idnames { idnames }")
  Rules[:_commandname] = rule_info("commandname", "word:name idnames?:idnames classnames?:classes { {name: name, ids: idnames, classes: classes} }")
  Rules[:_parameter_normal] = rule_info("parameter_normal", "< /[^,)]/* > { text }")
  Rules[:_parameter_quoted] = rule_info("parameter_quoted", "\"\\\"\" < /[^\"]/* > \"\\\"\" - &/[,)]/ { text }")
  Rules[:_parameter_single_quoted] = rule_info("parameter_single_quoted", "\"'\" < /[^']/* > \"'\" - &/[,)]/ { text }")
  Rules[:_parameter] = rule_info("parameter", "(parameter_quoted | parameter_single_quoted | parameter_normal):value { value }")
  Rules[:_parameters] = rule_info("parameters", "parameter:parameter (\",\" - parameter)*:rest_parameters { [parameter] + rest_parameters }")
  Rules[:_command] = rule_info("command", "commandname:cn (\"(\" - parameters:args - \")\")? { args ||= []; cn.merge({ args: args }) }")
  Rules[:_implicit_paragraph] = rule_info("implicit_paragraph", "< !paragraph_delimiter - documentline:p - > { create_item(:paragraph, nil, p, raw: text) }")
  Rules[:_paragraph] = rule_info("paragraph", "(explicit_paragraph | implicit_paragraph)")
  Rules[:_paragraph_group] = rule_info("paragraph_group", "< paragraph+:p empty_line* > { create_item(:paragraph_group, nil, p, raw: text) }")
  Rules[:_blockhead] = rule_info("blockhead", "- command:command - \"{\" - nl empty_line* { command }")
  Rules[:_blockend] = rule_info("blockend", "- \"}\" - le empty_line*")
  Rules[:_blockbody] = rule_info("blockbody", "(!blockend block)+:body { body }")
  Rules[:_explicit_block] = rule_info("explicit_block", "< blockhead:head - blockbody:body - blockend > { create_item(:block, head, body, raw: text) }")
  Rules[:_preformatted_command] = rule_info("preformatted_command", "command:command &{ ['pre', 'code'].include? command[:name] }")
  Rules[:_preformatted_command_head_simple] = rule_info("preformatted_command_head_simple", "- preformatted_command:command - \"{\" nl { command }")
  Rules[:_preformatted_command_head_complex] = rule_info("preformatted_command_head_complex", "- preformatted_command:command - \"{//\" nl { command }")
  Rules[:_preformatted_command_head] = rule_info("preformatted_command_head", "(preformatted_command_head_complex | preformatted_command_head_simple)")
  Rules[:_preformat_end_simple] = rule_info("preformat_end_simple", "blockend")
  Rules[:_preformat_end_complex] = rule_info("preformat_end_complex", "- \"//}\" - le empty_line*")
  Rules[:_preformatted_block_simple] = rule_info("preformatted_block_simple", "< preformatted_command_head_simple:command - (!preformat_end_simple charstring nl)+:content preformat_end_simple > { create_item(:preformatted, command, content, raw: text) }")
  Rules[:_preformatted_block_complex] = rule_info("preformatted_block_complex", "< preformatted_command_head_complex:command - (!preformat_end_complex charstring nl)+:content preformat_end_complex > { create_item(:preformatted, command, content, raw: text) }")
  Rules[:_preformatted_block] = rule_info("preformatted_block", "(preformatted_block_complex | preformatted_block_simple)")
  Rules[:_inline] = rule_info("inline", "(img_inline | common_inline)")
  Rules[:_common_inline] = rule_info("common_inline", "< \"[\" command:c \"{\" documentcontent_except('}'):content \"}\" \"]\" > { create_item(:inline, c, content, raw: text) }")
  Rules[:_img_command] = rule_info("img_command", "command:c &{ c[:name] == 'img' && c[:args].size == 2}")
  Rules[:_img_inline] = rule_info("img_inline", "< \"[\" img_command:c \"]\" > { create_item(:inline, c, nil, raw: text) }")
  Rules[:_commandname_for_special_line_command] = rule_info("commandname_for_special_line_command", "(newpage_command | explicit_paragraph_command)")
  Rules[:_newpage_command] = rule_info("newpage_command", "command:command &{ command[:name] == 'newpage' }")
  Rules[:_newpage] = rule_info("newpage", "< - newpage_command:c \":\" documentcontent?:content - nl > { create_item(:newpage, c, content, raw:text) }")
  Rules[:_explicit_paragraph_command] = rule_info("explicit_paragraph_command", "command:c &{ c[:name] == 'p' }")
  Rules[:_explicit_paragraph] = rule_info("explicit_paragraph", "< - explicit_paragraph_command:c \":\" documentcontent?:content le empty_line* > { create_item(:paragraph, c, content, raw:text) }")
  Rules[:_unordered_list] = rule_info("unordered_list", "< unordered_item+:items > { create_item(:ul, nil, items, raw: text) }")
  Rules[:_unordered_item] = rule_info("unordered_item", "< \"*:\" documentcontent:content le > { create_item(:li, nil, content, raw: text) }")
  Rules[:_ordered_list] = rule_info("ordered_list", "< ordered_item+:items > { create_item(:ol, nil, items, raw: text) }")
  Rules[:_ordered_item] = rule_info("ordered_item", "< num \":\" documentcontent:content le > { create_item(:li, nil, content, raw: text) }")
  Rules[:_definition_list] = rule_info("definition_list", "< definition_item+:items > { create_item(:dl, nil, items, raw: text) }")
  Rules[:_definition_item] = rule_info("definition_item", "< - \";:\" - documentcontent_except(':'):term \":\" - documentcontent:definition le > { create_item(:dtdd, {args: [term, definition]}, nil, raw: text) }")
  Rules[:_long_definition_list] = rule_info("long_definition_list", "< long_definition_item+:items > { create_item(:dl, nil, items, raw: text) }")
  Rules[:_long_definition_item] = rule_info("long_definition_item", "< - \";:\" - documentcontent_except('{'):term \"{\" - nl - blockbody:definition - blockend > { create_item(:dtdd, {args: [term, definition]}, nil, raw: text) }")
  Rules[:_items_list] = rule_info("items_list", "(unordered_list | ordered_list | definition_list | long_definition_list)")
  Rules[:_line_command] = rule_info("line_command", "< - !commandname_for_special_line_command command:c \":\" documentcontent?:content - le empty_line* > { create_item(:line_command, c, content, raw: text) }")
  Rules[:_line_block] = rule_info("line_block", "(items_list | line_command)")
  Rules[:_block] = rule_info("block", "(preformatted_block | headed_section | line_block | explicit_block | paragraph_group):block empty_line* {block}")
  Rules[:_block_delimiter] = rule_info("block_delimiter", "(blockhead | blockend)")
  Rules[:_paragraph_delimiter] = rule_info("paragraph_delimiter", "(block_delimiter | preformatted_command_head | line_block | newpage | headed_start)")
  Rules[:_h_start_mark] = rule_info("h_start_mark", "< \"=\"+ \":\" > &{ text.length - 1 == n }")
  Rules[:_h_markup_terminator] = rule_info("h_markup_terminator", "- < \"=\"+ \":\" > &{ text.length - 1 <= n }")
  Rules[:_h_start] = rule_info("h_start", "- h_start_mark(n) charstring:s le { { level: n, heading: s } }")
  Rules[:_h_section] = rule_info("h_section", "< h_start(n):h (!h_markup_terminator(n) !eof block)+:content > { create_item(:h_section, h, content, raw: text) }")
  Rules[:_headed_start] = rule_info("headed_start", "(h_start(1) | h_start(2) | h_start(3) | h_start(4) | h_start(5) | h_start(6))")
  Rules[:_headed_section] = rule_info("headed_section", "(h_section(1) | h_section(2) | h_section(3) | h_section(4) | h_section(5) | h_section(6))")
  Rules[:_frontmatter_separator] = rule_info("frontmatter_separator", "- \"---\" - nl")
  Rules[:_frontmatter] = rule_info("frontmatter", "frontmatter_separator (!frontmatter_separator charstring nl)+:yaml frontmatter_separator empty_line* { create_frontmatter(yaml) }")
  Rules[:_char] = rule_info("char", "< /[[:print:]]/ > { text }")
  Rules[:_charstring] = rule_info("charstring", "< char* > { text }")
  Rules[:_char_except] = rule_info("char_except", "char:c &{ c != e }")
  Rules[:_documentcontent_except] = rule_info("documentcontent_except", "(inline | !inline char_except(e))+:content {parse_text(content)}")
  Rules[:_documentcontent] = rule_info("documentcontent", "(inline | !inline char)+:content {parse_text(content)}")
  Rules[:_documentline] = rule_info("documentline", "documentcontent:content le { content }")
  Rules[:_page] = rule_info("page", "frontmatter?:frontmatter - (!newpage block)*:blocks { create_item(:page, nil, ([frontmatter] +  blocks).select{ |x| !x.nil?}) }")
  Rules[:_newpaged_page] = rule_info("newpaged_page", "newpage:newpage page:page { page[:children] = page[:children].unshift newpage; page }")
  Rules[:_root] = rule_info("root", "page:page newpaged_page*:pages - eof_comment? eof { create_item(:document, {name: @document_name} , [ page ] + pages) }")
  # :startdoc:
end

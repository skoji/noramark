require 'kpeg/compiled_parser'

class NoraMark::Parser < KPeg::CompiledParser


   PARAMETER_END = /[,)]/


  # :stopdoc:

  module ::NoraMark
    class Node; end
    class Block < Node
      def initialize(name, ids, classes, parameters, named_parameters, raw_content, line_no)
        @name = name
        @ids = ids
        @classes = classes
        @parameters = parameters
        @named_parameters = named_parameters
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :name
      attr_reader :ids
      attr_reader :classes
      attr_reader :parameters
      attr_reader :named_parameters
      attr_reader :raw_content
      attr_reader :line_no
    end
    class Breakline < Node
      def initialize(line_no)
        @line_no = line_no
      end
      attr_reader :line_no
    end
    class DefinitionList < Node
      def initialize(ids, classes, parameters, named_parameters, raw_content, line_no)
        @ids = ids
        @classes = classes
        @parameters = parameters
        @named_parameters = named_parameters
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :ids
      attr_reader :classes
      attr_reader :parameters
      attr_reader :named_parameters
      attr_reader :raw_content
      attr_reader :line_no
    end
    class DLItem < Node
      def initialize(ids, classes, parameters, named_parameters, raw_content, line_no)
        @ids = ids
        @classes = classes
        @parameters = parameters
        @named_parameters = named_parameters
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :ids
      attr_reader :classes
      attr_reader :parameters
      attr_reader :named_parameters
      attr_reader :raw_content
      attr_reader :line_no
    end
    class Frontmatter < Node
      def initialize(content, line_no)
        @content = content
        @line_no = line_no
      end
      attr_reader :content
      attr_reader :line_no
    end
    class HeadedSection < Node
      def initialize(level, heading, raw_content, line_no)
        @level = level
        @heading = heading
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :level
      attr_reader :heading
      attr_reader :raw_content
      attr_reader :line_no
    end
    class Inline < Node
      def initialize(name, ids, classes, parameters, named_parameters, raw_content, line_no)
        @name = name
        @ids = ids
        @classes = classes
        @parameters = parameters
        @named_parameters = named_parameters
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :name
      attr_reader :ids
      attr_reader :classes
      attr_reader :parameters
      attr_reader :named_parameters
      attr_reader :raw_content
      attr_reader :line_no
    end
    class Newpage < Node
      def initialize(ids, classes, parameters, named_parameters, raw_content, line_no)
        @ids = ids
        @classes = classes
        @parameters = parameters
        @named_parameters = named_parameters
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :ids
      attr_reader :classes
      attr_reader :parameters
      attr_reader :named_parameters
      attr_reader :raw_content
      attr_reader :line_no
    end
    class OlItem < Node
      def initialize(ids, classes, parameters, named_parameters, raw_content, line_no)
        @ids = ids
        @classes = classes
        @parameters = parameters
        @named_parameters = named_parameters
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :ids
      attr_reader :classes
      attr_reader :parameters
      attr_reader :named_parameters
      attr_reader :raw_content
      attr_reader :line_no
    end
    class OrderedList < Node
      def initialize(ids, classes, parameters, named_parameters, raw_content, line_no)
        @ids = ids
        @classes = classes
        @parameters = parameters
        @named_parameters = named_parameters
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :ids
      attr_reader :classes
      attr_reader :parameters
      attr_reader :named_parameters
      attr_reader :raw_content
      attr_reader :line_no
    end
    class Page < Node
      def initialize(raw_content, line_no)
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :raw_content
      attr_reader :line_no
    end
    class Paragraph < Node
      def initialize(ids, classes, parameters, named_parameters, raw_content, line_no)
        @ids = ids
        @classes = classes
        @parameters = parameters
        @named_parameters = named_parameters
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :ids
      attr_reader :classes
      attr_reader :parameters
      attr_reader :named_parameters
      attr_reader :raw_content
      attr_reader :line_no
    end
    class ParagraphGroup < Node
      def initialize(ids, classes, parameters, named_parameters, raw_content, line_no)
        @ids = ids
        @classes = classes
        @parameters = parameters
        @named_parameters = named_parameters
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :ids
      attr_reader :classes
      attr_reader :parameters
      attr_reader :named_parameters
      attr_reader :raw_content
      attr_reader :line_no
    end
    class PreformattedBlock < Node
      def initialize(name, ids, classes, parameters, named_parameters, codelanguage, content, line_no)
        @name = name
        @ids = ids
        @classes = classes
        @parameters = parameters
        @named_parameters = named_parameters
        @codelanguage = codelanguage
        @content = content
        @line_no = line_no
      end
      attr_reader :name
      attr_reader :ids
      attr_reader :classes
      attr_reader :parameters
      attr_reader :named_parameters
      attr_reader :codelanguage
      attr_reader :content
      attr_reader :line_no
    end
    class Root < Node
      def initialize(raw_content)
        @raw_content = raw_content
      end
      attr_reader :raw_content
    end
    class Text < Node
      def initialize(content, line_no)
        @content = content
        @line_no = line_no
      end
      attr_reader :content
      attr_reader :line_no
    end
    class UlItem < Node
      def initialize(ids, classes, parameters, named_parameters, raw_content, line_no)
        @ids = ids
        @classes = classes
        @parameters = parameters
        @named_parameters = named_parameters
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :ids
      attr_reader :classes
      attr_reader :parameters
      attr_reader :named_parameters
      attr_reader :raw_content
      attr_reader :line_no
    end
    class UnorderedList < Node
      def initialize(ids, classes, parameters, named_parameters, raw_content, line_no)
        @ids = ids
        @classes = classes
        @parameters = parameters
        @named_parameters = named_parameters
        @raw_content = raw_content
        @line_no = line_no
      end
      attr_reader :ids
      attr_reader :classes
      attr_reader :parameters
      attr_reader :named_parameters
      attr_reader :raw_content
      attr_reader :line_no
    end
  end
  module ::NoraMarkConstruction
    def block(name, ids, classes, parameters, named_parameters, raw_content, line_no)
      ::NoraMark::Block.new(name, ids, classes, parameters, named_parameters, raw_content, line_no)
    end
    def br(line_no)
      ::NoraMark::Breakline.new(line_no)
    end
    def definition_list(ids, classes, parameters, named_parameters, raw_content, line_no)
      ::NoraMark::DefinitionList.new(ids, classes, parameters, named_parameters, raw_content, line_no)
    end
    def dl_item(ids, classes, parameters, named_parameters, raw_content, line_no)
      ::NoraMark::DLItem.new(ids, classes, parameters, named_parameters, raw_content, line_no)
    end
    def frontmatter(content, line_no)
      ::NoraMark::Frontmatter.new(content, line_no)
    end
    def h_section(level, heading, raw_content, line_no)
      ::NoraMark::HeadedSection.new(level, heading, raw_content, line_no)
    end
    def inline(name, ids, classes, parameters, named_parameters, raw_content, line_no)
      ::NoraMark::Inline.new(name, ids, classes, parameters, named_parameters, raw_content, line_no)
    end
    def newpage(ids, classes, parameters, named_parameters, raw_content, line_no)
      ::NoraMark::Newpage.new(ids, classes, parameters, named_parameters, raw_content, line_no)
    end
    def ol_item(ids, classes, parameters, named_parameters, raw_content, line_no)
      ::NoraMark::OlItem.new(ids, classes, parameters, named_parameters, raw_content, line_no)
    end
    def ordered_list(ids, classes, parameters, named_parameters, raw_content, line_no)
      ::NoraMark::OrderedList.new(ids, classes, parameters, named_parameters, raw_content, line_no)
    end
    def page(raw_content, line_no)
      ::NoraMark::Page.new(raw_content, line_no)
    end
    def paragraph(ids, classes, parameters, named_parameters, raw_content, line_no)
      ::NoraMark::Paragraph.new(ids, classes, parameters, named_parameters, raw_content, line_no)
    end
    def paragraph_group(ids, classes, parameters, named_parameters, raw_content, line_no)
      ::NoraMark::ParagraphGroup.new(ids, classes, parameters, named_parameters, raw_content, line_no)
    end
    def preformatted_block(name, ids, classes, parameters, named_parameters, codelanguage, content, line_no)
      ::NoraMark::PreformattedBlock.new(name, ids, classes, parameters, named_parameters, codelanguage, content, line_no)
    end
    def root(raw_content)
      ::NoraMark::Root.new(raw_content)
    end
    def text(content, line_no)
      ::NoraMark::Text.new(content, line_no)
    end
    def ul_item(ids, classes, parameters, named_parameters, raw_content, line_no)
      ::NoraMark::UlItem.new(ids, classes, parameters, named_parameters, raw_content, line_no)
    end
    def unordered_list(ids, classes, parameters, named_parameters, raw_content, line_no)
      ::NoraMark::UnorderedList.new(ids, classes, parameters, named_parameters, raw_content, line_no)
    end
  end
  include ::NoraMarkConstruction

  # ln = { current_line }
  def _ln
    @result = begin;  current_line ; end
    _tmp = true
    set_failed_rule :_ln unless _tmp
    return _tmp
  end

  # BOM = /\uFEFF/
  def _BOM
    _tmp = scan(/\A(?-mix:\uFEFF)/)
    set_failed_rule :_BOM unless _tmp
    return _tmp
  end

  # Eof = !.
  def _Eof
    _save = self.pos
    _tmp = get_byte
    _tmp = _tmp ? nil : true
    self.pos = _save
    set_failed_rule :_Eof unless _tmp
    return _tmp
  end

  # Space = (" " | "\\t")
  def _Space

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

    set_failed_rule :_Space unless _tmp
    return _tmp
  end

  # - = Space*
  def __hyphen_
    while true
      _tmp = apply(:_Space)
      break unless _tmp
    end
    _tmp = true
    set_failed_rule :__hyphen_ unless _tmp
    return _tmp
  end

  # EofComment = - "//" (!Eof .)*
  def _EofComment

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("//")
      unless _tmp
        self.pos = _save
        break
      end
      while true

        _save2 = self.pos
        while true # sequence
          _save3 = self.pos
          _tmp = apply(:_Eof)
          _tmp = _tmp ? nil : true
          self.pos = _save3
          unless _tmp
            self.pos = _save2
            break
          end
          _tmp = get_byte
          unless _tmp
            self.pos = _save2
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

    set_failed_rule :_EofComment unless _tmp
    return _tmp
  end

  # Comment = - "//" (!Nl .)* Nl EmptyLine*
  def _Comment

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("//")
      unless _tmp
        self.pos = _save
        break
      end
      while true

        _save2 = self.pos
        while true # sequence
          _save3 = self.pos
          _tmp = apply(:_Nl)
          _tmp = _tmp ? nil : true
          self.pos = _save3
          unless _tmp
            self.pos = _save2
            break
          end
          _tmp = get_byte
          unless _tmp
            self.pos = _save2
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
      _tmp = apply(:_Nl)
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_Comment unless _tmp
    return _tmp
  end

  # EmptyLine = /^/ - (Nl | Comment | EofComment)
  def _EmptyLine

    _save = self.pos
    while true # sequence
      _tmp = scan(/\A(?-mix:^)/)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_Nl)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_Comment)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_EofComment)
        break if _tmp
        self.pos = _save1
        break
      end # end choice

      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_EmptyLine unless _tmp
    return _tmp
  end

  # Nl = /\r?\n/
  def _Nl
    _tmp = scan(/\A(?-mix:\r?\n)/)
    set_failed_rule :_Nl unless _tmp
    return _tmp
  end

  # Le = (Nl | Eof)
  def _Le

    _save = self.pos
    while true # choice
      _tmp = apply(:_Nl)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_Eof)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_Le unless _tmp
    return _tmp
  end

  # Word = < /[\w]/ ("-" | /[\w]/)* > { text }
  def _Word

    _save = self.pos
    while true # sequence
      _text_start = self.pos

      _save1 = self.pos
      while true # sequence
        _tmp = scan(/\A(?-mix:[\w])/)
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
            _tmp = scan(/\A(?-mix:[\w])/)
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

    set_failed_rule :_Word unless _tmp
    return _tmp
  end

  # Num = < [0-9]+ > { text.to_i }
  def _Num

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

    set_failed_rule :_Num unless _tmp
    return _tmp
  end

  # ClassName = "." Word:classname { classname }
  def _ClassName

    _save = self.pos
    while true # sequence
      _tmp = match_string(".")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Word)
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

    set_failed_rule :_ClassName unless _tmp
    return _tmp
  end

  # ClassNames = ClassName*:classnames { classnames }
  def _ClassNames

    _save = self.pos
    while true # sequence
      _ary = []
      while true
        _tmp = apply(:_ClassName)
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

    set_failed_rule :_ClassNames unless _tmp
    return _tmp
  end

  # IdName = "#" Word:idname { idname }
  def _IdName

    _save = self.pos
    while true # sequence
      _tmp = match_string("#")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Word)
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

    set_failed_rule :_IdName unless _tmp
    return _tmp
  end

  # IdNames = IdName*:idnames { idnames }
  def _IdNames

    _save = self.pos
    while true # sequence
      _ary = []
      while true
        _tmp = apply(:_IdName)
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

    set_failed_rule :_IdNames unless _tmp
    return _tmp
  end

  # CommandName = Word:name IdNames?:idnames ClassNames?:classes ln:ln { {name: name, ids: idnames, classes: classes, ln:ln } }
  def _CommandName

    _save = self.pos
    while true # sequence
      _tmp = apply(:_Word)
      name = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_IdNames)
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
      _tmp = apply(:_ClassNames)
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
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  {name: name, ids: idnames, classes: classes, ln:ln } ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_CommandName unless _tmp
    return _tmp
  end

  # ParameterNormal = DocumentContentExcept(PARAMETER_END):content { content }
  def _ParameterNormal

    _save = self.pos
    while true # sequence
      _tmp = apply_with_args(:_DocumentContentExcept, PARAMETER_END)
      content = @result
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

    set_failed_rule :_ParameterNormal unless _tmp
    return _tmp
  end

  # ParameterQuoted = "\"" DocumentContentExcept('"'):content "\"" - &/[,)]/ { content }
  def _ParameterQuoted

    _save = self.pos
    while true # sequence
      _tmp = match_string("\"")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_DocumentContentExcept, '"')
      content = @result
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
      _save1 = self.pos
      _tmp = scan(/\A(?-mix:[,)])/)
      self.pos = _save1
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

    set_failed_rule :_ParameterQuoted unless _tmp
    return _tmp
  end

  # ParameterSingleQuoted = "'" DocumentContentExcept("'"):content "'" - &/[,)]/ { content }
  def _ParameterSingleQuoted

    _save = self.pos
    while true # sequence
      _tmp = match_string("'")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_DocumentContentExcept, "'")
      content = @result
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
      _save1 = self.pos
      _tmp = scan(/\A(?-mix:[,)])/)
      self.pos = _save1
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

    set_failed_rule :_ParameterSingleQuoted unless _tmp
    return _tmp
  end

  # Parameter = (ParameterQuoted | ParameterSingleQuoted | ParameterNormal):value { value }
  def _Parameter

    _save = self.pos
    while true # sequence

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_ParameterQuoted)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_ParameterSingleQuoted)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_ParameterNormal)
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

    set_failed_rule :_Parameter unless _tmp
    return _tmp
  end

  # NParameterNormal = < /[^,\]]/* > { text }
  def _NParameterNormal

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      while true
        _tmp = scan(/\A(?-mix:[^,\]])/)
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

    set_failed_rule :_NParameterNormal unless _tmp
    return _tmp
  end

  # NParameterQuoted = "\"" < /[^"]/* > "\"" - &/[,\]]/ { text }
  def _NParameterQuoted

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
      _tmp = scan(/\A(?-mix:[,\]])/)
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

    set_failed_rule :_NParameterQuoted unless _tmp
    return _tmp
  end

  # NParameterSingleQuoted = "'" < /[^']/* > "'" - &/[,\]]/ { text }
  def _NParameterSingleQuoted

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
      _tmp = scan(/\A(?-mix:[,\]])/)
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

    set_failed_rule :_NParameterSingleQuoted unless _tmp
    return _tmp
  end

  # NParameter = (NParameterQuoted | NParameterSingleQuoted | NParameterNormal):value { value }
  def _NParameter

    _save = self.pos
    while true # sequence

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_NParameterQuoted)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_NParameterSingleQuoted)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_NParameterNormal)
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

    set_failed_rule :_NParameter unless _tmp
    return _tmp
  end

  # Parameters = (Parameter:parameter "," - Parameters:parameters { [ parameter ] + parameters } | Parameter:parameter { [ parameter ] })
  def _Parameters

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_Parameter)
        parameter = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(",")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_Parameters)
        parameters = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [ parameter ] + parameters ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_Parameter)
        parameter = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  [ parameter ] ; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_Parameters unless _tmp
    return _tmp
  end

  # NamedParameter = Word:key - ":" - NParameter:parameter { { key.to_sym => parameter } }
  def _NamedParameter

    _save = self.pos
    while true # sequence
      _tmp = apply(:_Word)
      key = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(":")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_NParameter)
      parameter = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  { key.to_sym => parameter } ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_NamedParameter unless _tmp
    return _tmp
  end

  # NamedParameters = (NamedParameter:parameter - "," - NamedParameters:parameters { parameter.merge parameters } | NamedParameter:parameter { parameter })
  def _NamedParameters

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_NamedParameter)
        parameter = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = match_string(",")
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_NamedParameters)
        parameters = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  parameter.merge parameters ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_NamedParameter)
        parameter = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  parameter ; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_NamedParameters unless _tmp
    return _tmp
  end

  # Command = CommandName:cn ("(" - Parameters:args - ")")? ("[" - NamedParameters:named_args - "]")? { cn.merge({ args: args || [] , named_args: named_args || {}}) }
  def _Command

    _save = self.pos
    while true # sequence
      _tmp = apply(:_CommandName)
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
        _tmp = apply(:_Parameters)
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
      _save3 = self.pos

      _save4 = self.pos
      while true # sequence
        _tmp = match_string("[")
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:_NamedParameters)
        named_args = @result
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = match_string("]")
        unless _tmp
          self.pos = _save4
        end
        break
      end # end sequence

      unless _tmp
        _tmp = true
        self.pos = _save3
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  cn.merge({ args: args || [] , named_args: named_args || {}}) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_Command unless _tmp
    return _tmp
  end

  # ImplicitParagraph = - !ParagraphDelimiter Comment* DocumentLine:content ln:ln Comment* EofComment? {paragraph([],[], [], {}, content, ln)}
  def _ImplicitParagraph

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_ParagraphDelimiter)
      _tmp = _tmp ? nil : true
      self.pos = _save1
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_Comment)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_DocumentLine)
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_Comment)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      _save4 = self.pos
      _tmp = apply(:_EofComment)
      unless _tmp
        _tmp = true
        self.pos = _save4
      end
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; paragraph([],[], [], {}, content, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_ImplicitParagraph unless _tmp
    return _tmp
  end

  # ExplicitParagraphCommand = Command:c &{ c[:name] == 'p' }
  def _ExplicitParagraphCommand

    _save = self.pos
    while true # sequence
      _tmp = apply(:_Command)
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

    set_failed_rule :_ExplicitParagraphCommand unless _tmp
    return _tmp
  end

  # ExplicitParagraph = - ExplicitParagraphCommand:c ":" - DocumentContent?:content Le EmptyLine* {paragraph(c[:ids], c[:classes], c[:args], c[:named_args], content, c[:ln])}
  def _ExplicitParagraph

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_ExplicitParagraphCommand)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(":")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_DocumentContent)
      @result = nil unless _tmp
      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Le)
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; paragraph(c[:ids], c[:classes], c[:args], c[:named_args], content, c[:ln]); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_ExplicitParagraph unless _tmp
    return _tmp
  end

  # Paragraph = (ExplicitParagraph | ImplicitParagraph)
  def _Paragraph

    _save = self.pos
    while true # choice
      _tmp = apply(:_ExplicitParagraph)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_ImplicitParagraph)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_Paragraph unless _tmp
    return _tmp
  end

  # ParagraphGroup = ln:ln Paragraph+:p EmptyLine* {paragraph_group([],[],[],{},p, ln)}
  def _ParagraphGroup

    _save = self.pos
    while true # sequence
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _ary = []
      _tmp = apply(:_Paragraph)
      if _tmp
        _ary << @result
        while true
          _tmp = apply(:_Paragraph)
          _ary << @result if _tmp
          break unless _tmp
        end
        _tmp = true
        @result = _ary
      else
        self.pos = _save1
      end
      p = @result
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; paragraph_group([],[],[],{},p, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_ParagraphGroup unless _tmp
    return _tmp
  end

  # BlockHead = Command:command - "{" - Nl EmptyLine* { command }
  def _BlockHead

    _save = self.pos
    while true # sequence
      _tmp = apply(:_Command)
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
      _tmp = apply(:_Nl)
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
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

    set_failed_rule :_BlockHead unless _tmp
    return _tmp
  end

  # BlockEnd = - "}" - Le EmptyLine*
  def _BlockEnd

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
      _tmp = apply(:_Le)
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_BlockEnd unless _tmp
    return _tmp
  end

  # BlockBody = (!BlockEnd Block)+:body { body }
  def _BlockBody

    _save = self.pos
    while true # sequence
      _save1 = self.pos
      _ary = []

      _save2 = self.pos
      while true # sequence
        _save3 = self.pos
        _tmp = apply(:_BlockEnd)
        _tmp = _tmp ? nil : true
        self.pos = _save3
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_Block)
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
            _tmp = apply(:_BlockEnd)
            _tmp = _tmp ? nil : true
            self.pos = _save5
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_Block)
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

    set_failed_rule :_BlockBody unless _tmp
    return _tmp
  end

  # ExplicitBlock = - BlockHead:c - BlockBody:content - BlockEnd {block(c[:name], c[:ids], c[:classes], c[:args], c[:named_args], content,  c[:ln])}
  def _ExplicitBlock

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_BlockHead)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_BlockBody)
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_BlockEnd)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; block(c[:name], c[:ids], c[:classes], c[:args], c[:named_args], content,  c[:ln]); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_ExplicitBlock unless _tmp
    return _tmp
  end

  # PreformattedCommand = Command:command &{ ['pre', 'code'].include? command[:name] }
  def _PreformattedCommand

    _save = self.pos
    while true # sequence
      _tmp = apply(:_Command)
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

    set_failed_rule :_PreformattedCommand unless _tmp
    return _tmp
  end

  # PreformattedCommandHeadSimple = PreformattedCommand:command - "{" - Nl { command }
  def _PreformattedCommandHeadSimple

    _save = self.pos
    while true # sequence
      _tmp = apply(:_PreformattedCommand)
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
      _tmp = apply(:_Nl)
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

    set_failed_rule :_PreformattedCommandHeadSimple unless _tmp
    return _tmp
  end

  # PreformattedCommandHeadComplex = PreformattedCommand:command - "{//" Word?:codelanguage - Nl { command.merge({codelanguage: codelanguage}) }
  def _PreformattedCommandHeadComplex

    _save = self.pos
    while true # sequence
      _tmp = apply(:_PreformattedCommand)
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
      _save1 = self.pos
      _tmp = apply(:_Word)
      @result = nil unless _tmp
      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      codelanguage = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Nl)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  command.merge({codelanguage: codelanguage}) ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_PreformattedCommandHeadComplex unless _tmp
    return _tmp
  end

  # PreformattedFence = - "```" Word?:codelanguage ("(" - Parameters:args - ")")? ("[" - NamedParameters:named_args - "]")? - Nl { {codelanguage: codelanguage,                      args: args || [],                      named_args: named_args || {} } }
  def _PreformattedFence

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("```")
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_Word)
      @result = nil unless _tmp
      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      codelanguage = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save2 = self.pos

      _save3 = self.pos
      while true # sequence
        _tmp = match_string("(")
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:_Parameters)
        args = @result
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save3
          break
        end
        _tmp = match_string(")")
        unless _tmp
          self.pos = _save3
        end
        break
      end # end sequence

      unless _tmp
        _tmp = true
        self.pos = _save2
      end
      unless _tmp
        self.pos = _save
        break
      end
      _save4 = self.pos

      _save5 = self.pos
      while true # sequence
        _tmp = match_string("[")
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:_NamedParameters)
        named_args = @result
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save5
          break
        end
        _tmp = match_string("]")
        unless _tmp
          self.pos = _save5
        end
        break
      end # end sequence

      unless _tmp
        _tmp = true
        self.pos = _save4
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Nl)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  {codelanguage: codelanguage,
                     args: args || [],
                     named_args: named_args || {} } ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_PreformattedFence unless _tmp
    return _tmp
  end

  # PreformattedCommandHead = (PreformattedCommandHeadComplex | PreformattedCommandHeadSimple | PreformattedFence)
  def _PreformattedCommandHead

    _save = self.pos
    while true # choice
      _tmp = apply(:_PreformattedCommandHeadComplex)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_PreformattedCommandHeadSimple)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_PreformattedFence)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_PreformattedCommandHead unless _tmp
    return _tmp
  end

  # PreformatEndSimple = - "}" - Le EmptyLine*
  def _PreformatEndSimple

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
      _tmp = apply(:_Le)
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_PreformatEndSimple unless _tmp
    return _tmp
  end

  # PreformatEndComplex = - "//}" - Le EmptyLine*
  def _PreformatEndComplex

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
      _tmp = apply(:_Le)
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_PreformatEndComplex unless _tmp
    return _tmp
  end

  # PreformattedBlockSimple = - PreformattedCommandHeadSimple:c (!PreformatEndSimple CharString Nl)+:content PreformatEndSimple {preformatted_block(c[:name], c[:ids], c[:classes], c[:args],  c[:named_args], c[:codelanguage], content,  c[:ln])}
  def _PreformattedBlockSimple

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_PreformattedCommandHeadSimple)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _ary = []

      _save2 = self.pos
      while true # sequence
        _save3 = self.pos
        _tmp = apply(:_PreformatEndSimple)
        _tmp = _tmp ? nil : true
        self.pos = _save3
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_CharString)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_Nl)
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
            _tmp = apply(:_PreformatEndSimple)
            _tmp = _tmp ? nil : true
            self.pos = _save5
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_CharString)
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_Nl)
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
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_PreformatEndSimple)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; preformatted_block(c[:name], c[:ids], c[:classes], c[:args],  c[:named_args], c[:codelanguage], content,  c[:ln]); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_PreformattedBlockSimple unless _tmp
    return _tmp
  end

  # PreformattedBlockComplex = - PreformattedCommandHeadComplex:c (!PreformatEndComplex CharString Nl)+:content PreformatEndComplex {preformatted_block(c[:name], c[:ids], c[:classes], c[:args], c[:named_args],  c[:codelanguage], content,  c[:ln])}
  def _PreformattedBlockComplex

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_PreformattedCommandHeadComplex)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _ary = []

      _save2 = self.pos
      while true # sequence
        _save3 = self.pos
        _tmp = apply(:_PreformatEndComplex)
        _tmp = _tmp ? nil : true
        self.pos = _save3
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_CharString)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_Nl)
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
            _tmp = apply(:_PreformatEndComplex)
            _tmp = _tmp ? nil : true
            self.pos = _save5
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_CharString)
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_Nl)
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
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_PreformatEndComplex)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; preformatted_block(c[:name], c[:ids], c[:classes], c[:args], c[:named_args],  c[:codelanguage], content,  c[:ln]); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_PreformattedBlockComplex unless _tmp
    return _tmp
  end

  # PreformattedBlockFence = - ln:ln PreformattedFence:c (!"```" CharString Nl)+:content - "```" - Le EmptyLine* {preformatted_block('code', [], [], c[:args], c[:named_args], c[:codelanguage], content, ln)}
  def _PreformattedBlockFence

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_PreformattedFence)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _ary = []

      _save2 = self.pos
      while true # sequence
        _save3 = self.pos
        _tmp = match_string("```")
        _tmp = _tmp ? nil : true
        self.pos = _save3
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_CharString)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_Nl)
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
            _tmp = match_string("```")
            _tmp = _tmp ? nil : true
            self.pos = _save5
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_CharString)
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_Nl)
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
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("```")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Le)
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; preformatted_block('code', [], [], c[:args], c[:named_args], c[:codelanguage], content, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_PreformattedBlockFence unless _tmp
    return _tmp
  end

  # PreformattedBlock = (PreformattedBlockComplex | PreformattedBlockSimple | PreformattedBlockFence)
  def _PreformattedBlock

    _save = self.pos
    while true # choice
      _tmp = apply(:_PreformattedBlockComplex)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_PreformattedBlockSimple)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_PreformattedBlockFence)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_PreformattedBlock unless _tmp
    return _tmp
  end

  # Inline = (ImgInline | CommonInline)
  def _Inline

    _save = self.pos
    while true # choice
      _tmp = apply(:_ImgInline)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_CommonInline)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_Inline unless _tmp
    return _tmp
  end

  # CommonInline = "[" Command:c "{" - DocumentContentExcept('}'):content "}" "]" {inline(c[:name], c[:ids], c[:classes], c[:args], c[:named_args],  content,  c[:ln])}
  def _CommonInline

    _save = self.pos
    while true # sequence
      _tmp = match_string("[")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Command)
      c = @result
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
      _tmp = apply_with_args(:_DocumentContentExcept, '}')
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("}")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("]")
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; inline(c[:name], c[:ids], c[:classes], c[:args], c[:named_args],  content,  c[:ln]); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_CommonInline unless _tmp
    return _tmp
  end

  # ImgCommand = Command:c &{ c[:name] == 'img' && c[:args].size == 2}
  def _ImgCommand

    _save = self.pos
    while true # sequence
      _tmp = apply(:_Command)
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

    set_failed_rule :_ImgCommand unless _tmp
    return _tmp
  end

  # ImgInline = "[" ImgCommand:c "]" {inline(c[:name], c[:ids], c[:classes], c[:args], c[:named_args],  nil,  c[:ln])}
  def _ImgInline

    _save = self.pos
    while true # sequence
      _tmp = match_string("[")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_ImgCommand)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("]")
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; inline(c[:name], c[:ids], c[:classes], c[:args], c[:named_args],  nil,  c[:ln]); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_ImgInline unless _tmp
    return _tmp
  end

  # CommandNameForSpecialLineCommand = (NewpageCommand | ExplicitParagraphCommand)
  def _CommandNameForSpecialLineCommand

    _save = self.pos
    while true # choice
      _tmp = apply(:_NewpageCommand)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_ExplicitParagraphCommand)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_CommandNameForSpecialLineCommand unless _tmp
    return _tmp
  end

  # NewpageCommand = Command:command &{ command[:name] == 'newpage' }
  def _NewpageCommand

    _save = self.pos
    while true # sequence
      _tmp = apply(:_Command)
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

    set_failed_rule :_NewpageCommand unless _tmp
    return _tmp
  end

  # Newpage = - NewpageCommand:c ":" - DocumentContent?:content - Nl {newpage(c[:ids],c[:classes],c[:args], c[:named_args],  content,  c[:ln])}
  def _Newpage

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_NewpageCommand)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(":")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_DocumentContent)
      @result = nil unless _tmp
      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Nl)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; newpage(c[:ids],c[:classes],c[:args], c[:named_args],  content,  c[:ln]); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_Newpage unless _tmp
    return _tmp
  end

  # UnorderedList = ln:ln UnorderedItem+:items {unordered_list([],[],[],{}, items, ln)}
  def _UnorderedList

    _save = self.pos
    while true # sequence
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _ary = []
      _tmp = apply(:_UnorderedItem)
      if _tmp
        _ary << @result
        while true
          _tmp = apply(:_UnorderedItem)
          _ary << @result if _tmp
          break unless _tmp
        end
        _tmp = true
        @result = _ary
      else
        self.pos = _save1
      end
      items = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; unordered_list([],[],[],{}, items, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_UnorderedList unless _tmp
    return _tmp
  end

  # UnorderedItem = - ln:ln "*" - DocumentContent:content Le {ul_item([], [], [], {}, content, ln)}
  def _UnorderedItem

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string("*")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_DocumentContent)
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Le)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; ul_item([], [], [], {}, content, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_UnorderedItem unless _tmp
    return _tmp
  end

  # OrderedList = ln:ln OrderedItem+:items {ordered_list([],[],[], {}, items, ln)}
  def _OrderedList

    _save = self.pos
    while true # sequence
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _ary = []
      _tmp = apply(:_OrderedItem)
      if _tmp
        _ary << @result
        while true
          _tmp = apply(:_OrderedItem)
          _ary << @result if _tmp
          break unless _tmp
        end
        _tmp = true
        @result = _ary
      else
        self.pos = _save1
      end
      items = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; ordered_list([],[],[], {}, items, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_OrderedList unless _tmp
    return _tmp
  end

  # OrderedItem = - ln:ln Num "." - DocumentContent:content Le {ol_item([], [], [], {}, content, ln)}
  def _OrderedItem

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Num)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(".")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_DocumentContent)
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Le)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; ol_item([], [], [], {}, content, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_OrderedItem unless _tmp
    return _tmp
  end

  # DefinitionList = ln:ln DefinitionItem+:items {definition_list([], [], [], {}, items, ln)}
  def _DefinitionList

    _save = self.pos
    while true # sequence
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _ary = []
      _tmp = apply(:_DefinitionItem)
      if _tmp
        _ary << @result
        while true
          _tmp = apply(:_DefinitionItem)
          _ary << @result if _tmp
          break unless _tmp
        end
        _tmp = true
        @result = _ary
      else
        self.pos = _save1
      end
      items = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; definition_list([], [], [], {}, items, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_DefinitionList unless _tmp
    return _tmp
  end

  # DefinitionItem = - ln:ln - ";:" - DocumentContentExcept(':'):term ":" - DocumentContent:definition Le {dl_item([], [], [term], {}, definition, ln)}
  def _DefinitionItem

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(";:")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_DocumentContentExcept, ':')
      term = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(":")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_DocumentContent)
      definition = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Le)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; dl_item([], [], [term], {}, definition, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_DefinitionItem unless _tmp
    return _tmp
  end

  # LongDefinitionList = ln:ln LongDefinitionItem+:items {definition_list([], [], [], {}, items, ln)}
  def _LongDefinitionList

    _save = self.pos
    while true # sequence
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _ary = []
      _tmp = apply(:_LongDefinitionItem)
      if _tmp
        _ary << @result
        while true
          _tmp = apply(:_LongDefinitionItem)
          _ary << @result if _tmp
          break unless _tmp
        end
        _tmp = true
        @result = _ary
      else
        self.pos = _save1
      end
      items = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; definition_list([], [], [], {}, items, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_LongDefinitionList unless _tmp
    return _tmp
  end

  # LongDefinitionItem = - ln:ln ";:" - DocumentContentExcept('{'):term "{" - Nl - BlockBody:definition - BlockEnd {dl_item([], [], [term], {}, definition, ln)}
  def _LongDefinitionItem

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(";:")
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_DocumentContentExcept, '{')
      term = @result
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
      _tmp = apply(:_Nl)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_BlockBody)
      definition = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_BlockEnd)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; dl_item([], [], [term], {}, definition, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_LongDefinitionItem unless _tmp
    return _tmp
  end

  # ItemsList = (UnorderedList | OrderedList | DefinitionList | LongDefinitionList)
  def _ItemsList

    _save = self.pos
    while true # choice
      _tmp = apply(:_UnorderedList)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_OrderedList)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_DefinitionList)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_LongDefinitionList)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_ItemsList unless _tmp
    return _tmp
  end

  # LineCommand = - !CommandNameForSpecialLineCommand Command:c ":" - DocumentContent?:content - Le EmptyLine* {block(c[:name], c[:ids], c[:classes], c[:args], c[:named_args],  content,  c[:ln])}
  def _LineCommand

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = apply(:_CommandNameForSpecialLineCommand)
      _tmp = _tmp ? nil : true
      self.pos = _save1
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Command)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = match_string(":")
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
      _tmp = apply(:_DocumentContent)
      @result = nil unless _tmp
      unless _tmp
        _tmp = true
        self.pos = _save2
      end
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Le)
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; block(c[:name], c[:ids], c[:classes], c[:args], c[:named_args],  content,  c[:ln]); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_LineCommand unless _tmp
    return _tmp
  end

  # LineBlock = (ItemsList | LineCommand)
  def _LineBlock

    _save = self.pos
    while true # choice
      _tmp = apply(:_ItemsList)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_LineCommand)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_LineBlock unless _tmp
    return _tmp
  end

  # Block = (PreformattedBlock | HeadedSection | LineBlock | ExplicitBlock | ParagraphGroup):block EmptyLine* {block}
  def _Block

    _save = self.pos
    while true # sequence

      _save1 = self.pos
      while true # choice
        _tmp = apply(:_PreformattedBlock)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_HeadedSection)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_LineBlock)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_ExplicitBlock)
        break if _tmp
        self.pos = _save1
        _tmp = apply(:_ParagraphGroup)
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
        _tmp = apply(:_EmptyLine)
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

    set_failed_rule :_Block unless _tmp
    return _tmp
  end

  # BlockDelimiter = (BlockHead | BlockEnd)
  def _BlockDelimiter

    _save = self.pos
    while true # choice
      _tmp = apply(:_BlockHead)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_BlockEnd)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_BlockDelimiter unless _tmp
    return _tmp
  end

  # ParagraphDelimiter = (BlockDelimiter | PreformattedCommandHead | LineBlock | Newpage | HeadedStart)
  def _ParagraphDelimiter

    _save = self.pos
    while true # choice
      _tmp = apply(:_BlockDelimiter)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_PreformattedCommandHead)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_LineBlock)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_Newpage)
      break if _tmp
      self.pos = _save
      _tmp = apply(:_HeadedStart)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_ParagraphDelimiter unless _tmp
    return _tmp
  end

  # HStartMark = - < "#"+ > &{ text.length == n }
  def _HStartMark(n)

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _text_start = self.pos
      _save1 = self.pos
      _tmp = match_string("#")
      if _tmp
        while true
          _tmp = match_string("#")
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
      _save2 = self.pos
      _tmp = begin;  text.length == n ; end
      self.pos = _save2
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_HStartMark unless _tmp
    return _tmp
  end

  # HMarkupTerminator = (- < "#"+ > - CharString:cs Le &{ text.length <= n && !cs.strip.end_with?('{') } | - Eof)
  def _HMarkupTerminator(n)

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _text_start = self.pos
        _save2 = self.pos
        _tmp = match_string("#")
        if _tmp
          while true
            _tmp = match_string("#")
            break unless _tmp
          end
          _tmp = true
        else
          self.pos = _save2
        end
        if _tmp
          text = get_text(_text_start)
        end
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_CharString)
        cs = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_Le)
        unless _tmp
          self.pos = _save1
          break
        end
        _save3 = self.pos
        _tmp = begin;  text.length <= n && !cs.strip.end_with?('{') ; end
        self.pos = _save3
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save4 = self.pos
      while true # sequence
        _tmp = apply(:__hyphen_)
        unless _tmp
          self.pos = _save4
          break
        end
        _tmp = apply(:_Eof)
        unless _tmp
          self.pos = _save4
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_HMarkupTerminator unless _tmp
    return _tmp
  end

  # HStart = - HStartMark(n) ln:ln - DocumentContent:s Le { { level: n, heading: s, ln: ln} }
  def _HStart(n)

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_HStartMark, n)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_DocumentContent)
      s = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Le)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  { level: n, heading: s, ln: ln} ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_HStart unless _tmp
    return _tmp
  end

  # HSection = HStart(n):h EmptyLine* (!HMarkupTerminator(n) Block)*:content EmptyLine* {h_section(h[:level], h[:heading], content, h[:ln])}
  def _HSection(n)

    _save = self.pos
    while true # sequence
      _tmp = apply_with_args(:_HStart, n)
      h = @result
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      _ary = []
      while true

        _save3 = self.pos
        while true # sequence
          _save4 = self.pos
          _tmp = apply_with_args(:_HMarkupTerminator, n)
          _tmp = _tmp ? nil : true
          self.pos = _save4
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:_Block)
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
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; h_section(h[:level], h[:heading], content, h[:ln]); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_HSection unless _tmp
    return _tmp
  end

  # BlockHStart = - HStartMark(n) ln:ln - DocumentContentExcept('{'):s - "{" - Nl { { level: n, heading: s, ln: ln} }
  def _BlockHStart(n)

    _save = self.pos
    while true # sequence
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_HStartMark, n)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply_with_args(:_DocumentContentExcept, '{')
      s = @result
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
      _tmp = apply(:_Nl)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin;  { level: n, heading: s, ln: ln} ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_BlockHStart unless _tmp
    return _tmp
  end

  # ExplicitHSection = BlockHStart(n):h EmptyLine* - BlockBody:content - BlockEnd {h_section(h[:level], h[:heading], content, h[:ln])}
  def _ExplicitHSection(n)

    _save = self.pos
    while true # sequence
      _tmp = apply_with_args(:_BlockHStart, n)
      h = @result
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_BlockBody)
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:__hyphen_)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_BlockEnd)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; h_section(h[:level], h[:heading], content, h[:ln]); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_ExplicitHSection unless _tmp
    return _tmp
  end

  # HeadedStart = (HStart(6) | HStart(5) | HStart(4) | HStart(3) | HStart(2) | HStart(1) | BlockHStart(6) | BlockHStart(5) | BlockHStart(4) | BlockHStart(3) | BlockHStart(2) | BlockHStart(1))
  def _HeadedStart

    _save = self.pos
    while true # choice
      _tmp = apply_with_args(:_HStart, 6)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_HStart, 5)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_HStart, 4)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_HStart, 3)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_HStart, 2)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_HStart, 1)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_BlockHStart, 6)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_BlockHStart, 5)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_BlockHStart, 4)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_BlockHStart, 3)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_BlockHStart, 2)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_BlockHStart, 1)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_HeadedStart unless _tmp
    return _tmp
  end

  # HeadedSection = (ExplicitHSection(6) | ExplicitHSection(5) | ExplicitHSection(4) | ExplicitHSection(3) | ExplicitHSection(2) | ExplicitHSection(1) | HSection(6) | HSection(5) | HSection(4) | HSection(3) | HSection(2) | HSection(1))
  def _HeadedSection

    _save = self.pos
    while true # choice
      _tmp = apply_with_args(:_ExplicitHSection, 6)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_ExplicitHSection, 5)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_ExplicitHSection, 4)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_ExplicitHSection, 3)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_ExplicitHSection, 2)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_ExplicitHSection, 1)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_HSection, 6)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_HSection, 5)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_HSection, 4)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_HSection, 3)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_HSection, 2)
      break if _tmp
      self.pos = _save
      _tmp = apply_with_args(:_HSection, 1)
      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_HeadedSection unless _tmp
    return _tmp
  end

  # FrontmatterSeparator = - "---" - Nl
  def _FrontmatterSeparator

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
      _tmp = apply(:_Nl)
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_FrontmatterSeparator unless _tmp
    return _tmp
  end

  # Frontmatter = FrontmatterSeparator ln:ln (!FrontmatterSeparator CharString Nl)+:yaml FrontmatterSeparator EmptyLine* {frontmatter(yaml, ln)}
  def _Frontmatter

    _save = self.pos
    while true # sequence
      _tmp = apply(:_FrontmatterSeparator)
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _ary = []

      _save2 = self.pos
      while true # sequence
        _save3 = self.pos
        _tmp = apply(:_FrontmatterSeparator)
        _tmp = _tmp ? nil : true
        self.pos = _save3
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_CharString)
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_Nl)
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
            _tmp = apply(:_FrontmatterSeparator)
            _tmp = _tmp ? nil : true
            self.pos = _save5
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_CharString)
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_Nl)
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
      _tmp = apply(:_FrontmatterSeparator)
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; frontmatter(yaml, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_Frontmatter unless _tmp
    return _tmp
  end

  # Char = < /[[:print:]]/ > { text }
  def _Char

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

    set_failed_rule :_Char unless _tmp
    return _tmp
  end

  # CharString = < Char* > { text }
  def _CharString

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      while true
        _tmp = apply(:_Char)
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

    set_failed_rule :_CharString unless _tmp
    return _tmp
  end

  # CharExcept = Char:c &{ e.is_a?(Regexp) ? e !~ c : e != c }
  def _CharExcept(e)

    _save = self.pos
    while true # sequence
      _tmp = apply(:_Char)
      c = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save1 = self.pos
      _tmp = begin;  e.is_a?(Regexp) ? e !~ c : e != c ; end
      self.pos = _save1
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_CharExcept unless _tmp
    return _tmp
  end

  # CharStringExcept = < CharExcept(e) > { text }
  def _CharStringExcept(e)

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _tmp = apply_with_args(:_CharExcept, e)
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

    set_failed_rule :_CharStringExcept unless _tmp
    return _tmp
  end

  # DocumentTextExcept = < (!Inline CharExcept(e))+ > ln:ln {text(text, ln)}
  def _DocumentTextExcept(e)

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _save1 = self.pos

      _save2 = self.pos
      while true # sequence
        _save3 = self.pos
        _tmp = apply(:_Inline)
        _tmp = _tmp ? nil : true
        self.pos = _save3
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply_with_args(:_CharExcept, e)
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      if _tmp
        while true

          _save4 = self.pos
          while true # sequence
            _save5 = self.pos
            _tmp = apply(:_Inline)
            _tmp = _tmp ? nil : true
            self.pos = _save5
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply_with_args(:_CharExcept, e)
            unless _tmp
              self.pos = _save4
            end
            break
          end # end sequence

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
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; text(text, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_DocumentTextExcept unless _tmp
    return _tmp
  end

  # DocumentContentExcept = (Inline | DocumentTextExcept(e))+:content { content }
  def _DocumentContentExcept(e)

    _save = self.pos
    while true # sequence
      _save1 = self.pos
      _ary = []

      _save2 = self.pos
      while true # choice
        _tmp = apply(:_Inline)
        break if _tmp
        self.pos = _save2
        _tmp = apply_with_args(:_DocumentTextExcept, e)
        break if _tmp
        self.pos = _save2
        break
      end # end choice

      if _tmp
        _ary << @result
        while true

          _save3 = self.pos
          while true # choice
            _tmp = apply(:_Inline)
            break if _tmp
            self.pos = _save3
            _tmp = apply_with_args(:_DocumentTextExcept, e)
            break if _tmp
            self.pos = _save3
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
      @result = begin;  content ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_DocumentContentExcept unless _tmp
    return _tmp
  end

  # DocumentText = < (!Inline Char)+ > ln:ln {text(text, ln)}
  def _DocumentText

    _save = self.pos
    while true # sequence
      _text_start = self.pos
      _save1 = self.pos

      _save2 = self.pos
      while true # sequence
        _save3 = self.pos
        _tmp = apply(:_Inline)
        _tmp = _tmp ? nil : true
        self.pos = _save3
        unless _tmp
          self.pos = _save2
          break
        end
        _tmp = apply(:_Char)
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      if _tmp
        while true

          _save4 = self.pos
          while true # sequence
            _save5 = self.pos
            _tmp = apply(:_Inline)
            _tmp = _tmp ? nil : true
            self.pos = _save5
            unless _tmp
              self.pos = _save4
              break
            end
            _tmp = apply(:_Char)
            unless _tmp
              self.pos = _save4
            end
            break
          end # end sequence

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
      _tmp = apply(:_ln)
      ln = @result
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; text(text, ln); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_DocumentText unless _tmp
    return _tmp
  end

  # DocumentContent = (Inline | DocumentText)+:content { content }
  def _DocumentContent

    _save = self.pos
    while true # sequence
      _save1 = self.pos
      _ary = []

      _save2 = self.pos
      while true # choice
        _tmp = apply(:_Inline)
        break if _tmp
        self.pos = _save2
        _tmp = apply(:_DocumentText)
        break if _tmp
        self.pos = _save2
        break
      end # end choice

      if _tmp
        _ary << @result
        while true

          _save3 = self.pos
          while true # choice
            _tmp = apply(:_Inline)
            break if _tmp
            self.pos = _save3
            _tmp = apply(:_DocumentText)
            break if _tmp
            self.pos = _save3
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
      @result = begin;  content ; end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_DocumentContent unless _tmp
    return _tmp
  end

  # DocumentLine = DocumentContent:content Le { content }
  def _DocumentLine

    _save = self.pos
    while true # sequence
      _tmp = apply(:_DocumentContent)
      content = @result
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Le)
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

    set_failed_rule :_DocumentLine unless _tmp
    return _tmp
  end

  # Page = Frontmatter?:frontmatter - (!Newpage Block)*:blocks EmptyLine* {page(([frontmatter] +  blocks).select{ |x| !x.nil?}, 1)}
  def _Page

    _save = self.pos
    while true # sequence
      _save1 = self.pos
      _tmp = apply(:_Frontmatter)
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
          _tmp = apply(:_Newpage)
          _tmp = _tmp ? nil : true
          self.pos = _save4
          unless _tmp
            self.pos = _save3
            break
          end
          _tmp = apply(:_Block)
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
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; page(([frontmatter] +  blocks).select{ |x| !x.nil?}, 1); end
      _tmp = true
      unless _tmp
        self.pos = _save
      end
      break
    end # end sequence

    set_failed_rule :_Page unless _tmp
    return _tmp
  end

  # Pages = (Page:page Newpage:newpage Pages:pages { [ page, newpage ] + pages } | Page:page { [ page ] })
  def _Pages

    _save = self.pos
    while true # choice

      _save1 = self.pos
      while true # sequence
        _tmp = apply(:_Page)
        page = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_Newpage)
        newpage = @result
        unless _tmp
          self.pos = _save1
          break
        end
        _tmp = apply(:_Pages)
        pages = @result
        unless _tmp
          self.pos = _save1
          break
        end
        @result = begin;  [ page, newpage ] + pages ; end
        _tmp = true
        unless _tmp
          self.pos = _save1
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save

      _save2 = self.pos
      while true # sequence
        _tmp = apply(:_Page)
        page = @result
        unless _tmp
          self.pos = _save2
          break
        end
        @result = begin;  [ page ] ; end
        _tmp = true
        unless _tmp
          self.pos = _save2
        end
        break
      end # end sequence

      break if _tmp
      self.pos = _save
      break
    end # end choice

    set_failed_rule :_Pages unless _tmp
    return _tmp
  end

  # root = BOM? EmptyLine* Pages:pages EofComment? Eof {root(pages)}
  def _root

    _save = self.pos
    while true # sequence
      _save1 = self.pos
      _tmp = apply(:_BOM)
      unless _tmp
        _tmp = true
        self.pos = _save1
      end
      unless _tmp
        self.pos = _save
        break
      end
      while true
        _tmp = apply(:_EmptyLine)
        break unless _tmp
      end
      _tmp = true
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Pages)
      pages = @result
      unless _tmp
        self.pos = _save
        break
      end
      _save3 = self.pos
      _tmp = apply(:_EofComment)
      unless _tmp
        _tmp = true
        self.pos = _save3
      end
      unless _tmp
        self.pos = _save
        break
      end
      _tmp = apply(:_Eof)
      unless _tmp
        self.pos = _save
        break
      end
      @result = begin; root(pages); end
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
  Rules[:_ln] = rule_info("ln", "{ current_line }")
  Rules[:_BOM] = rule_info("BOM", "/\\uFEFF/")
  Rules[:_Eof] = rule_info("Eof", "!.")
  Rules[:_Space] = rule_info("Space", "(\" \" | \"\\\\t\")")
  Rules[:__hyphen_] = rule_info("-", "Space*")
  Rules[:_EofComment] = rule_info("EofComment", "- \"//\" (!Eof .)*")
  Rules[:_Comment] = rule_info("Comment", "- \"//\" (!Nl .)* Nl EmptyLine*")
  Rules[:_EmptyLine] = rule_info("EmptyLine", "/^/ - (Nl | Comment | EofComment)")
  Rules[:_Nl] = rule_info("Nl", "/\\r?\\n/")
  Rules[:_Le] = rule_info("Le", "(Nl | Eof)")
  Rules[:_Word] = rule_info("Word", "< /[\\w]/ (\"-\" | /[\\w]/)* > { text }")
  Rules[:_Num] = rule_info("Num", "< [0-9]+ > { text.to_i }")
  Rules[:_ClassName] = rule_info("ClassName", "\".\" Word:classname { classname }")
  Rules[:_ClassNames] = rule_info("ClassNames", "ClassName*:classnames { classnames }")
  Rules[:_IdName] = rule_info("IdName", "\"\#\" Word:idname { idname }")
  Rules[:_IdNames] = rule_info("IdNames", "IdName*:idnames { idnames }")
  Rules[:_CommandName] = rule_info("CommandName", "Word:name IdNames?:idnames ClassNames?:classes ln:ln { {name: name, ids: idnames, classes: classes, ln:ln } }")
  Rules[:_ParameterNormal] = rule_info("ParameterNormal", "DocumentContentExcept(PARAMETER_END):content { content }")
  Rules[:_ParameterQuoted] = rule_info("ParameterQuoted", "\"\\\"\" DocumentContentExcept('\"'):content \"\\\"\" - &/[,)]/ { content }")
  Rules[:_ParameterSingleQuoted] = rule_info("ParameterSingleQuoted", "\"'\" DocumentContentExcept(\"'\"):content \"'\" - &/[,)]/ { content }")
  Rules[:_Parameter] = rule_info("Parameter", "(ParameterQuoted | ParameterSingleQuoted | ParameterNormal):value { value }")
  Rules[:_NParameterNormal] = rule_info("NParameterNormal", "< /[^,\\]]/* > { text }")
  Rules[:_NParameterQuoted] = rule_info("NParameterQuoted", "\"\\\"\" < /[^\"]/* > \"\\\"\" - &/[,\\]]/ { text }")
  Rules[:_NParameterSingleQuoted] = rule_info("NParameterSingleQuoted", "\"'\" < /[^']/* > \"'\" - &/[,\\]]/ { text }")
  Rules[:_NParameter] = rule_info("NParameter", "(NParameterQuoted | NParameterSingleQuoted | NParameterNormal):value { value }")
  Rules[:_Parameters] = rule_info("Parameters", "(Parameter:parameter \",\" - Parameters:parameters { [ parameter ] + parameters } | Parameter:parameter { [ parameter ] })")
  Rules[:_NamedParameter] = rule_info("NamedParameter", "Word:key - \":\" - NParameter:parameter { { key.to_sym => parameter } }")
  Rules[:_NamedParameters] = rule_info("NamedParameters", "(NamedParameter:parameter - \",\" - NamedParameters:parameters { parameter.merge parameters } | NamedParameter:parameter { parameter })")
  Rules[:_Command] = rule_info("Command", "CommandName:cn (\"(\" - Parameters:args - \")\")? (\"[\" - NamedParameters:named_args - \"]\")? { cn.merge({ args: args || [] , named_args: named_args || {}}) }")
  Rules[:_ImplicitParagraph] = rule_info("ImplicitParagraph", "- !ParagraphDelimiter Comment* DocumentLine:content ln:ln Comment* EofComment? {paragraph([],[], [], {}, content, ln)}")
  Rules[:_ExplicitParagraphCommand] = rule_info("ExplicitParagraphCommand", "Command:c &{ c[:name] == 'p' }")
  Rules[:_ExplicitParagraph] = rule_info("ExplicitParagraph", "- ExplicitParagraphCommand:c \":\" - DocumentContent?:content Le EmptyLine* {paragraph(c[:ids], c[:classes], c[:args], c[:named_args], content, c[:ln])}")
  Rules[:_Paragraph] = rule_info("Paragraph", "(ExplicitParagraph | ImplicitParagraph)")
  Rules[:_ParagraphGroup] = rule_info("ParagraphGroup", "ln:ln Paragraph+:p EmptyLine* {paragraph_group([],[],[],{},p, ln)}")
  Rules[:_BlockHead] = rule_info("BlockHead", "Command:command - \"{\" - Nl EmptyLine* { command }")
  Rules[:_BlockEnd] = rule_info("BlockEnd", "- \"}\" - Le EmptyLine*")
  Rules[:_BlockBody] = rule_info("BlockBody", "(!BlockEnd Block)+:body { body }")
  Rules[:_ExplicitBlock] = rule_info("ExplicitBlock", "- BlockHead:c - BlockBody:content - BlockEnd {block(c[:name], c[:ids], c[:classes], c[:args], c[:named_args], content,  c[:ln])}")
  Rules[:_PreformattedCommand] = rule_info("PreformattedCommand", "Command:command &{ ['pre', 'code'].include? command[:name] }")
  Rules[:_PreformattedCommandHeadSimple] = rule_info("PreformattedCommandHeadSimple", "PreformattedCommand:command - \"{\" - Nl { command }")
  Rules[:_PreformattedCommandHeadComplex] = rule_info("PreformattedCommandHeadComplex", "PreformattedCommand:command - \"{//\" Word?:codelanguage - Nl { command.merge({codelanguage: codelanguage}) }")
  Rules[:_PreformattedFence] = rule_info("PreformattedFence", "- \"```\" Word?:codelanguage (\"(\" - Parameters:args - \")\")? (\"[\" - NamedParameters:named_args - \"]\")? - Nl { {codelanguage: codelanguage,                      args: args || [],                      named_args: named_args || {} } }")
  Rules[:_PreformattedCommandHead] = rule_info("PreformattedCommandHead", "(PreformattedCommandHeadComplex | PreformattedCommandHeadSimple | PreformattedFence)")
  Rules[:_PreformatEndSimple] = rule_info("PreformatEndSimple", "- \"}\" - Le EmptyLine*")
  Rules[:_PreformatEndComplex] = rule_info("PreformatEndComplex", "- \"//}\" - Le EmptyLine*")
  Rules[:_PreformattedBlockSimple] = rule_info("PreformattedBlockSimple", "- PreformattedCommandHeadSimple:c (!PreformatEndSimple CharString Nl)+:content PreformatEndSimple {preformatted_block(c[:name], c[:ids], c[:classes], c[:args],  c[:named_args], c[:codelanguage], content,  c[:ln])}")
  Rules[:_PreformattedBlockComplex] = rule_info("PreformattedBlockComplex", "- PreformattedCommandHeadComplex:c (!PreformatEndComplex CharString Nl)+:content PreformatEndComplex {preformatted_block(c[:name], c[:ids], c[:classes], c[:args], c[:named_args],  c[:codelanguage], content,  c[:ln])}")
  Rules[:_PreformattedBlockFence] = rule_info("PreformattedBlockFence", "- ln:ln PreformattedFence:c (!\"```\" CharString Nl)+:content - \"```\" - Le EmptyLine* {preformatted_block('code', [], [], c[:args], c[:named_args], c[:codelanguage], content, ln)}")
  Rules[:_PreformattedBlock] = rule_info("PreformattedBlock", "(PreformattedBlockComplex | PreformattedBlockSimple | PreformattedBlockFence)")
  Rules[:_Inline] = rule_info("Inline", "(ImgInline | CommonInline)")
  Rules[:_CommonInline] = rule_info("CommonInline", "\"[\" Command:c \"{\" - DocumentContentExcept('}'):content \"}\" \"]\" {inline(c[:name], c[:ids], c[:classes], c[:args], c[:named_args],  content,  c[:ln])}")
  Rules[:_ImgCommand] = rule_info("ImgCommand", "Command:c &{ c[:name] == 'img' && c[:args].size == 2}")
  Rules[:_ImgInline] = rule_info("ImgInline", "\"[\" ImgCommand:c \"]\" {inline(c[:name], c[:ids], c[:classes], c[:args], c[:named_args],  nil,  c[:ln])}")
  Rules[:_CommandNameForSpecialLineCommand] = rule_info("CommandNameForSpecialLineCommand", "(NewpageCommand | ExplicitParagraphCommand)")
  Rules[:_NewpageCommand] = rule_info("NewpageCommand", "Command:command &{ command[:name] == 'newpage' }")
  Rules[:_Newpage] = rule_info("Newpage", "- NewpageCommand:c \":\" - DocumentContent?:content - Nl {newpage(c[:ids],c[:classes],c[:args], c[:named_args],  content,  c[:ln])}")
  Rules[:_UnorderedList] = rule_info("UnorderedList", "ln:ln UnorderedItem+:items {unordered_list([],[],[],{}, items, ln)}")
  Rules[:_UnorderedItem] = rule_info("UnorderedItem", "- ln:ln \"*\" - DocumentContent:content Le {ul_item([], [], [], {}, content, ln)}")
  Rules[:_OrderedList] = rule_info("OrderedList", "ln:ln OrderedItem+:items {ordered_list([],[],[], {}, items, ln)}")
  Rules[:_OrderedItem] = rule_info("OrderedItem", "- ln:ln Num \".\" - DocumentContent:content Le {ol_item([], [], [], {}, content, ln)}")
  Rules[:_DefinitionList] = rule_info("DefinitionList", "ln:ln DefinitionItem+:items {definition_list([], [], [], {}, items, ln)}")
  Rules[:_DefinitionItem] = rule_info("DefinitionItem", "- ln:ln - \";:\" - DocumentContentExcept(':'):term \":\" - DocumentContent:definition Le {dl_item([], [], [term], {}, definition, ln)}")
  Rules[:_LongDefinitionList] = rule_info("LongDefinitionList", "ln:ln LongDefinitionItem+:items {definition_list([], [], [], {}, items, ln)}")
  Rules[:_LongDefinitionItem] = rule_info("LongDefinitionItem", "- ln:ln \";:\" - DocumentContentExcept('{'):term \"{\" - Nl - BlockBody:definition - BlockEnd {dl_item([], [], [term], {}, definition, ln)}")
  Rules[:_ItemsList] = rule_info("ItemsList", "(UnorderedList | OrderedList | DefinitionList | LongDefinitionList)")
  Rules[:_LineCommand] = rule_info("LineCommand", "- !CommandNameForSpecialLineCommand Command:c \":\" - DocumentContent?:content - Le EmptyLine* {block(c[:name], c[:ids], c[:classes], c[:args], c[:named_args],  content,  c[:ln])}")
  Rules[:_LineBlock] = rule_info("LineBlock", "(ItemsList | LineCommand)")
  Rules[:_Block] = rule_info("Block", "(PreformattedBlock | HeadedSection | LineBlock | ExplicitBlock | ParagraphGroup):block EmptyLine* {block}")
  Rules[:_BlockDelimiter] = rule_info("BlockDelimiter", "(BlockHead | BlockEnd)")
  Rules[:_ParagraphDelimiter] = rule_info("ParagraphDelimiter", "(BlockDelimiter | PreformattedCommandHead | LineBlock | Newpage | HeadedStart)")
  Rules[:_HStartMark] = rule_info("HStartMark", "- < \"\#\"+ > &{ text.length == n }")
  Rules[:_HMarkupTerminator] = rule_info("HMarkupTerminator", "(- < \"\#\"+ > - CharString:cs Le &{ text.length <= n && !cs.strip.end_with?('{') } | - Eof)")
  Rules[:_HStart] = rule_info("HStart", "- HStartMark(n) ln:ln - DocumentContent:s Le { { level: n, heading: s, ln: ln} }")
  Rules[:_HSection] = rule_info("HSection", "HStart(n):h EmptyLine* (!HMarkupTerminator(n) Block)*:content EmptyLine* {h_section(h[:level], h[:heading], content, h[:ln])}")
  Rules[:_BlockHStart] = rule_info("BlockHStart", "- HStartMark(n) ln:ln - DocumentContentExcept('{'):s - \"{\" - Nl { { level: n, heading: s, ln: ln} }")
  Rules[:_ExplicitHSection] = rule_info("ExplicitHSection", "BlockHStart(n):h EmptyLine* - BlockBody:content - BlockEnd {h_section(h[:level], h[:heading], content, h[:ln])}")
  Rules[:_HeadedStart] = rule_info("HeadedStart", "(HStart(6) | HStart(5) | HStart(4) | HStart(3) | HStart(2) | HStart(1) | BlockHStart(6) | BlockHStart(5) | BlockHStart(4) | BlockHStart(3) | BlockHStart(2) | BlockHStart(1))")
  Rules[:_HeadedSection] = rule_info("HeadedSection", "(ExplicitHSection(6) | ExplicitHSection(5) | ExplicitHSection(4) | ExplicitHSection(3) | ExplicitHSection(2) | ExplicitHSection(1) | HSection(6) | HSection(5) | HSection(4) | HSection(3) | HSection(2) | HSection(1))")
  Rules[:_FrontmatterSeparator] = rule_info("FrontmatterSeparator", "- \"---\" - Nl")
  Rules[:_Frontmatter] = rule_info("Frontmatter", "FrontmatterSeparator ln:ln (!FrontmatterSeparator CharString Nl)+:yaml FrontmatterSeparator EmptyLine* {frontmatter(yaml, ln)}")
  Rules[:_Char] = rule_info("Char", "< /[[:print:]]/ > { text }")
  Rules[:_CharString] = rule_info("CharString", "< Char* > { text }")
  Rules[:_CharExcept] = rule_info("CharExcept", "Char:c &{ e.is_a?(Regexp) ? e !~ c : e != c }")
  Rules[:_CharStringExcept] = rule_info("CharStringExcept", "< CharExcept(e) > { text }")
  Rules[:_DocumentTextExcept] = rule_info("DocumentTextExcept", "< (!Inline CharExcept(e))+ > ln:ln {text(text, ln)}")
  Rules[:_DocumentContentExcept] = rule_info("DocumentContentExcept", "(Inline | DocumentTextExcept(e))+:content { content }")
  Rules[:_DocumentText] = rule_info("DocumentText", "< (!Inline Char)+ > ln:ln {text(text, ln)}")
  Rules[:_DocumentContent] = rule_info("DocumentContent", "(Inline | DocumentText)+:content { content }")
  Rules[:_DocumentLine] = rule_info("DocumentLine", "DocumentContent:content Le { content }")
  Rules[:_Page] = rule_info("Page", "Frontmatter?:frontmatter - (!Newpage Block)*:blocks EmptyLine* {page(([frontmatter] +  blocks).select{ |x| !x.nil?}, 1)}")
  Rules[:_Pages] = rule_info("Pages", "(Page:page Newpage:newpage Pages:pages { [ page, newpage ] + pages } | Page:page { [ page ] })")
  Rules[:_root] = rule_info("root", "BOM? EmptyLine* Pages:pages EofComment? Eof {root(pages)}")
  # :startdoc:
end

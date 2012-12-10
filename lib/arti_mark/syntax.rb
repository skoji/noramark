module ArtiMark
  class Syntax
    include CommandLexer

    attr_accessor :inline_handler, :linecommand_handler

    def initialize
      @inline_handler = Class.new do extend CommandLexer end
      @linecommand_handler = Class.new do extend CommandLexer end
      @block_parsers = []
      @block_parsers <<
        [
          Proc.new { |lines| lex_line_command(lines[0])[:cmd] == 'newpage' },
          Proc.new { 
            |lines, r, syntax|
            lexed = lex_line_command(lines.shift)
            if lexed[:params].size > 0
              title = lexed[:params].first
            else 
              title = nil
            end
            r.start_html(title)
          }
        ]

      [DivParser.instance, ArticleParser.instance, ParagraphParser.instance, HeadParser.instance].each {
          |parser|
          @block_parsers << [
            parser.method(:accept?),
            parser.method(:parse)
          ]
        }

      def @inline_handler.l(cls, param, text)
        "<a#{class_string(cls)} href='#{param[0]}'>#{text}</a>"
      end

    end

    def determine_parser(lines, opt = {})
      @block_parsers.each {
        |accept, parser|
        return parser if accept.call(lines)
      }
      if opt[:get_default]
          default_parser
      else
          nil
      end
    end

    def default_parser
      ParagraphParser.instance.method(:parse)
    end

    def parse(lines, r)
      throw "something wrong: #{lines}" if lines[0] == '}'  # TODO: should do something here with paragraph_parser
      if parser = determine_parser(lines)
        parser.call(lines, r, self)
      else
        default_parser.call(lines, r, self)
      end
    end

  end
end
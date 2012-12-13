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

      [DivParser.instance, ArticleParser.instance, ParagraphParser.instance, HeadParser.instance, BlockImageParser.instance].each {
          |parser|
          @block_parsers << [
            parser.method(:accept?),
            parser.method(:parse)
          ]
        }

      def @inline_handler.l(lexed)
        ref = lexed[:params][0].strip
        "<a#{class_string(lexed[:cls])} href='#{ref}'>#{lexed[:text]}</a>"
      end

      def @inline_handler.s(lexed)
        cls, text = lexed[:cls], lexed[:text]
        "<span#{class_string(cls)}>#{text.strip}</a>"
      end

      def @inline_handler.img(lexed)
        cls, param, text = lexed[:cls], lexed[:params], lexed[:text]
        "<img#{class_string(cls)} src='#{text}' alt='#{param.join(' ')}' />"
      end

      # universal inline command handler
      def @inline_handler.method_missing(cmd, *args)
        cls, param, text = args[0][:cls], args[0][:params], args[0][:text]
        "<#{cmd}#{class_string(cls)}>#{text}</#{cmd}>"
      end

      def @linecommand_handler.p(cls, param, text)
        "<p#{class_string(cls)}>#{text.strip}</p>\n"
      end

      #univarsal line command handler
      def @linecommand_handler.method_missing(cmd, *args)
        "<#{cmd}#{class_string(args[0])}>#{args[2].strip}</#{cmd}>\n"
      end


    end

    def determine_parser(lines, opt = {})
      @block_parsers.each {
        |accept, parser|
        return parser if accept.call(lines)
      }

      if UniversalBlockParser.instance.accept?(lines)
        UniversalBlockParser.instance.method(:parse)
      elsif opt[:get_default]
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
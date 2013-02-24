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
            |lines, context, syntax|
            lexed = lex_line_command(lines.shift)
            if lexed[:params].size > 0
              title = escape_html lexed[:params].first
            else 
              title = nil
            end
            context.start_html(title)
          }
        ]

      [DivParser.instance, ArticleParser.instance, ParagraphParser.instance, HeadParser.instance, BlockImageParser.instance, OrderedListParser.instance, UnorderedListParser.instance, DefinitionListParser.instance].each {
          |parser|
          @block_parsers << [
            parser.method(:accept?),
            parser.method(:parse)
          ]
        }

      def @inline_handler.l(lexed, context)
        ref = lexed[:params][0].strip
        "<a#{class_string(lexed[:cls])} href='#{ref}'>#{lexed[:text].strip}</a>"
      end

      def @inline_handler.link(lexed, context)
        l(lexed, context)
      end

      def @inline_handler.s(lexed, context)
        cls, text = lexed[:cls], lexed[:text]
        "<span#{class_string(cls)}>#{text.strip}</a>"
      end

      def @inline_handler.img(lexed, context)
        cls, param, text = lexed[:cls], lexed[:params], lexed[:text]
        "<img#{class_string(cls)} src='#{text.strip}' alt='#{param.join(' ')}' />"
      end

      def @inline_handler.ruby(lexed, context)
        cls, param, text = lexed[:cls], lexed[:params], lexed[:text]
        "<ruby#{class_string(cls)}>#{text.strip}<rp>(</rp><rt>#{param.join}</rt><rp>)</rp></ruby>"
      end

      # universal inline command handler
      def @inline_handler.method_missing(cmd, *args)
        cls, text = args[0][:cls], args[0][:text]
        "<#{cmd}#{class_string(cls)}>#{text.strip}</#{cmd}>"
      end

      def @linecommand_handler.p(lexed, context)
        cls, text = lexed[:cls], lexed[:text]
        "<p#{class_string(cls)}>#{text.strip}</p>\n"
      end

      def @linecommand_handler.stylesheets(lexed, context)
          context.stylesheets =  lexed[:text].split(',').map {|s|
            s.strip!
            if s =~ /^(.+?\.css):\((.+?)\)$/
              [$1, $2]
            else
              s
            end
          }
        ''
      end

      def @linecommand_handler.title(lexed, context)
        context.title = lexed[:text].strip
        ''
      end

      def @linecommand_handler.lang(lexed, context)
        context.lang = lexed[:text].strip
        ''
      end

      #univarsal line command handler
      def @linecommand_handler.method_missing(cmd, *args)
        "<#{cmd}#{class_string(args[0][:cls])}>#{args[0][:text].strip}</#{cmd}>\n"
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

    def parse(lines, context)
      throw "something wrong: #{lines}" if lines[0] == '}'  # TODO: should do something here with paragraph_parser
      if parser = determine_parser(lines)
        parser.call(lines, context, self)
      else
        default_parser.call(lines, context, self)
      end
    end

  end
end
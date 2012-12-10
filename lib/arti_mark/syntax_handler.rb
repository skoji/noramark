module ArtiMark
  class SyntaxHandler
    def initialize
      @block_parsers = []
      @block_parsers <<
        [
          Proc.new { |lines| lines[0] =~ /^newpage(,[\w ]+?)*:$/ },
          Proc.new { 
            |lines, r, syntax_handler|
            lines.shift
            if !$1.nil? && $1.size > 0
              title = $1[1..-1]
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
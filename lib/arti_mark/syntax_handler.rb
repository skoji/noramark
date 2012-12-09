module ArtiMark
  class SyntaxHandler
    def force_blocker?(lines)
    end
    def determine_parser(lines, opt = {})
      if DivParser.instance.accept?(lines)
        DivParser.instance.method(:parse)
      elsif ArticleParser.instance.accept?(lines)
        ArticleParser.instance.method(:parse)
      elsif lines[0].size == 0
        ParagraphParser.instance.method(:parse)
      elsif HeadParser.instance.accept?(lines)
        HeadParser.instance.method(:parse)
      else
        if opt[:get_default]
          default_parser
        else
          nil
        end
      end
    end

    def default_parser
      ParagraphParser.instance.method(:parse)
    end

    def parse(lines, r)
      if parser = determine_parser(lines)
        parser.call(lines, r, self)
      else
        default_parser.call(lines, r, self)
      end
    end

  end
end
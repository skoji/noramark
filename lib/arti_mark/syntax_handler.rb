module ArtiMark
  class SyntaxHandler
    def force_blocker?(lines)
      lines[0] =~ /^newpage(,[\w ]+?)*:$/
    end

    def determine_parser(lines, opt = {})
      if lines[0] =~ /^newpage(,[\w ]+?)*:$/
        Proc.new { 
          |the_lines, r, syntax_handler|
          the_lines.shift
          if !$1.nil? && $1.size > 0
            title = $1[1..-1]
          else 
            title = nil
          end
          r.start_html(title)
        }
      elsif DivParser.instance.accept?(lines)
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
      throw "something wrong: #{lines}" if lines[0] == '}'  # TODO: should do something here with paragraph_parser
      if parser = determine_parser(lines)
        parser.call(lines, r, self)
      else
        default_parser.call(lines, r, self)
      end
    end

  end
end
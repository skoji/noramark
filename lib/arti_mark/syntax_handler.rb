module ArtiMark
  class SyntaxHandler
    def determine_parser(line)
      if line =~ /^d(\.\w+?)*\s*{\s*$/
        DivParser.instance
      elsif line.size == 0
        ParagraphParser.instance
      else
        nil
      end
    end
    def parse(lines, r)
      if parser = determine_parser(lines[0])
        parser.parse(lines, r, self)
      else
        ParagraphParser.instance.parse(lines, r, self)
      end
    end

  end
end
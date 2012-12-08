module ArtiMark
  class SyntaxHandler
    def determine_parser(lines)
      ParagraphParser.instance
    end
  end
end
module ArtiMark
  class Parser
    def initialize(parameter = {})
      super
    end
    def parse_text(content)
        content.inject([]) do
        |result, item|
        if item.is_a? String
          s = result.last
          if s.is_a? String
            result.pop
          else
            s = ''
          end
          result.push s + item
        else
          result.push item
        end
      end
    end
  end
end


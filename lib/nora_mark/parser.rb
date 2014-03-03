require 'nora_mark/parser.kpeg'

module NoraMark
  class Parser

    def initialize(src, document_name: nil)
      @document_name = document_name
      super src
    end
    
    def create_item(type, command, children = [], raw: nil)
      children[0].sub!(/^[[:space:]]+/, '') if !children.nil? && children[0].is_a?(String)
      item = {:type => type, :children => children, :raw_text => raw }.merge command || {}
      item[:args] ||= []
      item[:named_args] = Hash[*(item[:args].select { |x| x.include?(':') }.map { |x| v = x.split(':', 2); [v[0].strip.to_sym, v[1]]}.flatten)]
      item
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


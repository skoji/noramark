module Nokogiri
  module XML
    class Element
      def selector_str
        selector = name
        if !self['id'].nil?
          selector = selector + '#' + self['id'].split(' ').join('#')
        end
        if !self['class'].nil?
          selector = selector + '.' + self['class'].split(' ').join('#')
        end
        selector
      end
      def selector_and_text
        [selector_str, text]
      end
    end
  end
end
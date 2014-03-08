module Nokogiri
  module XML
    class Element
      def selector remove_id: true
        sel = name
        if !remove_id && !self['id'].nil? 
          sel = sel + '#' + self['id'].split(' ').join('#')
        end
        if !self['class'].nil?
          sel = sel + '.' + self['class'].split(' ').join('.')
        end
        attributes.select{|k,v| k != 'class' && k != 'id'}.each {
          |name, value|
          sel = sel + "[#{name}='#{value}']"
        }
        sel
      end
      def selector_and_text remove_id: true
        [selector(remove_id: remove_id), text]
      end
      alias a selector_and_text
      def child_loop
        yield self
      end
      def child_a(index)
        element_children[index].selector_and_text
      end 
      def selector_and_children remove_id: true
        [selector(remove_id: remove_id)] + children.select{|c| c.elem? || c.text.strip.size > 0}.map{|c| 
          if !c.elem? 
            c.text
          elsif c.element_children.size == 0
            c.selector_and_text remove_id: remove_id
          else
            c.selector_and_children remove_id: remove_id
          end 
        }
      end
    end
  end
end

module NoraMark
  module Html
    DEFAULT_TRANSFORMER = TransformerFactory.create do
      modify 'ruby' do
        @node.append_child inline 'rp', '('
        @node.append_child inline 'rt', escape_html(@node.parameters[0].strip)
        @node.append_child inline 'rp', ')'
      end
      modify 'img' do
        @node.body_empty = true
        (@node.attrs ||= {}).merge!({src: [@node.parameters[0] ]})        
        @node.attrs.merge!({alt: [ escape_html(@node.parameters[1].strip)]}) if (@node.parameters.size > 1 && @node.parameters[1].size > 0)
      end
      replace 'image' do
        newnode = block('figure',
                        class_if_empty:'img-wrap',
                        ids: @node.ids,
                        children: [ inline('img', nil, attrs: {src: [ @node.parameters[0].strip],  alt: [ (@node.parameters[1] ||'').strip ] }) ],
                        template: @node)
        if !@node.children_empty?
          if @node.named_parameters[:caption_before] 
            newnode.prepend_child inline('figcaption', @node.children)
          else
            newnode.append_child inline('figcaption', @node.children)
          end
        end
        newnode
      end
    end
    DEFAULT_TRANSFORMER.extend Util
  end
end

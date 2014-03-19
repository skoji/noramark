module NoraMark
  module Html
    DEFAULT_TRANSFORMER = TransformerFactory.create do
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
  end
end

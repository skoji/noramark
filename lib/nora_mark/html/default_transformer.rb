module NoraMark
  module Html
    DEFAULT_TRANSFORMER = TransformerFactory.create do
      rename 'd', 'div'
      rename 'art', 'article'
      rename 'arti', 'article'
      rename 'sec', 'section'
      rename 'sect', 'section'
      rename 'sp', 'span'

      modify(/\A(l|link)\Z/) do
        @node.name = 'a'
        (@node.attrs ||= {}).merge!({href: [@node.paramtext[0]]})
      end

      modify 'ruby' do
        @node.append_child inline 'rp', '('
        @node.append_child inline 'rt', escape_html(@node.paramtext[0].strip)
        @node.append_child inline 'rp', ')'
      end

      modify 'tcy' do
        @node.name = 'span'
        @node.classes = ['tcy']
      end

      modify 'img' do
        @node.body_empty = true
        (@node.attrs ||= {}).merge!({src: [@node.paramtext[0] ]})        
        @node.attrs.merge!({alt: [ escape_html(@node.paramtext[1].strip)]}) if (@node.parameters.size > 1 && @node.paramtext[1].size > 0)
      end

      replace 'image' do
        newnode = block('figure',
                        class_if_empty:'img-wrap',
                        ids: @node.ids,
                        children: [ inline('img', nil, attrs: {src: [ @node.paramtext[0].strip],  alt: [ (@node.paramtext[1] ||'').strip ] }) ],
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

      replace({type: :OrderedList}) do
        block('ol', template: @node)
      end

      replace({type: :UnorderedList}) do
        block('ul', template: @node)
      end

      replace({type: :UlItem}) do
        block('li', template: @node)
      end

      replace({type: :OlItem}) do
        block('li', template: @node)
      end

      replace({type: :DefinitionList}) do
        block('dl', template: @node)
      end

      replace({type: :DLItem}) do
        [
         block('dt', @node.parameters[0], named_parameters: {chop_last_space: true}),
         block('dd', @node.children)
        ]
      end

      replace({type: :Breakline}) do
        newnode = block('br')
        newnode.body_empty = true
        newnode
      end

      replace({type: :HeadedSection}) do
        block('section', [ block("h#{@node.level}", @node.heading, ids: @node.named_parameters[:heading_id], named_parameters: {chop_last_space: true}) ] + @node.children, template: @node)
      end

      replace ({type: :PreformattedBlock}) do
        new_node = block('pre')
        if @node.codelanguage
          new_node.attrs = {'data-code-language' => [@node.codelanguage]}
          new_node.classes =  (@node.classes ||[]) << "code-#{@node.codelanguage}"
        end
        if @node.name == 'code'
          code = block('code', text(@node.content.join("\n")))
          new_node.children = [ code ]
        else
          new_node.children = [ text(@node.content.join("\n")) ]
        end
        if (@node.parameters || []).size> 0
          method = @node.named_parameters[:caption_after] ? :prepend : :append
          new_node = new_node.wrap block('div', classes: ['pre'], children: [ block('p', children: @node.parameters.shift, classes: ['caption']) ]), method
        end
        new_node
      end
    end
    DEFAULT_TRANSFORMER.extend Util
  end
end

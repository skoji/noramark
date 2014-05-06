class NoraMark::Document
  def to_html_book
    render_parameter(nonpaged: true)
    add_transformer(generator: :html) do
      modify type: :Root do
        first_page = @node.first_child
        first_page.add_attr 'data-type' => [ 'book' ]
        title = @frontmatter['title']
        first_page.prepend_child(
                                 block('h1', title)
                                 ) unless title.nil?
        
      end
      modify type: :HeadedSection do
        if @node.level == 1
          @node.add_attr 'data-type' => [ 'chapter' ]
        end
      end
    end
    html[0]
  end
end

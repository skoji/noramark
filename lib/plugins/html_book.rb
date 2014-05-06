class NoraMark::Document
  def to_html_book
    render_parameter(nonpaged: true)
    add_transformer(generator: :html) do
      modify type: :Root do
        first_page = @node.first_child
        first_page.attrs = { 'data-type' => [ 'book' ]}
        title = @frontmatter['title']
        first_page.prepend_child(
                                 block('h1', title)
                                 ) unless title.nil?
        
      end
    end
    html[0]
  end
end

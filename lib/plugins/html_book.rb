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
          node_type = @node.p[0] || "chapter"
          node_type = node_type.text unless node_type.is_a? String
          if (['chapter',
               'appendix',
               'afterword',
               'bibliography',
               'glossary',
               'preface',
               'foreword',
               'introduction',
               'halftitlepage',
               "titlepage",
               "copyright-page",
               "dedication",
               "colophon",
               "acknowledgments",
               "afterword",
               "conclusion",
               "index",
              ].member? node_type)
            @node.add_attr 'data-type' => [ node_type ]
          end
        else
          @node.level = @node.level - 1
          @node.add_attr 'data-type' => [ "sect#{@node.level}" ]     
        end
      end
    end
    html[0]
  end
end

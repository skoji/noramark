# -*- coding: utf-8 -*-
module NoraMark
  module Html
    class ParagraphWriter
      def initialize(generator)
        @generator = generator
        @context = generator.context
        @writer_set = { use_paragraph_group: {
          Paragraph =>
          TagWriter.create('p', @generator, chop_last_space: true, 
                           node_preprocessor: proc do |node|
                             first = node.children[0]
                             if first.kind_of? Text
                               first.content.sub!(/^[[:space:]]+/, '')
                               add_class(node, 'noindent') if first.content =~/^(「|『|（)/  # TODO: should be plaggable
                             end
                             node
                           end
                           ),
          ParagraphGroup =>
          TagWriter.create("div", @generator,
                           node_preprocessor: proc do |node|
                             add_class node, 'pgroup'
                             node.no_tag = true unless @context.enable_pgroup
                             node
                           end
                           )
          },
          default: {
            Paragraph =>
          TagWriter.create(nil, @generator, chop_last_space: true,
                           node_preprocessor: proc do |node|
                             node.no_tag = true
                             node
                           end),
            ParagraphGroup =>
          TagWriter.create("p", @generator,
                           node_preprocessor: proc do |node|
                             node.children = node.children.inject([]) do |memo, node|
                               memo << inline('br', body_empty: true, line_no: memo.last.line_no) if !memo.last.nil? && memo.last.kind_of?(Paragraph) && node.kind_of?(Paragraph)
                               memo << node
                             end
                             node
                           end
                           )
          }
        }
      end
      def write(node)
        writer_set = @writer_set[@context.paragraph_style] 
        writer_set = @writer_set[:default] if writer_set.nil?
        writer_set[node.class].write(node)
      end
    end
  end
end

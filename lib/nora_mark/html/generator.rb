# -*- coding: utf-8 -*-
require 'nora_mark/html/util'
require 'nora_mark/html/pages'
require 'nora_mark/html/context'
require 'nora_mark/html/tag_writer'
require 'nora_mark/html/frontmatter_writer'
require 'nora_mark/html/paragraph_writer'
require 'nora_mark/html/abstract_node_writer'
require 'nora_mark/html/default_transformer'

module NoraMark
  module Html
    class Generator
      include Util
      attr_reader :context
      def initialize(param = {})
        @context = Context.new(param)
        frontmatter_writer = FrontmatterWriter.new self
        paragraph_writer = ParagraphWriter.new self
        abstract_node_writer = AbstractNodeWriter.new self
        page_writer = TagWriter.create('body', self,
                                       node_preprocessor: proc do |node|
                                         @context.end_html
                                         if node.first_child.class == Frontmatter
                                           frontmatter = node.first_child
                                           frontmatter_writer.write frontmatter
                                           frontmatter.remove
                                         end
                                         node
                                       end);
        
        @writers = {
          Paragraph => paragraph_writer,
          ParagraphGroup => paragraph_writer,
          Inline =>TagWriter.create(nil, self, trailer: ''),
          Block => TagWriter.create(nil, self),
          Document =>  abstract_node_writer,
          Page =>  page_writer,
          Frontmatter =>  frontmatter_writer,
          }
      end

      def collect_id_and_headings 
        @id_pool = {}
        @headings = []

        all_nodes = @parsed_result.all_nodes
        all_nodes.each do
          |x|
          x.ids ||= []
          x.ids.each do
            |id|
            if !@id_pool[id].nil?
              warn "duplicate id #{id}"
            end
            @id_pool[id] = x
          end
          @headings << x if (x.kind_of?(Block) && x.name =~ /h[1-6]/) 
        end
      end
      def assign_id_to_headings 
        collect_id_and_headings
        count = 1
        @headings.each do
          |heading|
          if heading.ids.size == 0 
            begin 
              id = "heading_index_#{count}"
              count = count + 1
            end while @id_pool[id]
            heading.ids << id
          end
        end
      end

      def convert(parsed_result, render_parameter = {})
        DEFAULT_TRANSFORMER.options[:render_parameter] = render_parameter
        @parsed_result = DEFAULT_TRANSFORMER.transform parsed_result
        assign_id_to_headings 

        children = parsed_result.children
        @context.file_basename = parsed_result.document_name
        @context.render_parameter = render_parameter
        children.each {
          |node|
          to_html(node)
        }
        @context.set_toc generate_toc
        @context.result
      end

      def generate_toc
        @headings.map do
          |heading|
          { page: heading.ancestors(type: :Page)[0].page_no }.merge heading.heading_info
        end
      end

      def to_html(node)
        if node.kind_of? Text
          @context << escape_html(node.content)
        else
          writer = @writers[node.class]
          if writer.nil?
            warn "can't find html generator for \"#{node.class}\""
          else
            writer.write(node)
          end
        end
      end
    end
  end
end

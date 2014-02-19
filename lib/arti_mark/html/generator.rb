# -*- coding: utf-8 -*-
require 'arti_mark/html/util'
require 'arti_mark/html/result'
require 'arti_mark/html/context'
require 'arti_mark/html/tag_writer'
require 'arti_mark/html/writer_selector'
module ArtiMark
  module Html
    class Generator
      include Util
      attr_reader :context
      def initialize(param = {})
        @context = Context.new(param)
        article_writer = TagWriter.create('article', self)
        @writers = {
          :paragraph =>
          TagWriter.create('p', self,
                           item_preprocessor: proc do |item|
                             add_class(item, 'noindent') if item[:children][0] =~/^(「|『|（)/  # TODO: should be plaggable}
                             item
                           end
                           ),
          :paragraph_group =>
          TagWriter.create("div", self,
                           item_preprocessor: proc do |item|
                             add_class item, 'pgroup'
                             item[:no_tag] = true unless @context.enable_pgroup
                             item
                           end
                           ),

          :block =>
          WriterSelector.new(self,
                             {
                               'd' => TagWriter.create('div', self),
                               'art' => article_writer,
                               'article' => article_writer
                             }),
          :line_command =>
          WriterSelector.new(self,
                             {
                               'image' =>
                               TagWriter.create('div', self,
                                                item_preprocessor: proc do |item|
                                                  add_class_if_empty item, 'img-wrap'
                                                  item
                                                end,
                                                write_body_preprocessor: proc do |item|
                                                  src = item[:args][0].strip
                                                  alt = (item[:args][1] || '').strip
                                                  output "<img src='#{src}' alt='#{escape_html alt}' />"
                                                  output "<p>"
                                                  write_children item
                                                  output "</p>"
                                                  :done
                                                end
                                                )
                               })

          }
      end

      def convert(parsed_result)
        parsed_result.each {
          |item|
          to_html(item)
        }
        @context.result
      end

      def to_html(item)
        if item.is_a? String
          @context << item.strip
        else
          @writers[item[:type]].write(item)
        end
      end
    end
  end
end

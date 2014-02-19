# -*- coding: utf-8 -*-
require 'arti_mark/html/result'
require 'arti_mark/html/context'
require 'arti_mark/html/tag_writer'
require 'arti_mark/html/block_writer'
module ArtiMark
  module Html
    class Generator
      attr_reader :context
      def initialize(param = {})
        @context = Context.new(param)
        common_tag_writer = TagWriter.create(nil, self, trailer: "\n")
        @writers = {
          :paragraph =>
          TagWriter.create('p', self,
                           trailer: "\n",
                           item_preprocessor: proc do |item|
                             (item[:classes] ||= [] ) << 'noindent' if item[:children][0] =~/^(「|『|（)/  # TODO: should be plaggable}
                             item
                           end
                           ),
          :paragraph_group =>
          TagWriter.create("div", self,
                           trailer: "\n",
                           item_preprocessor: proc do |item|
                             (item[:classes] ||= []) << 'pgroup'
                             item[:no_tag] = true unless @context.enable_pgroup
                             item
                           end
                           ),
          :block => BlockWriter.new(self),
          :line_command => common_tag_writer
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

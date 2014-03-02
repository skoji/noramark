# -*- coding: utf-8 -*-
module NoraMark
  module Html
    class ParagraphWriter
      def initialize(generator)
        @generator = generator
        @context = generator.context
        @writer_set = { use_paragraph_group: {
          :paragraph =>
          TagWriter.create('p', @generator, chop_last_space: true,
                           item_preprocessor: proc do |item|
                             add_class(item, 'noindent') if item[:children][0] =~/^(「|『|（)/  # TODO: should be plaggable}
                             item
                           end
                           ),
          :paragraph_group =>
          TagWriter.create("div", @generator,
                           item_preprocessor: proc do |item|
                             add_class item, 'pgroup'
                             item[:no_tag] = true unless @context.enable_pgroup
                             item
                           end
                           )
          },
          default: {
          :paragraph => 
          TagWriter.create(nil, @generator, chop_last_space: true,
                           item_preprocessor: proc do |item|
                             item[:no_tag] = true
                             item
                           end),
          :paragraph_group =>
          TagWriter.create("p", @generator,
                           item_preprocessor: proc do |item|
                             item[:children] = item[:children].inject([]) do |memo, item|
                               memo << { :type => :br, :args => [] } if !memo.last.nil? && memo.last[:type] == :paragraph && item[:type] == :paragraph
                               memo << item
                             end
                             item
                           end
                           )
          }
        }
      end
      def write(item)
        writer_set = @writer_set[@context.paragraph_style]
        writer_set = @writer_set['default'] if writer_set.nil?
        writer_set[item[:type]].write(item)
      end
    end
  end
end

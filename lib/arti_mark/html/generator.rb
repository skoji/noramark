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
        link_writer = TagWriter.create('a', self, trailer: '', 
                                       item_preprocessor: proc do |item|
                                         (item[:attrs] ||= {}).merge!({:href => [ item[:args][0] ]})
                                         item
                                       end)

        @writers = {
          :paragraph =>
          TagWriter.create('p', self, chop_last_space: true,
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
                                                  caption_before = item[:named_args][:caption_before]
                                                  if caption_before && children_not_empty(item)
                                                    output "<p>"; write_children item; output "</p>"
                                                  end
                                                  output "<img src='#{src}' alt='#{escape_html alt}' />"
                                                  if !caption_before && children_not_empty(item)
                                                    output "<p>"; write_children item; output "</p>"
                                                  end
                                                  :done
                                                end
                                                ),
                               'newpage' =>
                               TagWriter.create('div', self,
                                                item_preprocessor: proc do |item|
                                                  item[:no_tag] = true
                                                  item
                                                end,
                                                write_body_preprocessor: proc do |item|
                                                  title = nil
                                                  if item[:args].size > 0 && item[:args][0].size > 0
                                                    title = escape_html item[:args].first
                                                  end
                                                  @context.start_html(title)
                                                  :done
                                                end
                                                ),

                               }),
          :inline =>
          WriterSelector.new(self, 
                             {
                               'link' => link_writer,
                               'l' => link_writer,
                               's' => TagWriter.create('span', self),
                               'img' =>
                               TagWriter.create('img', self,
                                                item_preprocessor: proc do |item|
                                                  item[:no_body] = true #TODO : it is not just an item's attribute, 'img_inline' has no body. maybe should specify in parser.{rb|kpeg}
                                                  (item[:attrs] ||= {}).merge!({:src => [item[:args][0] ]})
                                                  item[:attrs].merge!({:alt => [ escape_html(item[:args][1].strip)]}) if (item[:args].size > 1 && item[:args][1].size > 0)
                                                  item
                                                end)  ,
                               'tcy' =>
                               TagWriter.create('span', self,
                                                item_preprocessor: proc do |item|
                                                  add_class item, 'tcy'
                                                  item
                                                end),
                               'ruby' =>
                               TagWriter.create('ruby', self,
                                                write_body_preprocessor: proc do |item|
                                                  write_children item
                                                  output "<rp>(</rp><rt>#{escape_html item[:args][0].strip}</rt><rp>)</rp>"
                                                  :done
                                                end),
                               
                             },
                             trailer_default:''
                             ),
          :ol => TagWriter.create('ol', self),
          :ul => TagWriter.create('ul', self),
          :li => TagWriter.create('li', self)

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
          @context << escape_html(item)
        else
          writer = @writers[item[:type]]
          if writer.nil?
            warn "can't find html generator for \"#{item}\""
            @context << escape_html(item[:raw_text])
          else
            writer.write(item)
          end
        end
      end
    end
  end
end

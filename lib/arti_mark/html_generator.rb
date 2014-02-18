# -*- coding: utf-8 -*-
module ArtiMark
  class HtmlGenerator
    def attr_string(the_array, attr_name) 
      if the_array.size == 0
        ''
      else
        " #{attr_name}='#{the_array.join(' ')}'"
      end
    end

    def class_string(cls_array)
      attr_string(cls_array, 'class')
    end

    def ids_string(ids_array)
      attr_string(ids_array, 'id')
    end

    def initialize(context)
      @context = context
      @writers = {:paragraph => write_paragraph, :paragraph_group => write_paragraph_group}
    end
    def write_paragraph
      proc do |item|
        ids = item[:command][:ids] || []
        classes = item[:command][:classes] || []
        classes << 'noindent' if item[:children][0] =~/^(「|『|（)/ # TODO: should be plaggable
        @context << "<p#{ids_string(ids)}#{class_string(classes)}>"
        item[:children].each { |x| to_html(x) }
        @context << "</p>\n"
      end
    end
    def write_paragraph_group
      proc do |item|
      @context << "<div class='pgroup'>"
      item[:children].each { |x| to_html(x) }
      @context << " </div>\n"
      end
    end
    def to_html(item)
      if item.is_a? String
        @context << item.strip
      else
        @writers[item[:type]].call(item)
      end
    end
  end
end

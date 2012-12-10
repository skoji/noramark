module ArtiMark
  module CommandParser
    def class_string(cls_array)
      if cls_array.size == 0
        ''
      else
        " class='#{cls_array.join(' ')}'"
      end
    end

    def class_array(cls_part)
      cls_array = []
      if !cls_part.nil? && cls_part.size > 0
        cls_array = cls_part[1..-1].split('.')
      end
      cls_array
    end

  end
end
module ArtiMark
  module Html
    class WriterSelector
      def initialize(generator, tag_writers = {}, trailer_default: "\n" )
        @generator = generator
        @common_tag_writer = TagWriter.create(nil, @generator, trailer: trailer_default)
        @tag_writers = tag_writers
        if !trailer_default.nil?
          @tag_writers.each { |k, t|
            if t.is_a? TagWriter
              t.trailer = trailer_default
            end
          }
        end

      end

      def write(item)
        writer = @tag_writers[item[:name]] || @common_tag_writer
        writer.write(item)
      end
    end
  end
end

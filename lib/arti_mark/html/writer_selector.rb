module ArtiMark
  module Html
    class WriterSelector
      def initialize(generator, tag_writers = {})
        @generator = generator
        @common_tag_writer = TagWriter.create(nil, @generator)
        @tag_writers = tag_writers


      end

      def write(item)
        writer = @tag_writers[item[:name]] || @common_tag_writer
        writer.write(item)
      end
    end
  end
end

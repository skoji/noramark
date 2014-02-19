module ArtiMark
  module Html
    class BlockWriter
      def initialize(generator)
        @generator = generator
        @common_tag_writer = TagWriter.create(nil, @generator, trailer: "\n")
        @tag_writers = {
          'd' => TagWriter.create('div', @generator, trailer: "\n")
        }
      end

      def write(item)
        writer = @tag_writers[item[:name]] || @common_tag_writer
        writer.write(item)
      end
    end
  end
end

require 'securerandom'
module NoraMark
  module Html
    class Pages
      attr_reader :created_files
      attr_accessor :file_basename
      def initialize(sequence_format='%05d')
        @sequence_format = sequence_format || '%05d'
        @result = []
      end

      def last
        @result.last[:content]
      end

      def size
        @result.size
      end
      
      def <<(page)
        seq = @result.size + 1
        @result << { content: page, filename: filename_for_page(seq)}
      end

      def [](num)
        page = @result[num]
        page.nil? ? nil : page[:content]
      end

      def pages
        @result
      end

      def filename_for_page n
        "#{@file_basename}_#{@sequence_format%(n)}.xhtml"
      end

      def set_toc toc_data
        @toc = toc_data.map do |toc_line|
          fi = toc_line[:id] ? "##{toc_line[:id]}" : ''
          {link: "#{filename_for_page(toc_line[:page])}#{fi}", level: toc_line[:level], text: toc_line[:text]}
        end
      end
      def toc
        @toc
      end
      
      def write_as_files(directory: nil)
        dir = directory || Dir.pwd
        Dir.chdir(dir) do
          @result.each do
            |page|
            File.open(page[:filename], 'w+') do
              |file|
              file << page[:content]
            end
          end
        end
      end 
      def write_toc_as_file(directory: nil)
        return if @toc.nil?
        dir = directory || Dir.pwd
        Dir.chdir(dir) do
          File.open("#{@file_basename}.yaml", 'w+') do
            |file|
            file << YAML.dump(@toc)
          end
        end
      end
    end
  end
end


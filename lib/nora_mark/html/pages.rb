require 'securerandom'
module NoraMark
  module Html
    class Context
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
          @result << { content: page, filename: "#{@file_basename}_#{@sequence_format%(seq)}.xhtml" }
        end

        def [](num)
          page = @result[num]
          page.nil? ? nil : page[:content]
        end

        def pages
          @result
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
      end
    end
  end
end

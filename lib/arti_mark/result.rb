module ArtiMark
  class Context
    class Result < Array
      def initialize
        super
      end

      def write_as_files(prefix, format='%03d')
        self.each_with_index {
          |converted, i|
            File.open("#{prefix}_#{format%(i+1)}.xhtml", 'w+') {
            |file|
            file << converted
          }
        }
      end 
      def write_as_single_file(filename)
        File.open(filename, 'w+') {
          |file|
          file << self[0]
        }
      end
    end
  end
end
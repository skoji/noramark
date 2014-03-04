module NoraMark
  module Html
    class Context
      attr_accessor :title, :head_inserters, :toc, :lang, :stylesheets, :enable_pgroup
      def initialize(param = {})
        @head_inserters = []
        @toc = []
        @lang = param[:lang] || 'en'
        @title = param[:title] || 'NoraMark generated document'
        @stylesheets = param[:stylesheets] || []
        @enable_pgroup = param[:enable_pgroup] || true
        self.paragraph_style= param[:paragraph_style]
        @pages = Pages.new(param[:sequence_format])
        @block_delimiter_stack = []
        head_inserter do
          ret = ""
          @stylesheets.each { |s|
            if s.is_a? String
              ret << "<link rel=\"stylesheet\" type=\"text/css\" href=\"#{s}\" />\n"
            elsif s.is_a? Array
              ret << "<link rel=\"stylesheet\" type=\"text/css\" media=\"#{s[1]}\" href=\"#{s[0]}\" />\n"  
            else
              raise "Can't use #{s} as a stylesheet"
            end
          }
          ret
        end
      end

      def file_basename=(name)
        @pages.file_basename = name
      end
      
      def chop_last_space
        @pages.last.sub!(/[[:space:]]+$/, '')
      end

      def paragraph_style=(style)
        return if style.nil?
        raise "paragrapy_style accepts only :default or :use_paragraph_group but is #{style}" if style != :default && style != :use_paragraph_group
        @paragraph_style = style
      end
      
      def paragraph_style
        if @paragraph_style
          @paragraph_style
        elsif @lang.split('-')[0] == 'ja' 
          :use_paragraph_group
        else
          :default
        end
      end
      def head_inserter(&block)
        head_inserters << block
      end

      def start_html(title = nil)
        @title = title if !title.nil?
        if @pages.size >0 && !@pages.last.frozen?
          end_html
        end
        page = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        page << "<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"#{@lang}\" xml:lang=\"#{@lang}\">\n"
        page << "<head>\n"
        page << "<title>#{@title}</title>\n"
        @head_inserters.each {
          |f|
          page << f.call
        }
        page << "</head>\n"
        page << "<body>\n"
        @pages << page
        @toc << title
      end

      def end_html
        page = @pages.last
        if !page.frozen?
          page << "</body>\n"
          page << "</html>\n"
          page.freeze 
        end
      end

      def <<(text)
        if @pages.size == 0 || @pages.last.frozen?
          start_html
        end
        @pages.last << text
      end

      def result
        if !@pages.last.frozen?
          end_html
        end

        @pages
      end
    end
  end
end

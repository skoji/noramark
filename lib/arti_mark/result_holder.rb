module ArtiMark
  class ResultHolder
    attr_accessor :title
    def initialize(param = {})
      @lang = param[:lang] || 'en'
      @title = param[:title] || 'ArtiMark generated document'
      @pages = []
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
      # TODO : head inserter
      page << "</head>\n"
      page << "<body>\n"
      @pages << page
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
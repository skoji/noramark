module NoraMark
  module Html
    class Context
      attr_accessor :title, :head_inserters, :lang, :stylesheets, :enable_pgroup, :render_parameter, :namespaces, :metas
      def initialize(param = {})
        @default_param = param
        @head_inserters = []
        @lang = param[:lang] || 'en'
        @title = param[:title] || 'NoraMark generated document'
        @stylesheets = param[:stylesheets] || []
        @enable_pgroup = param[:enable_pgroup] || true
        self.paragraph_style = param[:paragraph_style]
        @pages = Pages.new(param[:sequence_format])
        @metas = param[:metas] || []
        @namespaces = {}
        @render_parameter = {}
        head_inserter do
          ret = ""
          @stylesheets.each do |s|
            if s.is_a? String
              ret << "<link rel=\"stylesheet\" type=\"text/css\" href=\"#{s}\" />\n"
            elsif s.is_a? Array
              ret << "<link rel=\"stylesheet\" type=\"text/css\" media=\"#{s[1]}\" href=\"#{s[0]}\" />\n"
            else
              raise "Can't use #{s} as a stylesheet"
            end
          end
          ret << @metas.map do |meta|
            "<meta " + meta.map do |k, v|
              "#{k}=\"#{v}\""
            end.join(" ") + " />"
          end.join("\n")
          ret
        end
      end

      def file_basename=(name)
        @pages.file_basename = name
      end

      def chop_last_space
        @pages.last.sub!(/[[:space:]]+\Z/, '')
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
        if @pages.size > 0 && !@pages.last.frozen?
          end_html
        end
        page = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        page << "<html xmlns=\"http://www.w3.org/1999/xhtml\""
        page << @namespaces.map do |k, v|
          " xmlns:#{k}=\"#{v}\""
        end.join(' ')
        page << " lang=\"#{@lang}\" xml:lang=\"#{@lang}\">\n"
        page << "<head>\n"
        page << "<title>#{@title}</title>\n"
        @head_inserters.each { |f|
          page << f.call
        }
        page << "</head>\n"
        @pages << page
      end

      def end_html
        return if @pages.size == 0

        page = @pages.last
        if !page.frozen?
          page << "</html>\n"
          page.freeze
        end
        restore_metas
      end

      # save metadata written with Frontmatter Writer
      def save_default_metas
        @default_param[:stylesheets] ||= @stylesheets if !@stylesheets.nil? && @stylesheets.size > 0
        @default_param[:title] ||= @title
        @default_param[:lang] ||= @lang
        @default_param[:paragraph_style] ||= @paragraph_style
        @default_param[:namespaces] ||=  @namespaces if !@namespaces.nil? && @namespaces.size > 0
        @default_param[:metas] ||= @metas if !@metas.nil? && @metas.size > 0
      end

      def restore_metas
        @stylesheets = @default_param[:stylesheets] || @stylesheets
        @title = @default_param[:title] || @title
        @lang = @default_param[:lang] || @lang
        @paragraph_style = @default_param[:paragraph_style] || @paragraph_style
        @namespaces = @default_param[:namespaces] || @namespaces
        @metas = @default_param[:metas] || @metas
      end

      def <<(text)
        if @pages.size == 0 || @pages.last.frozen?
          start_html
        end
        @pages.last << text
      end

      def set_toc toc
        @pages.set_toc toc
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

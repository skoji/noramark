module NoraMark
  module Html
    module Util
      def escape_html(string)
        string.to_s.gsub("&", "&amp;")
              .gsub("<", "&lt;")
              .gsub(">", "&gt;")
              .gsub('"', "&quot;")
              .gsub("'", "&#39;")
      end
    end
  end
end

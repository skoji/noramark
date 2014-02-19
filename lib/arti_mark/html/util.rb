module ArtiMark
  module Html
    module Util
      def escape_html(string)
        string.to_s.gsub("&", "&amp;").
          gsub("<", "&lt;").
          gsub(">", "&gt;").
          gsub('"', "&quot;")
      end
    end
  end
end

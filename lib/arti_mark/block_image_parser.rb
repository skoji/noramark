#require 'singleton'

module ArtiMark
  class BlockImageParser
    include BaseParser, Singleton
    def accept?(lines)
      lex_line_command(lines[0])[:cmd] =~ /image/
    end

    def parse(lines, r, syntax)
      lexed = lex_line_command(lines[0])
      raise 'HeadParser called for #{lines[0]}' unless lexed[:cmd] =~ /image/
      lines.shift
      lexed[:cls] << 'img-wrap' if lexed[:cls].size == 0
      src = lexed[:params][0].strip
      alt = lexed[:params][1].strip if !lexed[:params][1].nil?
      caption = lexed[:text].strip
      caption_before = lexed[:named_params][:caption_before]
      
      r << "<div#{ids_string(lexed[:ids])}#{class_string(lexed[:cls])}>"
      r << "<p>#{caption}</p>" if !caption.nil?  && caption.size > 0 && caption_before
      r << "<img src='#{src}' alt='#{alt}' />"
      r << "<p>#{caption}</p>" if !caption.nil?  && caption.size > 0 && !caption_before
      r << "</div>\n"
    end
  end
end

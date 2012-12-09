#require 'singleton'

module ArtiMark
  class HeadParser
    include BaseParser, Singleton
    def initialize
      @matcher = /^(\w+?)((?:\.\w*?)*):(.*?)$/
    end

    def accept?(lines)
      lines[0] =~ @matcher
      $1 =~ /h([1-6])/
    end

    def parse(lines, r, syntax_handler)
      lines[0] =~ @matcher
      cmd, cls, text = $1, class_array($2), $3
      raise 'HeadParser called for #{lines[0]}' unless cmd =~ /h([1-6])/
      lines.shift
      r << "<h#{$1}#{class_string(cls)}>#{text.strip}</h#{$1}>\n"
    end
  end
end
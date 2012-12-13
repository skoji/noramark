# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class UnorderedListParser
    include ListParser, Singleton
 
    def initialize
      @cmd = /\*/
      @blockname = 'ul'
    end

  end
end

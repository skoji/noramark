# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class OrderedListParser
    include ListParser, Singleton
 
    def initialize
      @cmd = /[0-9]+/
      @blockname = 'ol'
    end

  end
end

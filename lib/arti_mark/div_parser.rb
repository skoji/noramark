# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class DivParser
    include CommonBlockParser, Singleton
    def initialize
      @command = 'd'
      @markup = 'div'
    end
  end
end

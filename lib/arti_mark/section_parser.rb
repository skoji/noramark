# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class SectionParser
    include CommonBlockParser, Singleton
    def initialize
      @command = /(sec|section)/
      @markup = 'section'
    end
  end
end

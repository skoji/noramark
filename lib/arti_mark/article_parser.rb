# -*- encoding: utf-8 -*-
require 'singleton'

module ArtiMark
  class ArticleParser
    include CommonBlockParser, Singleton
    def initialize
      @command = 'art'
      @markup = 'article'
    end
  end
end

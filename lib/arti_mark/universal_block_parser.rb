require 'singleton'

module ArtiMark
  class UniversalBlockParser
    include CommonBlockParser, Singleton
    def initialize
      @command = /\w+/
    end
  end
end
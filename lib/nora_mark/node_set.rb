module NoraMark
  class NodeSet
    include Enumerable
    def initialize(list = [])
      list = list.to_ary if list.is_a? NodeSet
      @list = list
    end

    def [](n)
      @list[n]
    end

    def size
      @list.size
    end

    def each(&block)
      @list.each(&block)
    end

    def to_ary
      @list.dup
    end

    def first
      @list.first
    end

    def last
      @list.last
    end

    def text
      @list.inject('') { |r, n| r << n.text }
    end
  end
end

module NoraMark
  class NodeSet
    include Enumerable
    def initialize(list = [])
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
  end
end

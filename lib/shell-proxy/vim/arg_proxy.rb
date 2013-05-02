module VimProxy
  class ArgProxy
    def initialize(arity)
      @arity = arity
    end

    def [](no)
      return raw("a:arg#{no}")
    end

  end
end

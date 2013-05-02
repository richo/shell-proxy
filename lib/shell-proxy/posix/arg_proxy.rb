module PosixProxy
  class ArgProxy
    def initialize(arity)
      @arity = arity
    end

    def [](no)
      return raw("$#{no}")
    end

  end
end

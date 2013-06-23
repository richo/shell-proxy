module VimProxy
  class CaseStub
    def initialize(value, &block)
      @value = value
      @block = block
    end

    def __handle(buffer)
      # Vim has no case statement, so we assign to a local and pray.
      handler = CaseHandler.new(buffer)
      buffer << "let l:__case = #{@value}"
      buffer.indent
      @block.call(handler)
      buffer.undent
      buffer << "endif"
    end
  end

  class CaseHandler
    def initialize(buffer)
      @buffer = buffer
      @clauses = 0
    end

    def __escapinate(v)
      v
    end

    def when(opt, &block)
      stmt = "#{'else' if @clauses > 0}if l:__case == #{__escapinate(opt.to_s)}"
      @buffer << stmt
      @buffer.indent
      yield
      @buffer.undent
      @clauses += 1
    end
  end
end

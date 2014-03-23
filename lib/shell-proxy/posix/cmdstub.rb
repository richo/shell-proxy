module PosixProxy
  class CmdStub
    def initialize(buffer)
      @buffer = buffer
    end

    def emit(data)
      @emitter.call(data)
    end

    def |(other)
      # Append a pipe to the second last command in the stack
      last = @buffer.pop
      @buffer << "#{@buffer.pop} | #{last.strip}"
      self
    end
  end
end

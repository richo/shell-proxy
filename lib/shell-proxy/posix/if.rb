class IfStub
  def initialize(condition, &block)
    @condition = condition
    @block = block
  end

  def __handle(buffer)
    handler = IfHandler.new(buffer)
    buffer << "if #{@condition}"
    @block.call(handler)
    buffer << "fi"
  end
end

class IfHandler
  def initialize(buffer)
    @buffer = buffer
  end

  def then(&block)
    @buffer << "then"
    @buffer.indent
    block.call
    @buffer.undent
  end

  def elseif(condition, &block)
    @buffer << "else if #{condition}"
    @buffer.indent
    block.call
    @buffer.undent
  end

  def else(&block)
    @buffer << "else"
    @buffer.indent
    block.call
    @buffer.undent
  end
end

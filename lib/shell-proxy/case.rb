class CaseStub
  def initialize(value, &block)
    @value = value
    @block = block
  end

  def __handle(buffer)
    handler = CaseHandler.new(buffer)
    buffer << "case #{@value} in"
    buffer.indent
    @block.call(handler)
    buffer.undent
    buffer << "esac"
  end
end


class CaseHandler
  def initialize(buffer)
    @buffer = buffer
  end

  def __escapinate(v)
    if v.empty?
      '""'
    else
      v
    end
  end

  def when(opt, &block)
    @buffer << "#{__escapinate(opt.to_s)})"
    @buffer.indent
    yield
    @buffer.undent
    @buffer << ";;"
  end
end

class ForStub
  include ::Escaping

  def initialize(over, iter, &block)
    @over = over
    @iter = iter
    @block = block
  end

  def __handle(buffer)
    buffer << "for #{@iter} in #{__escapinate(@over)}; do"
    buffer.indent
    @block.call
    buffer.undent
    buffer << "done"
  end
end

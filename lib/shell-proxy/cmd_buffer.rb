class CmdBuffer
  def initialize
    @indent = 0
    @buffer = []
  end

  def indent
    @indent += 1
  end

  def undent
    @indent -= 1
  end

  def << (other)
    @buffer << "#{INDENT_PADDING * @indent}#{other}"
  end

  def pop
    @buffer.pop
  end

  def write(buf)
    @buffer.each do |l|
      buf.puts l
    end
    buf.flush
  end
end

class ShellWriter
  def initialize(to)
    case to
    when String
      @to = File.open(to)
    when IO
      @to = to
    else
      raise "I don't know what to do"
    end
  end

  def write(str)
    @to.write(str)
  end

  def puts(str)
    @to.puts(str)
  end

  def flush
    @to.flush
  end

end

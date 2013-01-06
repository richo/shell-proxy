class ShellProxy

  INDENT_PADDING="  "

  def initialize
    @indent = 0
  end

  def __main__(&block)
    instance_exec(&block)
  end

  def __subshell(&block)
    __emit("(")
    @indent += 1
    yield
    @indent -= 1
    __emit(")")
  end

  def __chdir(dir, &block)
    __subshell do
      cd(dir)
      yield
    end
  end

  def method_missing(sym, *args)
    opts = case args[-1]
           when Hash
             args.pop
           else
             {}
           end

    cmd = sym.to_s
    cmd << " #{__process_opts(opts)}" unless opts.empty?
    cmd << " #{__process_args(args)}"  unless args.empty?
    __emit cmd
  end

  def __emit(str)
    __writer.write(INDENT_PADDING * @indent)
    __writer.puts(str)
    __writer.flush
  end

  def __writer
    @writer ||= ShellWriter.new($stdout)
  end

  def __process_args(args)
    args.map do |v|
      __escapinate(v)
    end.join(" ")
  end

  def __process_opts(opts)
    outputs = []
    __process_and_escape(opts) do |value|
      outputs << value
    end
    outputs.join(" ")
  end

  def __process_and_escape(opts)
    opts.each do |k, v|
      k = k.to_s
      k = (k.length == 1 ? "-" : "--") + k
      yield __escapinate(k)
      yield __escapinate(v) unless v.nil?
    end
  end

  def __escapinate(v)
    "'#{v.gsub(/'/, "\\'").gsub("\\", "\\\\")}'"
  end

end

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

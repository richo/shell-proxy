class ShellProxy
  def method_missing(sym, *args)
    puts "#{sym} called with '#{args}'"
    opts = case args[-1]
           when Hash
             args.pop
           else
             {}
           end

    cmd = sym
    cmd << " #{__process(opts)}" unless opts.empty?
    cmd << " #{__escape(args)}"  unless args.empty?
    __emit cmd
  end

  def __emit(str)
    __writer.puts(str)
    __writer.flush
  end

  def __writer
    @writer ||= ShellWriter.new($stdout)
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

  def puts(str)
    @to.puts(str)
  end

  def flush
    @to.flush
  end

end

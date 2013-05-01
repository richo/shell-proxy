module PosixProxy include CommonProxy
end

%w[
  escaping.rb
  case.rb
  for.rb
  if.rb
].each do |f|
  require File.expand_path("../posix/#{f}", __FILE__)
end

module PosixProxy
  include Escaping

  def __subshell(&block)
    @cmd_buffer << "("
    @cmd_buffer.indent
    yield
    @cmd_buffer.undent
    @cmd_buffer << ")"
  end

  def __chdir(dir, &block)
    __subshell do
      cd(dir)
      yield
    end
  end

  def __case(value, &block)
    CaseStub.new(__escapinate(value), &block).__handle(@cmd_buffer)
  end

  def __for(over, iter, &block)
    ForStub.new(over, iter, &block).__handle(@cmd_buffer)
  end

  def __if(condition, &block)
    IfStub.new(condition, &block).__handle(@cmd_buffer)
  end

  def __set(variable, value)
    __eval("#{variable}=#{__escapinate(value)}")
  end

  def __unset(*variables)
    __eval("unset #{variables.join(" ")}")
  end

  def __export(variable, value=nil)
    export = "export #{variable}"
    export << "=#{__escapinate(value)}" if value
    __eval(export)
  end

  def __return(val)
    __eval("return #{__escapinate(val)}")
  end

  def __function(name, &block)
    @cmd_buffer << "function #{name}() {"
    @cmd_buffer.indent
    yield
    @cmd_buffer.undent
    @cmd_buffer << "}"
  end

  def method_missing(sym, *args)
    opts = case args[-1]
           when Hash
             args.pop
           else
             {}
           end

    stub = CmdStub.new(@cmd_buffer)

    cmd = sym.to_s
    cmd << " #{__process_opts(opts)}" unless opts.empty?
    cmd << " #{__process_args(args)}"  unless args.empty?
    @cmd_buffer << cmd
    stub
  end

  def __eval(str)
    @cmd_buffer << str
  end

  def __emit(str)
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

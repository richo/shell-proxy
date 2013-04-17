require_relative 'shell-proxy/escaping'
require_relative 'shell-proxy/case'
require_relative 'shell-proxy/for'

INDENT_PADDING="  "

class RawString < String
  def quote
    inspect
  end
end

class BareString < String
end

def raw(s)
  RawString.new(s)
end

def bare(s)
  BareString.new(s)
end

class ShellProxy
  include Escaping

  def __main__(&block)
    @cmd_buffer = CmdBuffer.new
    instance_exec(&block)
    @cmd_buffer.write(__writer)
  end

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
